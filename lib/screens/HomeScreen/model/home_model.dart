// To parse this JSON data, do
//
//     final menuDataModel = menuDataModelFromJson(jsonString);

import 'dart:convert';

MenuDataModel menuDataModelFromJson(String str) =>
    MenuDataModel.fromJson(json.decode(str));

String menuDataModelToJson(MenuDataModel data) => json.encode(data.toJson());

class MenuDataModel {
  String title;
  int price;
  String description;
  String mealType;
  String mealTime;

  MenuDataModel({
    required this.title,
    required this.price,
    required this.description,
    required this.mealType,
    required this.mealTime,
  });

  factory MenuDataModel.fromJson(Map<String, dynamic> json) => MenuDataModel(
        title: json["title"],
        price: json["price"],
        description: json["description"],
        mealType: json["mealType"],
        mealTime: json["mealTime"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "price": price,
        "description": description,
        "mealType": mealType,
        "mealTime": mealTime
      };
}
