// To parse this JSON data, do
//
//     final menuDataModel = menuDataModelFromJson(jsonString);

import 'dart:convert';

MenuDataModel menuDataModelFromJson(String str) => MenuDataModel.fromJson(json.decode(str));

String menuDataModelToJson(MenuDataModel data) => json.encode(data.toJson());

class MenuDataModel {
    String mealType;
    String mealTime;
    String description;
    int price;
    DateTime datestmp;
    String title;

    MenuDataModel({
        required this.mealType,
        required this.mealTime,
        required this.description,
        required this.price,
        required this.datestmp,
        required this.title,
    });

    factory MenuDataModel.fromJson(Map<String, dynamic> json) => MenuDataModel(
        mealType: json["mealType"],
        mealTime: json["mealTime"],
        description: json["description"],
        price: json["price"],
        datestmp: DateTime.parse(json["datestmp"]),
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "mealType": mealType,
        "mealTime": mealTime,
        "description": description,
        "price": price,
        "datestmp": datestmp.toIso8601String(),
        "title": title,
    };
}
