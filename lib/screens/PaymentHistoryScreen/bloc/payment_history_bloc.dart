import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tiffsy_app/Helpers/result.dart';
import 'package:tiffsy_app/screens/PaymentHistoryScreen/model/payment_history_model.dart';
import 'package:tiffsy_app/screens/PaymentHistoryScreen/repo/payment_history_repo.dart';

part 'payment_history_event.dart';
part 'payment_history_state.dart';

class PaymentHistoryBloc
    extends Bloc<PaymentHistoryEvent, PaymentHistoryState> {
  PaymentHistoryBloc() : super(PaymentHistoryInitial()) {
    on<PaymentHistoryInitialFetchEvent>((event, emit) async {
      emit(PaymentHistoryInitialFetchLoadingState());
      Result<List<PaymentHistoryDataModel>> fetchedData =
         await PaymentHistoryRepo.fetchPaymentHistory();

      if(fetchedData.isSuccess){
        List<PaymentHistoryDataModel> paymentList = fetchedData.data!;
        emit(PaymentHistoryInitialFetchSuccessfulState(
          listOfPaymentHistoryDataModel: paymentList));
      }
      else{
        emit(PaymentHistoryInitialFetchFailedState());
      }
    });
  }
}
