import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

import '../../../Constants/network_contants.dart';

part 'personal_details_event.dart';
part 'personal_details_state.dart';

class PersonalDetailsBloc extends Bloc<PersonalDetailsEvent, PersonalDetailsState> {
  
  PersonalDetailsBloc(super.initialState) {  
    on<ContinueButtonClickedEvent>((event, emit) async {
      emit(ScreenLoadingScreen());
      String name = event.name;
      String mailId = event.mailId;
      print(mailId);
      try{
        var client = http.Client();
        Map<String, dynamic> params = {
          "name": name,
          "mailId": mailId
        };
        var response = await http.post(Uri.parse(apiJsURL + '/add-user'), body: params);
        if(response.statusCode == 200){
          emit(ContinueButtonClickedSuccessState());
        }
        else{
          emit(ScreenErrorState(error: "Error in Registration, Please Try again"));
        }
      }
      catch(err){
        emit(ScreenErrorState(error: err.toString()));
      }
    });
  }
}
