part of 'calendar_bloc.dart';

abstract class CalendarState{
 
}
final class CalendarInitial extends CalendarState {}
final class CalendarLoadingState extends CalendarState{}
final class CalendarErrorState extends CalendarState{
  String error;
  CalendarErrorState({required this.error});
}
final class CalendarFetchSuccessState extends CalendarState{
  List<DateTime> cancelDates;
  List<DateTime> orderDate;
  CalendarFetchSuccessState({
    required this.cancelDates, required this.orderDate
  });
}
final class OrderCancelSuccessState extends CalendarState{}

