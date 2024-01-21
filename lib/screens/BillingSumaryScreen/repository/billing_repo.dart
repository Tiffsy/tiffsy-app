import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:tiffsy_app/Constants/network_contants.dart';
import 'package:tiffsy_app/Helpers/result.dart';
import 'package:uuid/uuid.dart';

class BillingRepo {

  static Future<Result<String>> addSubscription() async {
    try {
      Box customer_box = Hive.box("customer_box");
      Box address_box = Hive.box("address_box");
      Box cart_box = Hive.box("cart_box");

      String addr_line = address_box.get("default_address")["addr_line"];
      String addr_id = address_box.get("default_address")["addr_id"];

      String cst_id = customer_box.get('cst_id');
      String token = customer_box.get("token");
      String ordr_type =
          cart_box.get("is_subscription") ? "subscription" : "onetime";

      if (cart_box.get("is_subscription")) {
        int lc = 0;
        int bc = 0;
        int dc = 0;
        String lchMealType = "";
        String brkMealType = "";
        String dinMealType = "";
        int bill = 0;
        List cart = cart_box.get("cart");
        int subType = cart_box.get("subType");
        String nickname = cart_box.get("sub_name");
        String remark = cart_box.get("sub_instructions");
        String strdt = cart_box.get("start_date").toString();
        String enddt = cart_box.get("end_date").toString();
        String cntct = customer_box.get("cst_contact");

        for (var element in cart) {
          if (element[0]["mealTime"] == "lunch") {
            lc = 1;
            lchMealType = element[0]["mealType"]; 
          } else if (element[0]["mealTime"] == "dinner") {
            dc = 1;
            dinMealType = element[0]["mealType"];
          } else if (element[0]["mealTime"] == "breakfast") {
            bc = 1;
            brkMealType = element[0]["mealType"];
          }
          bill += int.parse(element[0]["price"].toString());
        }
         var uuid = Uuid();
        String sbcr_id = uuid.v4().toString();

        bill = (bill*subType);
        Map<dynamic, dynamic> params = {
          "sbcr_id": sbcr_id,
          "cst_id": cst_id,
          "str_dt": strdt,
          "end_dt": enddt,
          "bc": bc.toString(),
          "lc": lc.toString(),
          "dc": dc.toString(),
          "brkMealType": brkMealType, 
          "lchMealType": lchMealType, 
          "dinMealType": dinMealType,
          "cntct": cntct, 
          "bill": bill.toString(),
          "ts": DateTime.now().toString(), 
          "addr_line": addr_line,
          "addr_id": addr_id, 
          "subtype": subType.toString(),
          "remark": remark,
          "nickname": nickname,
          "ordr_type": ordr_type
        };

        print(params);
        var res = await http.post(Uri.parse('$apiJsURL/add-subscription'), body: params, headers: {'Authorization': 'Bearer $token'});
        if(res.statusCode == 200){
          return Result(data: sbcr_id, error: null); 
        }
        else{
          return Result(data: null, error: "ERROR");
        }

      } else {
        List cart = cart_box.get("cart");
        String remark = cart_box.get("sub_instructions");
        String strdt = cart_box.get("start_date").toString();
        // String enddt = cart_box.get("end_date").toString();
        String cntct = customer_box.get("cst_contact");
        int bill = 0;

        List<Map<dynamic, dynamic>> ordr = [];
        for(var element in cart){
          Map<dynamic, dynamic> tmp = {};
          bill += int.parse(element[0]["price"].toString())*int.parse(element[1].toString());
          tmp["mealType"] = element[0]["mealType"];
          tmp["mealTime"] = element[0]["mealTime"]; 
          tmp["count"] = element[1];
          ordr.add(tmp);
        }

        Map<dynamic, dynamic> params = {
          "cst_id": cst_id,
          "str_dt": strdt,
          "cntct": cntct, 
          "bill": bill.toString(),
          "ts": DateTime.now().toString(), 
          "addr_line": addr_line,
          "addr_id": addr_id, 
          "remark": remark,
          "ordr": jsonEncode(ordr).toString()
        };
        print(params);
        var res = await http.post(Uri.parse('$apiJsURL/today-order'), body: params, headers: {'Authorization': 'Bearer $token'});
        if(res.statusCode == 200){
          return Result(data: "SUCCESS", error: null); 
        }
        else{
          return Result(data: null, error: "ERROR");
        }
      }
    } catch (err) {
      return Result(data: null, error: err.toString());
    }
  }

  static Future<Result<String>> addTransaction(String paymentId, int amount, String sbcr_id) async {
    Box customer_box = Hive.box("customer_box");
    String cst_id = customer_box.get('cst_id');
    String token = customer_box.get("token");
    try{
      Map<dynamic, dynamic> params = {
        "trn_id": paymentId,
        "sbcr_id": sbcr_id,
        "amt": amount.toString(),
        "cst_id": cst_id,
        "ts": DateTime.now().toString()
      };

      var res = await http.post(Uri.parse('$apiJsURL/add-trxn'), body: params, headers: {'Authorization': 'Bearer $token'});
      print(res.body);
      if(res.statusCode == 200){
          print(res.body);
          return Result(data: "SUCCESS", error: null); 
        }
        else{
          return Result(data: null, error: "ERROR");
        }
    }
    catch(err){
      return Result(data: null, error: err.toString());
    }
  }
}
