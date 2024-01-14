import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tiffsy_app/Helpers/result.dart';
import 'package:tiffsy_app/screens/CalendarScreen/model/calendar_date_model.dart';
import 'package:tiffsy_app/screens/CalendarScreen/repository/calendar_repo.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc() : super(CalendarInitial()) {
    on<CalendarInitialFetchEvent>(calendarInitialFetchEvent);
    on<CancelButtonClickedEvent>(cancelOrderClickedEvent);
  }

  FutureOr<void> calendarInitialFetchEvent(CalendarInitialFetchEvent event, Emitter<CalendarState> emit) async {
    emit(CalendarLoadingState());
    String cstId = event.cstId;
    String subsId = event.subsId;
    Result<List<CalendarDataModel>> calendarDates =
        await CalendarRepo.fetchCalendarDates(cstId, subsId); // cst_id, subs_id
    //print(calendarDates.isSuccess);
    if (calendarDates.isSuccess) {
      List<CalendarDataModel> calendarData = calendarDates.data!;
      print(calendarData);
      emit(CalendarFetchSuccessState(calendarData: calendarData));
    } else {
      emit(CalendarErrorState(error: calendarDates.error.toString()));
    }
  }

  FutureOr<void> cancelClickedEvent(CancelClickedEvent event, Emitter<CalendarState> emit) async {}

  FutureOr<void> cancelOrderClickedEvent(CancelButtonClickedEvent event, Emitter<CalendarState> emit) async {
    print("afjbfjsdbfjhasjkdhgjkasdkgjnbas");
    Result<String> result = await CalendarRepo.cancelOrder(event.ordr_id, event.dt, event.lc, event.bc, event.dc);
    if (result.isSuccess) {
      emit(CancelSuccessState(msg: result.data!));
    } else {
      emit(CalendarAlertErrorState(error: result.error.toString()));
    }
    emit(RefreshCalendarState());
  }
}