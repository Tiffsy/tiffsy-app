import 'dart:convert';
import 'package:tiffsy_app/Helpers/result.dart';
import 'package:tiffsy_app/Constants/network_contants.dart';
import 'package:http/http.dart' as http;

class CalendarRepo{

  static Future<Result<List<DateTime>>> fetchCalendarDates(String cst_id) async {
    try{
      List<DateTime> dateList = [];
      Map<String, dynamic> params = {
          "cst_id": cst_id
      };
      var response = await http.post(Uri.parse('$apiJsURL/order-dates'), body: params);
      List<String> dateStrings = jsonDecode(response.body).cast<String>();
      List<DateTime> result = dateStrings.map((e) => DateTime.parse(e)).toList();
      return Result(data: result, error: null);
    }
    catch(err){
      return Result(data: null, error: err.toString());
    }  
  }

  static Future<Result<String>>  cancelOrder(String cst_id, DateTime date) async {
    try{
      Map<String, dynamic> params = {
          "cst_id": cst_id,
          "date": date
      };
      var response = await http.post(Uri.parse('$apiJsURL/cancel-order-date'), body: params);
      Map<String, dynamic> result = jsonDecode(response.body);
      return Result(data: result["status"], error: null);
    }
    catch(err){
      return Result(data: null, error: err.toString());
    }
  }
  
  static Future<Result<List<DateTime>>> fetchCancelOrderDates(String cst_id) async {
    try{
      Map<String, dynamic> params = {
        "cst_id": cst_id,
      };
      var response = await http.post(Uri.parse('$apiJsURL/get-cancel-dates'), body: params);
      print("Raj" + response.body);
      List<String> dateStrings = jsonDecode(response.body).cast<String>();
      List<DateTime> result = dateStrings.map((e) => DateTime.parse(e)).toList();

      print(result);  
      return Result(data: result, error: null);
    }
    catch(err){
      return Result(data: null, error: err.toString());
    }
  }
}