part of 'order_history_bloc.dart';

sealed class OrderHistoryState extends Equatable {
  const OrderHistoryState();

  @override
  List<Object> get props => [];
}

final class OrderHistoryInitialState extends OrderHistoryState {}

final class OrderHistoreLoadingState extends OrderHistoryState {}

final class OrderHistoryFetchSuccessfulState extends OrderHistoryState {
  final List<OrderHistoryModel> orderHistory;
  const OrderHistoryFetchSuccessfulState({
    required this.orderHistory,
  });
}

final class OrderHistoryErrorState extends OrderHistoryState {}
