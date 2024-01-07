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
    on<CancelOrderClicked>(cancelOrderClickedEvent);
  }

  FutureOr<void> calendarInitialFetchEvent(
      CalendarInitialFetchEvent event, Emitter<CalendarState> emit) async {
    emit(CalendarLoadingState());
    String cst_id = event.cst_id;
    String subs_id = event.subs_id;
    print("testing debug");
    Result<List<CalendarDataModel>> calendarDates =
        await CalendarRepo.fetchCalendarDates(
            cst_id, subs_id); // cst_id, subs_id
    if(calendarDates.isSuccess){
      List<CalendarDataModel> calendarData = calendarDates.data!;
      print(calendarData);
      emit(CalendarFetchSuccessState(calendarData: calendarData));
    }
    else{
      emit(CalendarErrorState(error: calendarDates.error.toString()));
    }
  }

  FutureOr<void> cancelClickedEvent(
      CancelClickedEvent event, Emitter<CalendarState> emit) async {

      }

  FutureOr<void> cancelOrderClickedEvent(CancelOrderClicked event, Emitter<CalendarState> emit) {
  }
}
