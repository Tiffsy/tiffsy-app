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
    var client = http.Client();
    try{

//       { lunch: 1}
// {breakfast: 2}
// {dinner: 0}
// {lunch_price: 100}
// {breakfast_price: 80}
// {dinner_price: 90}
// {start_date: timestamp}
// {end_date: timestamp}
// {addr_line: leisure_town} — done
// {cst_id: id} — done
// {subtype: } — done
// {timestamp of order} —  

// (1*100 + 2*80 + 0*90)*subtype = total

// subDetails
// {cst_id, subId, sdt, edt, addr_line, ts, subtype, bc, lc, dc, bill, bp, lp, dp};
      String cst_id = Hive.box('customer_box').get('cst_id');
      String addr_line = Hive.box("addr_box").get("addr");
      String addr_id = Hive.box("addr_box").get("addr_id");
      String strdt = Hive.box("cart_box").get("start_date");
      String enddt = Hive.box("cart_box").get("end_date");
      String bill = Hive.box("cart_box").get("bill");

      Map<String, dynamic> params = {
        "cst_id" : cst_id,
        "addr_line": addr_line,
        "addr_id": addr_id,
        "str_dt": strdt,
        "end_dt": enddt,
        "bill": bill,
      };
      var res = await http.post(Uri.parse('$apiJsURL/add-subscription'), body: params);
      if(res.statusCode == 200){
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
    // Do something when an external wallet is selected
  }
}
