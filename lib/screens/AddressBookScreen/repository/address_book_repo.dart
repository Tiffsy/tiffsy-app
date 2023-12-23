
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tiffsy_app/Constants/network_contants.dart';
import 'package:tiffsy_app/screens/AddressBookScreen/model/address_data_model.dart';

import '../../../Helpers/result.dart';

class AddressBookRepo{
  static Future<Result<List<AddressDataModel>>> fetchAddressList() async {
    var client = http.Client();
    try{
      List<AddressDataModel> addressList = [];
      Map<String, dynamic> params = {
          "cst_id": "bvdnz"
        };
      var response = await http.post(Uri.parse('$apiJsURL/address-list'), body: params);
      List result = jsonDecode(response.body);
      for(int i = 0; i < result.length; i++){
        AddressDataModel address = AddressDataModel.fromJson(result[i]);
        addressList.add(address);
      }
      return Result(data: addressList, error: null);
    }
    catch(err){
      print(err);
      return Result(data: null, error: err.toString());
    }
  }
}