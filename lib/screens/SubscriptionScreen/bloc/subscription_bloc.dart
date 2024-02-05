import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tiffsy_app/Helpers/result.dart';
import 'package:tiffsy_app/screens/BillingSumaryScreen/model/coupon_data_model.dart';
import 'package:tiffsy_app/screens/BillingSumaryScreen/repository/billing_repo.dart';

part 'subscription_event.dart';
part 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  SubscriptionBloc() : super(SubscriptionInitial()) {
    on<StartDateChoosenEvent>((event, emit) {
      DateTime startDate = event.startDate;
      DateTime endDate = startDate.add(Duration(days: event.noOfdays));
      emit(NewDatesState(startDate: startDate, endDate: endDate));
    });
    on<FetchCouponsEvent>((event, emit) async {
      emit(fetchLoadingState());
      try {
        Result<List<CouponDataModel>> result = await BillingRepo.getCoupons();
        if (result.isSuccess) {
          List<CouponDataModel> couponList = result.data!;
          print(couponList);
          emit(CouponFetchSuccessState(couponList: couponList));
        } else {
          emit(fetchErrorState(error: result.error.toString()));
        }
      } catch (error) {
        emit(fetchErrorState(error: error.toString()));
      }
    });
  }
}
