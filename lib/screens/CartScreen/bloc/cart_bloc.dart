import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<CartScreenOnProcedButtonPressEvent>((event, emit) {
      Hive.box("cart_box").put("cost", event.cost);
    });
  }
}
