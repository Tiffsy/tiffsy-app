import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'subscription_home_page_event.dart';
part 'subscription_home_page_state.dart';

class SubscriptionHomePageBloc extends Bloc<SubscriptionHomePageEvent, SubscriptionHomePageState> {
  SubscriptionHomePageBloc() : super(SubscriptionHomePageInitial()) {
    on<SubscriptionHomePageEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
