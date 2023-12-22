part of 'order_history_bloc.dart';

@immutable
abstract class OrderHistoryEvent {}

final class OrderHistoryInitialFetchEvent extends OrderHistoryEvent {}
