import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tiffsy_app/screens/OrderHistoryScreen/model/order_history_model.dart';
import 'package:tiffsy_app/screens/OrderHistoryScreen/repository/order_history_repo.dart';

part 'order_history_event.dart';
part 'order_history_state.dart';

class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  OrderHistoryBloc() : super(OrderHistoryInitialState()) {
    on<OrderHistoryInitialFetchEvent>(orderHistoryInitialFetch);
  }

  FutureOr<void> orderHistoryInitialFetch(OrderHistoryInitialFetchEvent event,
      Emitter<OrderHistoryState> emit) async {
    emit(OrderHistoreLoadingState());
    try {
      List<OrderHistoryModel> fetchedData =
          await OrderHistoryRepo.fetchOrderHistory();

      await Future.delayed(
        Duration(seconds: 1),
      );

      emit(
        OrderHistoryFetchSuccessfulState(
          orderHistory: fetchedData,
        ),
      );
    } catch (e) {
      print(e.toString());
      emit(OrderHistoryErrorState());
    }
  }
}
