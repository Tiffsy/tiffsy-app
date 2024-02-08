import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tiffsy_app/Helpers/result.dart';
import 'package:tiffsy_app/screens/RefundScreen/model/refund_data_model.dart';
import 'package:tiffsy_app/screens/RefundScreen/repo/refund_history_repo.dart';

part 'refund_event.dart';
part 'refund_state.dart';

class RefundBloc extends Bloc<RefundEvent, RefundState> {
  RefundBloc() : super(RefundInitial()) {
    on<RefundInitialFetchEvent>((event, emit) async {
      emit(RefundHistoryFetchLoading());
      Result<List<RefundDataModel>> refundData = await RefundHistoryRepo.fetchRefundHistory();
      if(refundData.isSuccess){
        List<RefundDataModel> refundList = refundData.data!;
        emit(RefundHistoryFetchSuccess(refundList: refundList));
      }
      else{
        emit(RefundHistoryFetchError(error: refundData.error!));
      }
    });
  }
}
