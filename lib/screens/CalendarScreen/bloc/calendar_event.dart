part of 'calendar_bloc.dart';

abstract class CalendarEvent {}

final class CalendarInitialFetchEvent extends CalendarEvent {
  final String cstId;
  final String subsId;
  CalendarInitialFetchEvent({required this.cstId, required this.subsId});
}

final class OrderCancelEvent extends CalendarEvent {}

final class RefreshOrderEvent extends CalendarEvent {}

final class CancelClickedEvent extends CalendarEvent {
  final DateTime cancelDate;
  final String cst_id;
  CancelClickedEvent({required this.cancelDate, required this.cst_id});
}

final class CancelOrderClicked extends CalendarEvent {
  final String cst_id;
  final String ordr_id;

  CancelOrderClicked({required this.cst_id, required this.ordr_id});
}

final class CancelButtonClickedEvent extends CalendarEvent {
  final String ordr_id;
  final int bc;
  final int lc;
  final int dc;
  final String dt;
  final String sbcr_id;

  CancelButtonClickedEvent(
      {required this.ordr_id, required this.bc, required this.lc, required this.dc, required this.dt, required this.sbcr_id});
}
