import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:tiffsy_app/Helpers/result.dart';
import 'package:tiffsy_app/screens/BillingSumaryScreen/repository/billing_repo.dart';

part 'billing_summary_event.dart';
part 'billing_summary_state.dart';

class BillingSummaryBloc extends Bloc<BillingSummaryEvent, BillingSummaryState> {


  final Razorpay _razorpay = Razorpay();
  
  final Function onPaymentSuccess;
  
  BillingSummaryBloc({required this.onPaymentSuccess}) : super(BillingSummaryInitial()) {
    on<BillingSummaryEvent>((event, emit) {

    });
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (event){
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
  void onEvent(BillingSummaryEvent event)async {
    if (event is InitializePaymentEvent) {

     int amountInPaisa = (event.amount * 100).floor();
      _razorpay.open({
      "key": "rzp_test_AUti41jFaX94OY",
      "amount": amountInPaisa,
      "currency": "INR",
      "name": "Tiffsy",
      "timeout": 300,
      "prefill": {"contact": "8766896322", "email": "psomani16k@gmail.com"},
      "method": {"upi": "1"},
      });
    } else if (event is PaymentSuccessEvent)  {
      emit(TransactionLoadingState());
      Result<String> result = await BillingRepo.addSubscription();
      print("sub crp");
      if(result.isSuccess){
        Result<String> res = await BillingRepo.addTransaction(event.paymentId, 1000, result.data!);
        if(res.isSuccess){
          emit(RazorpaySuccess());
        }
        else{
          emit(RazorpayFailure(errorMessage: res.error.toString()));
        }
      }
      else{
         emit(RazorpayFailure(errorMessage: result.error.toString()));
      }
      
    } else if (event is PaymentFailureEvent) {
      emit(RazorpayFailure(errorMessage: event.errorMessage));
    }
  }
}
