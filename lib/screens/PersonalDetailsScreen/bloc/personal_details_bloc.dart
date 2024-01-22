import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

import '../../../Constants/network_contants.dart';

part 'personal_details_event.dart';
part 'personal_details_state.dart';

class PersonalDetailsBloc
    extends Bloc<PersonalDetailsEvent, PersonalDetailsState> {
  PersonalDetailsBloc(super.initialState) {
    on<ContinueButtonClickedForEmailEvent>((event, emit) async {
      emit(ScreenLoadingScreen());
      String name = event.name;
      String mailId = event.mailId;
      String number = event.number;
      print(mailId);
      try {
        var client = http.Client();
        Map<String, dynamic> params = {
          "cst_name": name,
          "cst_mail": mailId,
          "cst_contact": number
        };
        var response =
            await http.post(Uri.parse('$apiJsURL/add-user'), body: params);
        if (response.statusCode == 200) {
          final FirebaseFirestore firestore = FirebaseFirestore.instance;
          CollectionReference users = firestore.collection('users_phone');
          await users.add({
            'phoneNumber': number,
          });
          emit(ContinueButtonClickedSuccessState());
        } else {
          emit(ScreenErrorState(
              error: "Error in Registration, Please Try again"));
        }
      } catch (err) {
        emit(ScreenErrorState(error: err.toString()));
      }
    });

    on<ContinueButtonClickedForPhoneEvent>((event, emit) async {
      emit(ScreenLoadingScreen());
      String name = event.name;
      String number = event.number;
      String mailId = event.mailId;
      print(number);
      try {
        var client = http.Client();
        Map<String, dynamic> params = {
          "cst_name": name,
          "cst_mail": mailId,
          "cst_contact": number
        };
        var response =
            await http.post(Uri.parse(apiJsURL + '/add-user'), body: params);
        if (response.statusCode == 200) {
          final FirebaseFirestore firestore = FirebaseFirestore.instance;
          CollectionReference users = firestore.collection('email');
          await users.add({
            'email': mailId,
          });
          emit(ContinueButtonClickedSuccessState());
        } else {
          emit(ScreenErrorState(
              error: "Error in Registration, Please Try again"));
        }
      } catch (err) {
        emit(ScreenErrorState(error: err.toString()));
      }
    });
  }
}
