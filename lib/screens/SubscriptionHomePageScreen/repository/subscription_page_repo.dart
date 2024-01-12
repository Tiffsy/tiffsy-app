import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tiffsy_app/Constants/network_contants.dart';
import 'package:tiffsy_app/Helpers/result.dart';
import 'package:tiffsy_app/screens/SubscriptionHomePageScreen/model/subscription_page_model.dart';

class SubscriptionPageRepo {
  static Future<Result<List<SubscriptionDataModel>>>
      fetchSubscriptionList() async {
    try {
      // String cst_id = Hive.box('customer_box').get('cst_id');
      // Map<String, dynamic> params = {
      //   "cst_id": cst_id
      // };
      List<SubscriptionDataModel> subcriptionList = [];
      var response = await http.post(Uri.parse('$apiJsURL/get-subcription'));
      List result = jsonDecode(response.body);
      for (int i = 0; i < result.length; i++) {
        SubscriptionDataModel subscription =
            SubscriptionDataModel.fromJson(result[i]);
        subcriptionList.add(subscription);
      }
      print(subcriptionList);
      return Result(data: subcriptionList, error: null);
    } catch (err) {
      return Result(data: null, error: err.toString());
    }
  }
}
