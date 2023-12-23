part of 'address_book_bloc.dart';

@immutable
abstract class AddressBookEvent {}

class AddressBookInitialFetchEvent extends AddressBookEvent{}
class AddressBookAddAdresssButtonClickedEvent extends AddressBookEvent{}
class AddressBookAddressClicked extends AddressBookEvent{}


