import 'dart:convert';
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
      var response = await http.post(Uri.parse('$apiJsURL/get-order-by-Subscription'), body: params);
      List result = jsonDecode(response.body); 
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

  
  static Future<void> cancelOrder(String cst_id, String subs_id,  String dt, int bc, int lc, int dc){

    return Future(() => {});
  }

}