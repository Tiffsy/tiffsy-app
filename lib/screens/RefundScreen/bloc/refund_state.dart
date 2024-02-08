part of 'refund_bloc.dart';

abstract class RefundState extends Equatable {
  const RefundState();
  
  @override
  List<Object> get props => [];
}

final class RefundInitial extends RefundState {}

final class RefundHistoryFetchLoading extends RefundState{}
final class RefundHistoryFetchError extends RefundState{
  final String error;

  RefundHistoryFetchError({required this.error});

}
final class RefundHistoryFetchSuccess extends RefundState{
  final List<RefundDataModel> refundList;
  RefundHistoryFetchSuccess({required this.refundList});
}


