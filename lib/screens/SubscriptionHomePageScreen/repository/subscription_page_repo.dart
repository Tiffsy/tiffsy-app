import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:tiffsy_app/Constants/network_contants.dart';
import 'package:tiffsy_app/Helpers/result.dart';
import 'package:tiffsy_app/screens/SubscriptionHomePageScreen/model/subscription_page_model.dart';

class SubscriptionPageRepo {
  static Future<Result<List<SubscriptionDataModel>>>
      fetchSubscriptionList() async {
    try {
      Box customer_box = Hive.box("customer_box");
      String token = customer_box.get("token");
      String cst_id = customer_box.get("cst_id");
      Map<String, dynamic> params = {
        "cst_id": cst_id
      };
      List<SubscriptionDataModel> subcriptionList = [];
      var response = await http.post(Uri.parse('$apiJsURL/get-subcription'),body: params, headers: {'Authorization': 'Bearer $token'});
      Map<String, dynamic> res = jsonDecode(response.body);
      List result = res["data"];
      print(result);
      for (int i = 0; i < result.length; i++) {
        SubscriptionDataModel subscription =
            SubscriptionDataModel.fromJson(result[i]);
        subcriptionList.add(subscription);
      }
      return Result(data: subcriptionList, error: null);
    } catch (err) {
      return Result(data: null, error: err.toString());
    }
  }
}
