import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:tiffsy_app/Helpers/result.dart';
import 'package:tiffsy_app/screens/HomeScreen/model/home_model.dart';
import 'package:tiffsy_app/screens/HomeScreen/repository/home_repo.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeInitialFetchEvent>(homeInitialFetch);
    on<SubscriptionInitialFetchEvent>(subscriptionInitialFetchEvent);
    on<HomePageCartQuantityChangeEvent>(homePageCartQuantityChangeEvent);
  }
  // FutureOr<void> homeInitialFetch(HomeInitialFetchEvent event, Emitter<HomeState> emit) async {
  //   on<HomeProfileButtonOnTapEvent>(
  //     (event, emit) {
  //       print("""object""");
  //       emit(HomeProfileButtonOnTapState());
  //     },
  //   );
  //   on<HomePageChangeEvent>(
  //     (event, emit) {
  //       emit(HomePageChangeState(newIndex: event.newIndex));
  //     },
  //   );
  // }

  FutureOr<void> homeInitialFetch(
      HomeInitialFetchEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    List<MenuDataModel> menu = await HomeRepo.fetchMenu();
    bool loginMethod = HomeRepo.checkUserAuthenticationMethod();
    String cst_id = "";
    if (loginMethod) {
      String cst_phone = HomeRepo.getUserInfo();
      cst_phone = cst_phone.substring(3);
      Result<Map<String, dynamic>> result =
          await HomeRepo.getCustomerIdByPhone(cst_phone);
      if (result.isSuccess) {
        Map<String, dynamic> cst_details = result.data!;
        print(cst_details);
        Box customerBox = await Hive.openBox("customer_box");
        customerBox.putAll(cst_details);
      } else {
        print(result.error);
      }
    } else {
      String cst_mail = HomeRepo.getUserInfo();
      Result<Map<String, dynamic>> result =
          await HomeRepo.getCustomerIdByMail(cst_mail);
      if (result.isSuccess) {
        Map<String, dynamic> cst_details = result.data!;
        print(cst_details);
      } else {
        print(result.error);
      }
    }
    emit(HomeFetchSuccessfulState(menu: menu));
  }

  FutureOr<void> subscriptionInitialFetchEvent(
      SubscriptionInitialFetchEvent event, Emitter<HomeState> emit) {
    emit(SubscriptionLoadingState());
  }

  FutureOr<void> homePageCartQuantityChangeEvent(
      HomePageCartQuantityChangeEvent event, Emitter<HomeState> emit) {
    Box cartBox = Hive.box("cart_box");
    int currentValue = cartBox.get(event.mealType, defaultValue: 0);
    cartBox.put(event.mealType,
        event.isIncreased ? (currentValue + 1) : (currentValue - 1));
    emit(HomePageCartQuantityChangeState());
  }
}
