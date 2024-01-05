import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:tiffsy_app/Constants/network_contants.dart';
import 'package:tiffsy_app/screens/OrderHistoryScreen/model/order_history_model.dart';

class OrderHistoryRepo {
  static Future<List<OrderHistoryModel>> fetchOrderHistory() async {
    List<OrderHistoryModel> orderHistory = [];
    try {
      String cst_id = Hive.box('customer_box').get('cst_id');
      Map<String, dynamic> params = {
        "cst_id": cst_id
      };
      http.Response response = await http
          .post(Uri.parse('$apiJsURL/get-order-history'),body: params);
      List responseItems = jsonDecode(response.body);
      print(responseItems);
      for (var element in responseItems) {
        orderHistory.add(OrderHistoryModel.fromJson(element));
      }
      return orderHistory;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
