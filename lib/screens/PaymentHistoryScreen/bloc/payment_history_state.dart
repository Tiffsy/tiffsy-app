part of 'payment_history_bloc.dart';

sealed class PaymentHistoryState extends Equatable {
  const PaymentHistoryState();

  @override
  List<Object> get props => [];
}

final class PaymentHistoryInitial extends PaymentHistoryState {}

final class PaymentHistoryInitialFetchLoadingState
    extends PaymentHistoryState {}

final class PaymentHistoryInitialFetchSuccessfulState
    extends PaymentHistoryState {
  final List<PaymentHistoryDataModel> listOfPaymentHistoryDataModel;

  const PaymentHistoryInitialFetchSuccessfulState(
      {required this.listOfPaymentHistoryDataModel});
}

final class PaymentHistoryInitialFetchFailedState extends PaymentHistoryState {}
