part of 'calendar_bloc.dart';

abstract class CalendarEvent{
}

final class CalendarInitialFetchEvent extends CalendarEvent{
  final String cst_id;
  final String subs_id;
  CalendarInitialFetchEvent({required this.cst_id, required this.subs_id});
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

final class CancelOrderClicked extends CalendarEvent{
  final String cst_id;
  final String ordr_id;

  CancelOrderClicked({required this.cst_id, required this.ordr_id});
  
}

