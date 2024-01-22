part of 'add_address_screen_dart_bloc.dart';

abstract class AddAddressScreenDartEvent {}

class SaveAddressClicked extends AddAddressScreenDartEvent {
  final String cst_id;
  final String add_id;
  final String house_num;
  final String addr_line;
  final String state;
  final String pin;
  final String city;
  final String contact;
  final String addr_type;

  SaveAddressClicked(
      {required this.cst_id,
      required this.add_id,
      required this.house_num,
      required this.addr_line,
      required this.state,
      required this.pin,
      required this.city,
      required this.addr_type,
      required this.contact});
}
