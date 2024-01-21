import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tiffsy_app/screens/PaymentHistoryScreen/model/payment_history_model.dart';
import 'package:tiffsy_app/screens/PaymentHistoryScreen/repo/payment_history_repo.dart';

part 'payment_history_event.dart';
part 'payment_history_state.dart';

class PaymentHistoryBloc
    extends Bloc<PaymentHistoryEvent, PaymentHistoryState> {
  PaymentHistoryBloc() : super(PaymentHistoryInitial()) {
    on<PaymentHistoryInitialFetchEvent>((event, emit) async {
      emit(PaymentHistoryInitialFetchLoadingState());
      await Future.delayed(Duration(seconds: 10));
      List<PaymentHistoryDataModel> fetchedData =
          PaymentHistoryRepo.fetchPaymentHistory();
      emit(PaymentHistoryInitialFetchSuccessfulState(
          listOfPaymentHistoryDataModel: fetchedData));
    });
  }
}
