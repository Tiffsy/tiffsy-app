import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:tiffsy_app/Helpers/result.dart';

class BillingRepo{

  static Razorpay _razorpay = Razorpay();

  static Future<Result<String>> razorPayPage(String ordr_id, double amount) async {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse response){
      return Result(data: "SUCCESS", error: null);
    });
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse response) {
      return Result(data: null, error: "Error");
    });
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
    } catch (err) {
      return Result(data: null, error: err.toString());
    }
    
    return Result(data: null, error: "null");
  }

  // static void _handlePaymentSuccess(PaymentSuccessResponse response) async {
  //   print("SUCCESS");
  // }
  // static void _handlePaymentError(PaymentFailureResponse response) async {
  //   print("ERROR");
  // }
  // static void _handleExternalWallet(ExternalWalletResponse response){
  //   print("External wallet");
  // }
}