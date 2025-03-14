part of 'add_address_screen_dart_bloc.dart';

abstract class AddAddressScreenDartState {
  const AddAddressScreenDartState();

  List<Object> get props => [];
}

final class AddAddressScreenDartInitial extends AddAddressScreenDartState {}

class AddAddressErrorState extends AddAddressScreenDartState {
  final String error;
  AddAddressErrorState({required this.error});
}

class AddAddressSuccessState extends AddAddressScreenDartState {}

class AddAddressLoadingState extends AddAddressScreenDartState {}
