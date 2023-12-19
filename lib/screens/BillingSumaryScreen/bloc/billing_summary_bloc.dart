import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'billing_summary_event.dart';
part 'billing_summary_state.dart';

class BillingSummaryBloc extends Bloc<BillingSummaryEvent, BillingSummaryState> {
  BillingSummaryBloc() : super(BillingSummaryInitial()) {
    on<BillingSummaryEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
