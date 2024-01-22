part of 'address_book_bloc.dart';

@immutable
abstract class AddressBookState {}

final class AddressBookLoadingState extends AddressBookState {}

final class AddressBookInitial extends AddressBookState {}

final class AddressBookErrorState extends AddressBookState {
  final String error;
  AddressBookErrorState({required this.error});
}

final class AddAddressButtonClickedState extends AddressBookState {}

final class AddressListFetchSuccessState extends AddressBookState {
  final List<AddressDataModel> addressList;
  AddressListFetchSuccessState({required this.addressList});
}

final class NoAddressAddedState extends AddressBookState {}
