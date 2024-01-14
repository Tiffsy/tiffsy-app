import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:tiffsy_app/Helpers/result.dart';
import 'package:tiffsy_app/Constants/network_contants.dart';
import 'package:http/http.dart' as http;
import 'package:tiffsy_app/screens/CalendarScreen/model/calendar_date_model.dart';

class CalendarRepo{

  static Future<Result<List<CalendarDataModel>>> fetchCalendarDates(String cst_id, String subs_id) async {
    try{
      List<DateTime> dateList = [];
      List<CalendarDataModel> calendarData= [];
      Map<String, dynamic> params = {
          "cst_id": cst_id,
          "subs_id": subs_id
      };
      Box customer_box = Hive.box("customer_box");
      String token = customer_box.get("token");
      var response = await http.post(Uri.parse('$apiJsURL/get-order-by-Subscription'), body: params, headers: {'Authorization': 'Bearer $token'});
      Map<String, dynamic> res = jsonDecode(response.body);
      List result = res["data"];
      for(int i = 0; i < result.length; i++){
        CalendarDataModel cldData = CalendarDataModel.fromJson(result[i]);
        dateList.add(DateTime.parse(cldData.dt));
        calendarData.add(cldData);
      }
      return Result(data: calendarData, error: null);
    }
    catch(err){
      return Result(data: null, error: err.toString());
    }  
  }  
  

  static Future<Result<String>> cancelOrder(String ordr_id, String dt, int lc, int bc, int dc) async {
    try {
      Box customer_box = Hive.box("customer_box");
      String token = customer_box.get("token");
      String cst_id = customer_box.get("cst_id");
      Map<String, dynamic> params = {
        "cst_id": cst_id,
        "ordr_id": ordr_id,
        "lc": lc.toString(),
        "bc": bc.toString(),
        "dc": dc.toString()
      };
      print(params);
      print(token);
      var response = await http
          .post(Uri.parse('$apiJsURL/cancel-order-date'), body: params, headers: {'Authorization': 'Bearer $token'});
      Map<String, dynamic> res = jsonDecode(response.body);
      print(response.body);
      print(res);
      String result = res["result"];
      return Result(data: result, error: null);
    } catch (err) {
      return Result(data: null, error: err.toString());
    }
  }

}