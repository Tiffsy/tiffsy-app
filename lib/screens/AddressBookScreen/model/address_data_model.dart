// To parse this JSON data, do
//
//     final addressDataModel = addressDataModelFromJson(jsonString);

import 'dart:convert';

AddressDataModel addressDataModelFromJson(String str) => AddressDataModel.fromJson(json.decode(str));

String addressDataModelToJson(AddressDataModel data) => json.encode(data.toJson());

class AddressDataModel {
    String addrType;
    String pin;
    String city;
    String state;
    String hsNm;
    String addrId;
    String addLine1;

    AddressDataModel({
        required this.addrType,
        required this.pin,
        required this.city,
        required this.state,
        required this.hsNm,
        required this.addrId,
        required this.addLine1,
    });

    factory AddressDataModel.fromJson(Map<String, dynamic> json) => AddressDataModel(
        addrType: json["addr_type"],
        pin: json["pin"],
        city: json["city"],
        state: json["state"],
        hsNm: json["hs_nm"],
        addrId: json["addr_id"],
        addLine1: json["add_line_1"],
    );

    Map<String, dynamic> toJson() => {
        "addr_type": addrType,
        "pin": pin,
        "city": city,
        "state": state,
        "hs_nm": hsNm,
        "addr_id": addrId,
        "add_line_1": addLine1,
    };
}