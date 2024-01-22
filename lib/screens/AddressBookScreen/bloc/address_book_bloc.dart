import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:tiffsy_app/Helpers/result.dart';
import 'package:tiffsy_app/screens/AddressBookScreen/model/address_data_model.dart';
import 'package:tiffsy_app/screens/AddressBookScreen/repository/address_book_repo.dart';

part 'address_book_event.dart';
part 'address_book_state.dart';

class AddressBookBloc extends Bloc<AddressBookEvent, AddressBookState> {
  AddressBookBloc() : super(AddressBookInitial()) {
    on<AddressBookInitialFetchEvent>((event, emit) async {
      emit(AddressBookLoadingState());
      Result<List<AddressDataModel>> result =
          await AddressBookRepo.fetchAddressList();
      if (!result.isSuccess) {
        emit(AddressBookErrorState(error: result.error.toString()));
      } else if (result.data!.isEmpty) {
        emit(NoAddressAddedState());
      } else {
        List<AddressDataModel> addressList = result.data!;
        emit(AddressListFetchSuccessState(addressList: addressList));
        List<Map<String, dynamic>> listOfAddressInMapForm = [];
        for (var element in addressList) {
          listOfAddressInMapForm.add(element.toJson());
        }
        Hive.box("address_box").put("list_of_address", listOfAddressInMapForm);
      }
    });

    on<AddressBookAddAdresssButtonClickedEvent>((event, emit) {
      emit(AddAddressButtonClickedState());
    });
  }
}
