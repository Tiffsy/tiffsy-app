import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tiffsy_app/Helpers/result.dart';
import 'package:tiffsy_app/screens/CalendarScreen/repository/calendar_repo.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc() : super(CalendarInitial()) {
    on<CalendarInitialFetchEvent>(calendarInitialFetchEvent);
    on<CancelClickedEvent>(cancelClickedEvent);
  }

  FutureOr<void> calendarInitialFetchEvent(
      CalendarInitialFetchEvent event, Emitter<CalendarState> emit) async {
    emit(CalendarLoadingState());
    print("testing debug");
    Result<List<DateTime>> cancelDates =
        await CalendarRepo.fetchCancelOrderDates("bvdz");
    
    Result<List<DateTime>> orderDates =
        await CalendarRepo.fetchCalendarDates("bvdz");

    if (cancelDates.isSuccess && orderDates.isSuccess) {
      List<DateTime> cnclDt = cancelDates.data!;
      List<DateTime> odrDt = orderDates.data!;
      emit(CalendarFetchSuccessState(cancelDates: cnclDt, orderDate: odrDt));
    } else if(!cancelDates.isSuccess && orderDates.isSuccess) {
      emit(CalendarErrorState(error: cancelDates.error.toString()));
    }
  }

  FutureOr<void> cancelClickedEvent(CancelClickedEvent event, Emitter<CalendarState> emit) async {
    emit(CalendarLoadingState());
    Result<String> result = await CalendarRepo.cancelOrder(event.cst_id, event.cancelDate);
    if(result.isSuccess){
      emit(OrderCancelSuccessState());
    }
    else{
      emit(CalendarErrorState(error: result.error.toString()));
    }
  }
}
