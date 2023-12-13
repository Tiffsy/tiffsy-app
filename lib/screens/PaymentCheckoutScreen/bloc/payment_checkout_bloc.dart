import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'payment_checkout_event.dart';
part 'payment_checkout_state.dart';

class PaymentCheckoutBloc extends Bloc<PaymentCheckoutEvent, PaymentCheckoutState> {
  PaymentCheckoutBloc() : super(PaymentCheckoutInitial()) {
    on<PaymentCheckoutEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
