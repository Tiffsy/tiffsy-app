import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tiffsy_app/Helpers/result.dart';
import 'package:tiffsy_app/screens/SubscriptionHomePageScreen/model/subscription_page_model.dart';
import 'package:tiffsy_app/screens/SubscriptionHomePageScreen/repository/subscription_page_repo.dart';

part 'subscription_home_page_event.dart';
part 'subscription_home_page_state.dart';

class SubscriptionHomePageBloc
    extends Bloc<SubscriptionHomePageEvent, SubscriptionHomePageState> {
  SubscriptionHomePageBloc() : super(SubscriptionHomePageInitial()) {
    on<SubcriptionInitialFetchEvent>(subcriptionInitialFetchEvent);
  }

  FutureOr<void> subcriptionInitialFetchEvent(
      SubcriptionInitialFetchEvent event,
      Emitter<SubscriptionHomePageState> emit) async {
    emit(SubscriptionPageLoadingState());

    Result<List<SubscriptionDataModel>> subcription =
        await SubscriptionPageRepo.fetchSubscriptionList();

    if (subcription.isSuccess) {
      List<SubscriptionDataModel> subcriptionList = subcription.data!;
      emit(SubscriptionFetchSuccessState(subcriptionList: subcriptionList));
      subcriptionList.forEach((element) {
        print(element.toString());
        print("__");
      });
    } else {
      emit(SubscriptionPageErrorState(error: subcription.error.toString()));
    }
  }
}
