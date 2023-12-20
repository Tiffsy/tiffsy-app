// To parse this JSON data, do
//
//     final menuDataModel = menuDataModelFromJson(jsonString);

import 'dart:convert';

MenuDataModel menuDataModelFromJson(String str) => MenuDataModel.fromJson(json.decode(str));

String menuDataModelToJson(MenuDataModel data) => json.encode(data.toJson());

class MenuDataModel {
    String title;
    int price;
    String description;
    int rating;
    String type;

    MenuDataModel({
        required this.title,
        required this.price,
        required this.description,
        required this.rating,
        required this.type,
    });

    factory MenuDataModel.fromJson(Map<String, dynamic> json) => MenuDataModel(
        title: json["title"],
        price: json["price"],
        description: json["description"],
        rating: json["rating"],
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "price": price,
        "description": description,
        "rating": rating,
        "type": type,
    };
}
