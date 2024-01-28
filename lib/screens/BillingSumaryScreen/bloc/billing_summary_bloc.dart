import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:tiffsy_app/Helpers/result.dart';
import 'package:tiffsy_app/screens/BillingSumaryScreen/repository/billing_repo.dart';

part 'billing_summary_event.dart';
part 'billing_summary_state.dart';

class BillingSummaryBloc
    extends Bloc<BillingSummaryEvent, BillingSummaryState> {
  final Razorpay _razorpay = Razorpay();

  final Function onPaymentSuccess;

  BillingSummaryBloc({required this.onPaymentSuccess})
      : super(BillingSummaryInitial()) {
    on<BillingSummaryEvent>((event, emit) {});
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (event) {
      add(PaymentSuccessEvent(paymentId: event.paymentId));
    });

    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (event) {
      add(PaymentFailureEvent(errorMessage: "Payment Failed"));
    });
  }
  void initializePayment(double amount) {
    add(InitializePaymentEvent(amount: amount));
  }

  @override
  Future<void> close() {
    _razorpay.clear();
    return super.close();
  }

  @override
  void onEvent(BillingSummaryEvent event) async {
    if (event is InitializePaymentEvent) {
      int amountInPaisa = (event.amount * 100).floor();
      Box customer_box = Hive.box("customer_box");
      _razorpay.open({
        "key": "rzp_test_q5b3nNR3JdGWUH",
        "amount": amountInPaisa,
        "currency": "INR",
        "name": "Tiffsy",
        "timeout": 300,
        "prefill": {
          "contact": customer_box.get("cst_contact"),
          "email": customer_box.get("cst_mail")
        },
        "theme": {"color": "#FFBE1D"}
      });
    } else if (event is PaymentSuccessEvent) {
      emit(TransactionLoadingState());
      Result<Map<String, dynamic>> result = await BillingRepo.addSubscription();
      if (result.isSuccess) {
        Map<String, dynamic> tmp = result.data!;
        Result<String> res = await BillingRepo.addTransaction(
            event.paymentId, int.parse(tmp["bill"]), tmp["sbcr_id"]);
        if (res.isSuccess) {
          onPaymentSuccess();
          emit(RazorpaySuccess());
        } else {
          emit(RazorpayFailure(errorMessage: res.error.toString()));
        }
      } else {
        emit(RazorpayFailure(errorMessage: result.error.toString()));
      }
    } else if (event is PaymentFailureEvent) {
      emit(RazorpayFailure(errorMessage: event.errorMessage));
    }
  }
}
