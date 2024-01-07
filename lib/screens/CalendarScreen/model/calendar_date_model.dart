// To parse this JSON data, do
//
//     final calendarDataModel = calendarDataModelFromJson(jsonString);

import 'dart:convert';

CalendarDataModel calendarDataModelFromJson(String str) => CalendarDataModel.fromJson(json.decode(str));

String calendarDataModelToJson(CalendarDataModel data) => json.encode(data.toJson());

class CalendarDataModel {
    String cst;
    String subId;
    String ordrId;
    String dt;
    String status;
    int bc;
    int lc;
    int dc;
    String cntct;
    String addr;
    String brkMealType;
    String lchMealType;
    String dinMealType;

    CalendarDataModel({
        required this.cst,
        required this.subId,
        required this.ordrId,
        required this.dt,
        required this.status,
        required this.bc,
        required this.lc,
        required this.dc,
        required this.cntct,
        required this.addr,
        required this.brkMealType,
        required this.lchMealType,
        required this.dinMealType,
    });

    factory CalendarDataModel.fromJson(Map<String, dynamic> json) => CalendarDataModel(
        cst: json["cst"],
        subId: json["subId"],
        ordrId: json["ordr_id"],
        dt: json["dt"],
        status: json["status"],
        bc: json["bc"],
        lc: json["lc"],
        dc: json["dc"],
        cntct: json["cntct"],
        addr: json["addr"],
        brkMealType: json["brkMealType"],
        lchMealType: json["lchMealType"],
        dinMealType: json["dinMealType"],
    );

    Map<String, dynamic> toJson() => {
        "cst": cst,
        "subId": subId,
        "ordr_id": ordrId,
        "dt": dt,
        "status": status,
        "bc": bc,
        "lc": lc,
        "dc": dc,
        "cntct": cntct,
        "addr": addr,
        "brkMealType": brkMealType,
        "lchMealType": lchMealType,
        "dinMealType": dinMealType,
    };
}
