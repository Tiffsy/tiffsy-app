import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'subscription_event.dart';
part 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  SubscriptionBloc() : super(SubscriptionInitial()) {
    on<StartDateChoosenEvent>((event, emit) {
      DateTime startDate = event.startDate;
      DateTime endDate = startDate.add(Duration(days: event.noOfdays));
      emit(NewDatesState(startDate: startDate, endDate: endDate));
    });
  }
}
