import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:tiffsy_app/Helpers/result.dart';
import 'package:tiffsy_app/screens/AddressBookScreen/model/address_data_model.dart';
import 'package:tiffsy_app/screens/AddressBookScreen/repository/address_book_repo.dart';
import 'package:tiffsy_app/screens/HomeScreen/model/home_model.dart';
import 'package:tiffsy_app/screens/HomeScreen/repository/home_repo.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeInitialFetchEvent>(homeInitialFetch);
    on<SubscriptionInitialFetchEvent>(subscriptionInitialFetchEvent);
    on<HomePageAddTocartEvent>(homePageCartQuantityChangeEvent);
    on<HomePageRemoveFromCartEvent>(homePageRemoveFromCartEvent);
  }

  FutureOr<void> homeInitialFetch(
      HomeInitialFetchEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    if (!event.isCached) {
      Result<List<MenuDataModel>> menu = await HomeRepo.fetchMenu();
      if (menu.isSuccess) {
        bool loginMethod = HomeRepo.checkUserAuthenticationMethod();
        if (loginMethod) {
          String cstPhone = HomeRepo.getUserInfo();
          cstPhone = cstPhone.substring(3);
          Result<Map<String, dynamic>> result =
              await HomeRepo.getCustomerIdByPhone(cstPhone);
          if (result.isSuccess) {
            Map<String, dynamic> cstDetails = result.data!;
            Box customerBox = await Hive.openBox("customer_box");
            customerBox.putAll(cstDetails);
          } else {
            emit(HomeErrorState(error: result.error.toString()));
          }
        } else {
          String cstMail = HomeRepo.getUserInfo();
          Result<Map<String, dynamic>> result =
              await HomeRepo.getCustomerIdByMail(cstMail);
          if (result.isSuccess) {
            Map<String, dynamic> cstDetails = result.data!;
            Box customerBox = await Hive.openBox("customer_box");
            customerBox.putAll(cstDetails);
          } else {
            emit(HomeErrorState(error: result.error.toString()));
          }
        }
        Box cartBox = Hive.box("cart_box");
        List<MenuDataModel> menuList = menu.data!;
        Map<String, Map<String, Map<String, dynamic>>> menuData = {};
        for (MenuDataModel element in menuList) {
          if (menuData[element.mealTime] == null) {
            menuData[element.mealTime] = {element.mealType: element.toJson()};
          } else {
            menuData[element.mealTime]?[element.mealType] = element.toJson();
          }
        }

        // getting the address part starts here.
        Box addressBox = Hive.box('address_box');
        Map defaultAddress =
            addressBox.get("default_address", defaultValue: {});
        if (defaultAddress.isEmpty) {
          Result<List<AddressDataModel>> addressResult =
              await AddressBookRepo.fetchAddressList();
          if (addressResult.isSuccess && addressResult.data!.isNotEmpty) {
            Map<String, dynamic> firstAddress = addressResult.data![0].toJson();
            addressBox.put("default_address", firstAddress);
            List<Map<String, String>> listOfAddress = [];
            for (var element in addressResult.data!) {
              listOfAddress.add(element.toJson());
            }
            addressBox.put("list_of_address", listOfAddress);
          }
        }

        cartBox.put('menu', menuData);
        emit(HomeFetchSuccessfulState(menu: menuList));
      } else {
        emit(HomeErrorState(error: menu.error.toString()));
      }
    } else {
      emit(HomeFetchSuccessfulIsCachedState());
    }
  }

  FutureOr<void> subscriptionInitialFetchEvent(
      SubscriptionInitialFetchEvent event, Emitter<HomeState> emit) {
    emit(SubscriptionLoadingState());
  }

  FutureOr<void> homePageCartQuantityChangeEvent(
      HomePageAddTocartEvent event, Emitter<HomeState> emit) {
    Box cartBox = Hive.box("cart_box");
    Map menu = cartBox.get("menu");
    var menuAddedToCart = menu[event.mealTime][event.mealType];
    Box customer_box = Hive.box("customer_box");
    String cst_id = customer_box.get("cst_id");
    cartBox.put("cst_id", cst_id);
    List cart = cartBox.get("cart", defaultValue: []);
    bool alreadyExists = false;
    for (var element in cart) {
      if (element["mealTime"] == event.mealTime) {
        emit(HomePageCartQuantityChangeState());
        Fluttertoast.showToast(
            msg: "Can't add the same item twice",
            toastLength: Toast.LENGTH_LONG);
        alreadyExists = true;
        break;
      }
    }

    if (!alreadyExists) {
      cart.add(menuAddedToCart);
      cartBox.put("cart", cart);
      emit(HomePageCartQuantityChangeState());
      Fluttertoast.showToast(
          msg:
              "${toSentenceCase(event.mealType)} ${toSentenceCase(event.mealTime)} added to cart!",
          toastLength: Toast.LENGTH_SHORT);
    }
    emit(HomeFetchSuccessfulIsCachedState());
  }
}

FutureOr<void> homePageRemoveFromCartEvent(
    HomePageRemoveFromCartEvent event, Emitter<HomeState> emit) async {
  Box cartBox = Hive.box('cart_box');
  List currentCart = cartBox.get("cart");
  List newCart = [];
  for (var element in currentCart) {
    if (element["mealTime"] != event.mealTime) {
      newCart.add(element);
    }
  }
  await cartBox.put('cart', newCart);
  emit(HomePageCartQuantityChangeState());
}

String toSentenceCase(String input) {
  if (input.isEmpty) return '';
  return '${input[0].toUpperCase()}${input.substring(1).toLowerCase()}';
}
