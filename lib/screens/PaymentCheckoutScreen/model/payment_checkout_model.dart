import 'package:razorpay_flutter/razorpay_flutter.dart';

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

  static void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    print("successsssssssss");
  }

  static void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print("failed");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }
}
