part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class CartScreenOnProcedButtonPressEvent extends CartEvent {
  final double cost;

  const CartScreenOnProcedButtonPressEvent({required this.cost});
}
