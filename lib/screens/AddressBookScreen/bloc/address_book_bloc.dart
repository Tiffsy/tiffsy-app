import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'address_book_event.dart';
part 'address_book_state.dart';

class AddressBookBloc extends Bloc<AddressBookEvent, AddressBookState> {
  AddressBookBloc() : super(AddressBookInitial()) {
    on<AddressBookEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
