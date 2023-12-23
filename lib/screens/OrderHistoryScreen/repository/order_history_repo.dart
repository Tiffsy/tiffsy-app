import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tiffsy_app/screens/OrderHistoryScreen/model/order_history_model.dart';

class OrderHistoryRepo {
  static Future<List<OrderHistoryModel>> fetchOrderHistory() async {
    List<OrderHistoryModel> orderHistory = [];
    try {
      http.Response response = await http
          .get(Uri.parse("http://10.0.2.2:4000/tiffsy/get-order-history"));
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
