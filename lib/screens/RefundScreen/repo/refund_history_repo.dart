import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:tiffsy_app/Constants/network_contants.dart';
import 'package:tiffsy_app/Helpers/result.dart';
import 'package:tiffsy_app/screens/RefundScreen/model/refund_data_model.dart';
import 'package:http/http.dart' as http;

class RefundHistoryRepo {
  static Future<Result<List<RefundDataModel>>> fetchRefundHistory() async {
    try {
      Box customer_box = Hive.box("customer_box");
      String token = customer_box.get("token");
      String cst_id = customer_box.get("cst_id");
      Map<String, dynamic> params = {"cst_id": cst_id};
      List<RefundDataModel> refundList = [];
      var response = await http.post(Uri.parse('$apiJsURL/get-refund-history'),
          body: params, headers: {'Authorization': 'Bearer $token'});
      print(response.body);
      Map<String, dynamic> res = jsonDecode(response.body);
      List result = res["data"];
      for(int i = 0; i<result.length; i++){
        RefundDataModel refund = RefundDataModel.fromJson(result[i]);
        refundList.add(refund);
      }
      return Result(data: refundList, error: null);
    } catch (err) {
      return Result(data: null, error: err.toString());
    }
  }
}
