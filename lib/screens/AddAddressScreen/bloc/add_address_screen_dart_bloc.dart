import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_address_screen_dart_event.dart';
part 'add_address_screen_dart_state.dart';

class AddAddressScreenDartBloc extends Bloc<AddAddressScreenDartEvent, AddAddressScreenDartState> {
  AddAddressScreenDartBloc() : super(AddAddressScreenDartInitial()) {
    on<AddAddressScreenDartEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
