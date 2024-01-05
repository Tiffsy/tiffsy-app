// To parse this JSON data, do
//
//     final addressDataModel = addressDataModelFromJson(jsonString);

import 'dart:convert';

AddressDataModel addressDataModelFromJson(String str) => AddressDataModel.fromJson(json.decode(str));

String addressDataModelToJson(AddressDataModel data) => json.encode(data.toJson());

class AddressDataModel {
    String cstId;
    String addrId;
    String houseNum;
    String addrLine;
    String state;
    String pin;
    String city;
    String contact;
    String addrType;

    AddressDataModel({
        required this.cstId,
        required this.addrId,
        required this.houseNum,
        required this.addrLine,
        required this.state,
        required this.pin,
        required this.city,
        required this.contact,
        required this.addrType,
    });

    factory AddressDataModel.fromJson(Map<String, dynamic> json) => AddressDataModel(
        cstId: json["cst_id"],
        addrId: json["addr_id"],
        houseNum: json["house_num"],
        addrLine: json["addr_line"],
        state: json["state"],
        pin: json["pin"],
        city: json["city"],
        contact: json["contact"],
        addrType: json["addr_type"],
    );

    Map<String, dynamic> toJson() => {
        "cst_id": cstId,
        "addr_id": addrId,
        "house_num": houseNum,
        "addr_line": addrLine,
        "state": state,
        "pin": pin,
        "city": city,
        "contact": contact,
        "addr_type": addrType,
    };
}