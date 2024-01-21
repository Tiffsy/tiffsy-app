import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:tiffsy_app/Helpers/result.dart';
import 'package:tiffsy_app/screens/PaymentHistoryScreen/model/payment_history_model.dart';
import 'package:http/http.dart' as http;
import 'package:tiffsy_app/Constants/network_contants.dart';

class PaymentHistoryRepo {
  static Future<Result<List<PaymentHistoryDataModel>>> fetchPaymentHistory() async {
    try{

      Box customer_box = Hive.box("customer_box");
      String token = customer_box.get("token");
      String cst_id = customer_box.get("cst_id");
      Map<String, dynamic> params = {
        "cst_id": cst_id
      };
      List<PaymentHistoryDataModel> paymentList = [];
      var response = await http.post(Uri.parse('$apiJsURL/get-trnx-history'),body: params, headers: {'Authorization': 'Bearer $token'});
      Map<String, dynamic> res = jsonDecode(response.body);
      List result = res["data"];

      for(int i = 0; i < result.length; i++){
        PaymentHistoryDataModel payment = PaymentHistoryDataModel.formJson(result[i]);
        paymentList.add(payment);
      }
      return Result(data: paymentList, error: null);
    }
    catch(err){
      return Result(data: null, error: err.toString());
    }
  }
}
