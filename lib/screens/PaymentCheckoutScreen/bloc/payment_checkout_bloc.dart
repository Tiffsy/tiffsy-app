import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tiffsy_app/screens/PaymentCheckoutScreen/model/payment_checkout_model.dart';

part 'payment_checkout_event.dart';
part 'payment_checkout_state.dart';

class PaymentCheckoutBloc
    extends Bloc<PaymentCheckoutEvent, PaymentCheckoutState> {
  PaymentCheckoutBloc() : super(PaymentCheckoutInitial()) {
    on<GooglePayUPIEvent>(paymentCheckoutGooglePay);
  }
}

FutureOr<void> paymentCheckoutGooglePay(
  GooglePayUPIEvent event, Emitter<PaymentCheckoutState> emit) {
  print("Gpay pressed");
  PaymentCheckoutOptions.googlePayUPI(event.orderID, event.amount);
  print("object");
}
