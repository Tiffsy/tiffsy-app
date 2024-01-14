import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:tiffsy_app/Constants/network_contants.dart';
import 'package:tiffsy_app/Helpers/result.dart';

class PaymentCheckoutOptions {
  static String _apiKey = "";
  static Razorpay _razorpay = Razorpay();

  static void googlePayUPI(String orderID, double amount) async {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    int amountInPaisa = (amount * 100).floor();
    Map<String, dynamic> options = {
      "key": "rzp_test_AUti41jFaX94OY",
      "amount": amountInPaisa,
      "currency": "INR",
      "name": "Tiffsy",
      "timeout": 300,
      "prefill": {"contact": "8766896322", "email": "psomani16k@gmail.com"},
      "method": {"upi": "1"},
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      print("___________________________________");
      print(e.toString());
    }
  }

  static Future<Result<String>> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try{
      String cst_id = Hive.box('customer_box').get('cst_id');
      String token = Hive.box('customer_box').get('token');
      String addr_line = Hive.box("addr_box").get("addr");
      String addr_id = Hive.box("addr_box").get("addr_id");
      String strdt = Hive.box("cart_box").get("start_date");
      String enddt = Hive.box("cart_box").get("end_date");
      String cntct = Hive.box("customer_box").get("cst_contact");
      int lc = 0;
      int bc = 0;
      int dc = 0;
      String lchMealType = "";
      String brkMealType = "";
      String dinMealType = "";
      List cart = Hive.box("cart_box").get("cart");
      int subType = Hive.box("cart_box").get("subType");
      int bill = 0;
      print(cart);
      for(var element in cart){
        if(element["mealTime"] == "lunch"){
          lc = 1;
          lchMealType = element["mealType"];
          bill+=int.parse(element["price"].toString());
        }
        else if(element["mealTime"] == "dinner"){
          dc = 1;
          dinMealType = element["mealType"];
          bill+=int.parse(element["price"].toString());
        }
        else if(element["mealTime"] == "breakfast"){
          bc = 1;
          brkMealType = element["mealType"];
          bill+=int.parse(element["price"].toString());
        }
      }

      bill=(bill*subType);
      Map<String, dynamic> params = {
         "cst_id": cst_id, 
        "str_dt": strdt, 
        "end_dt": enddt, 
        "bc": bc, 
        "lc": lc, 
        "dc": dc, 
        "brkMealType": brkMealType, 
        "lchMealType": lchMealType, 
        "dinMealType": dinMealType, 
        "cntct": cntct, 
        "bill": bill, 
        "ts": DateTime.now().toString(), 
        "addr_line": addr_line, 
        "addr_id": addr_id, 
        "subtype": subType 
      };
      var res = await http.post(Uri.parse('$apiJsURL/add-subscription'), body: params, headers: {'Authorization': 'Bearer $token'});
      if(res.statusCode == 200){
        print("Success");
        Map<String, dynamic> payParams = {
          "pay_id": response.paymentId,
          "cst_id": cst_id
        };
        return Result(data: "SUCCESS", error: null);
      }
      else{
       return Result(data: null, error: null); // Add error string
      }
    } 
    catch(err){
      return Result(data: null, error: err.toString());
    }
  }

  static void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print("failed");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
   
  }
}
