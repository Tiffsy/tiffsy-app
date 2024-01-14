import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:tiffsy_app/Constants/network_contants.dart';
part 'add_address_screen_dart_event.dart';
part 'add_address_screen_dart_state.dart';

class AddAddressScreenDartBloc
    extends Bloc<AddAddressScreenDartEvent, AddAddressScreenDartState> {
  AddAddressScreenDartBloc() : super(AddAddressScreenDartInitial()) {
    on<AddAddressScreenDartEvent>((event, emit) {});
    on<SaveAddressClicked>(saveAddressClicked);
  }
  FutureOr<void> saveAddressClicked(
      SaveAddressClicked event, Emitter<AddAddressScreenDartState> emit) async {
    emit(AddAddressLoadingState());
    String cst_id = event.cst_id;
    String add_id = event.add_id;
    String house_num = event.house_num;
    final String addr_line = event.addr_line;
    final String state = event.state;
    final String pin = event.pin;
    final String city = event.city;
    final String contact = event.contact;
    final String addr_type = event.addr_type;

    try {
      Map<String, dynamic> params = {
        "cst_id": cst_id,
        "addr_id": add_id,
        "house_num": house_num,
        "addr_line": addr_line,
        "state": state,
        "pin": pin,
        "city": city,
        "contact": contact,
        "addr_type": addr_type
      };

      Box customer_box = Hive.box("customer_box");
      String token = customer_box.get("token");
      
      var response =
          await http.post(Uri.parse('$apiJsURL/add-address'), body: params, headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        emit(AddAddressSuccessState());
      } else {
        emit(AddAddressErrorState(error: response.statusCode.toString()));
      }
    } catch (err) {
      emit(AddAddressErrorState(error: err.toString()));
    }
  }
}
