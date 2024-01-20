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
    on<HomePageAddToCartEvent>(homePageCartQuantityChangeEvent);
    on<HomePageRemoveFromCartEvent>(homePageRemoveFromCartEvent);
  }

  FutureOr<void> homeInitialFetch(
      HomeInitialFetchEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    Box cartBox = Hive.box("cart_box");
    if (!event.isCached) {
      Result<List<MenuDataModel>> menu = await HomeRepo.fetchMenu();
      if (menu.isSuccess) {
        bool loginMethod = HomeRepo.checkUserAuthenticationMethod();
        if (loginMethod) {
          String cstPhone = HomeRepo.getUserInfo();
          cstPhone = cstPhone.substring(3);

          Result<Map<String, dynamic>> result =
              await HomeRepo.getCustomerIdByPhone(cstPhone);
          print(result.error);
          if (result.isSuccess) {
            Map<String, dynamic> cstDetails = result.data!;
            Box customerBox = await Hive.openBox("customer_box");
            customerBox.putAll(cstDetails);
            Result<String> token = await HomeRepo.getToken(
                cstDetails["cst_mail"],
                cstDetails["cst_id"],
                cstDetails["cst_contact"]);
            if (token.isSuccess) {
              print(token.data);
              customerBox.put("token", token.data);
            } else {
              emit(HomeErrorState(error: token.error.toString()));
            }
          } else {
            emit(HomeErrorState(error: result.error.toString()));
          }
        } else {
          String cstMail = HomeRepo.getUserInfo();
          print(cstMail);
          Result<Map<String, dynamic>> result =
              await HomeRepo.getCustomerIdByMail(cstMail);
          print(result.data);
          if (result.isSuccess) {
            print(result.data);
            Map<String, dynamic> cstDetails = result.data!;
            Box customerBox = await Hive.openBox("customer_box");
            customerBox.putAll(cstDetails);
            Result<String> token = await HomeRepo.getToken(
                cstDetails["cst_mail"],
                cstDetails["cst_id"],
                cstDetails["cst_contact"]);
            if (token.isSuccess) {
              customerBox.put("token", token.data!);
            } else {
              emit(HomeErrorState(error: token.error.toString()));
            }
          } else {
            emit(HomeErrorState(error: result.error.toString()));
          }
        }

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
        // emit(UpdateCartBadge(quantity: cartCount()));
      } else {
        print(menu.error.toString());
        emit(HomeErrorState(error: menu.error.toString()));
      }
    } else {
      cartBox.get("menu");
      emit(HomeFetchSuccessfulIsCachedState());
      // emit(UpdateCartBadge(quantity: cartCount()));
    }
  }

  FutureOr<void> subscriptionInitialFetchEvent(
      SubscriptionInitialFetchEvent event, Emitter<HomeState> emit) {
    emit(SubscriptionLoadingState());
  }

  FutureOr<void> homePageCartQuantityChangeEvent(
      HomePageAddToCartEvent event, Emitter<HomeState> emit) {
    Box cartBox = Hive.box("cart_box");
    Map menu = cartBox.get("menu");
    bool cartType = cartBox.get("is_subscription");
    var menuAddedToCart = menu[event.mealTime][event.mealType];
    Box customer_box = Hive.box("customer_box");
    String cst_id = customer_box.get("cst_id");
    cartBox.put("cst_id", cst_id);
    List cart = cartBox.get("cart", defaultValue: []);
    if (event.isSubscription == cartType) {
      if (event.isSubscription) {
        bool alreadyExists = false;
        for (var element in cart) {
          if (element[0]["mealTime"] == event.mealTime) {
            emit(HomePageCartQuantityChangeState());
            emit(UpdateCartBadge(quantity: cartCount()));
            Fluttertoast.showToast(
                msg: "Can't add the same item twice",
                toastLength: Toast.LENGTH_LONG);
            alreadyExists = true;
            break;
          }
        }
        if (!alreadyExists) {
          cart.add([menuAddedToCart, 1]);
          cartBox.put("cart", cart);
          emit(HomePageCartQuantityChangeState());
          emit(UpdateCartBadge(quantity: cartCount()));
          Fluttertoast.showToast(
              msg:
                  "${toSentenceCase(event.mealType)} ${toSentenceCase(event.mealTime)} added to cart!",
              toastLength: Toast.LENGTH_SHORT);
        }
      } else {
        bool hasChanged = false;
        for (int i = 0; i < cart.length; i++) {
          if (cart[i][0]["mealTime"] == event.mealTime &&
              cart[i][0]["mealType"] == event.mealType) {
            cart[i][1] += 1;
            hasChanged = true;
          }
        }
        if (!hasChanged) {
          cart.add([menuAddedToCart, 1]);
        }
        cartBox.put("cart", cart);
        Fluttertoast.showToast(
            msg:
                "${toSentenceCase(event.mealType)} ${toSentenceCase(event.mealTime)} added to cart!",
            toastLength: Toast.LENGTH_SHORT);
      }
      // bool alreadyExists = false;
      // for (var element in cart) {
      //   if (element[0]["mealTime"] == event.mealTime) {
      //     emit(HomePageCartQuantityChangeState());
      //     Fluttertoast.showToast(
      //         msg: "Can't add the same item twice",
      //         toastLength: Toast.LENGTH_LONG);
      //     alreadyExists = true;
      //     break;
      //   }
      // }
      // if (!alreadyExists) {
      //   cart.add([menuAddedToCart, 1]);
      //   cartBox.put("cart", cart);
      //   emit(HomePageCartQuantityChangeState());
      //   Fluttertoast.showToast(
      //       msg:
      //           "${toSentenceCase(event.mealType)} ${toSentenceCase(event.mealTime)} added to cart!",
      //       toastLength: Toast.LENGTH_SHORT);
      // } else if (!event.isSubscription) {
      //   for (var element in cart) {
      //     if (element[0] == menuAddedToCart) {
      //       element[1] += 1;
      //     }
      //   }
      //   cartBox.put("cart", cart);
      // }
    }
    emit(HomeFetchSuccessfulIsCachedState());
    emit(UpdateCartBadge(quantity: cartCount()));
  }

  FutureOr<void> homePageRemoveFromCartEvent(
      HomePageRemoveFromCartEvent event, Emitter<HomeState> emit) async {
    Box cartBox = Hive.box('cart_box');
    List currentCart = cartBox.get("cart");
    List newCart = [];
    if (cartBox.get("is_subscription")) {
      for (var element in currentCart) {
        if (element[0]["mealTime"] != event.mealTime) {
          newCart.add(element);
        }
      }
      await cartBox.put('cart', newCart);
    } else {
      for (int i = 0; i < currentCart.length; i++) {
        if (currentCart[i][0]["mealTime"] == event.mealTime &&
            currentCart[i][0]["mealType"] == event.mealType) {
          if (currentCart[i][1] > 1) {
            newCart.add([currentCart[i][0], currentCart[i][1] - 1]);
          }
        } else {
          newCart.add(currentCart[i]);
        }
      }
    }
    await cartBox.put('cart', newCart);

    if (newCart.isEmpty) {
      await cartBox.delete("is_subscription");
      print(cartBox.get("is_subscription"));
    }
    emit(HomePageCartQuantityChangeState());
  }
}

String toSentenceCase(String input) {
  if (input.isEmpty) return '';
  return '${input[0].toUpperCase()}${input.substring(1).toLowerCase()}';
}

int cartCount() {
  return Hive.box("cart_box").get("cart", defaultValue: []).length;
}
