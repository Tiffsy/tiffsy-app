part of 'calendar_bloc.dart';

abstract class CalendarEvent{
}

final class CalendarInitialFetchEvent extends CalendarEvent{
} 

final class OrderCancelEvent extends CalendarEvent{
}

final class RefreshOrderEvent extends CalendarEvent{
}
final class CancelClickedEvent extends CalendarEvent{
  final DateTime cancelDate;
  final String cst_id;
  CancelClickedEvent({required this.cancelDate, required this.cst_id});
}


