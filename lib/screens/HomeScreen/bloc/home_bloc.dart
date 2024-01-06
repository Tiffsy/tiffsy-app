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

  FutureOr<void> homeInitialFetch(
      HomeInitialFetchEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    Result<List<MenuDataModel>> menu = await HomeRepo.fetchMenu();
    if (menu.isSuccess) {
      bool loginMethod = HomeRepo.checkUserAuthenticationMethod();
      if (loginMethod) {
        String cst_phone = HomeRepo.getUserInfo();
        cst_phone = cst_phone.substring(3);
        Result<Map<String, dynamic>> result =
            await HomeRepo.getCustomerIdByPhone(cst_phone);
        if (result.isSuccess) {
          Map<String, dynamic> cst_details = result.data!;
          Box customerBox = await Hive.openBox("customer_box");
          customerBox.putAll(cst_details);
        } else {
          emit(HomeErrorState(error: result.error.toString()));
        }
      } else {
        String cst_mail = HomeRepo.getUserInfo();
        Result<Map<String, dynamic>> result =
        await HomeRepo.getCustomerIdByMail(cst_mail);
        if (result.isSuccess) {
          Map<String, dynamic> cst_details = result.data!;
          Box customerBox = await Hive.openBox("customer_box");
          customerBox.putAll(cst_details);
        } else {
          emit(HomeErrorState(error: result.error.toString()));
        }
      }
      List<MenuDataModel> menuList = menu.data!;
      emit(HomeFetchSuccessfulState(menu: menuList));
    } else {
      emit(HomeErrorState(error: menu.error.toString()));
    }

    
  }
  FutureOr<void> subscriptionInitialFetchEvent(
      SubscriptionInitialFetchEvent event, Emitter<HomeState> emit) {
    emit(SubscriptionLoadingState());
  }

  FutureOr<void> homePageCartQuantityChangeEvent(
      HomePageCartQuantityChangeEvent event, Emitter<HomeState> emit) {
    Box cartBox = Hive.box("cart_box");
    Box customer_box = Hive.box("customer_box");
    String cst_id = customer_box.get("cst_id");
    cartBox.put("cst_id", cst_id);
    int currentValue = cartBox.get(event.mealType, defaultValue: 0);
    cartBox.put(event.mealType,
        event.isIncreased ? (currentValue + 1) : (currentValue - 1));
    emit(HomePageCartQuantityChangeState());
  }
}
