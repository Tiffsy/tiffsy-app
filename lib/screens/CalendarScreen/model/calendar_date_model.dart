// To parse this JSON data, do
//
//     final calendarDataModel = calendarDataModelFromJson(jsonString);

import 'dart:convert';

CalendarDataModel calendarDataModelFromJson(String str) => CalendarDataModel.fromJson(json.decode(str));

String calendarDataModelToJson(CalendarDataModel data) => json.encode(data.toJson());

class CalendarDataModel {
    int dc;
    int bc;
    String cntct;
    String addr;
    String sbcrId;
    String brkMealType;
    String addrId;
    String dt;
    String cstId;
    int lc;
    String dinMealType;
    String ordrId;
    String lchMealType;

    CalendarDataModel({
        required this.dc,
        required this.bc,
        required this.cntct,
        required this.addr,
        required this.sbcrId,
        required this.brkMealType,
        required this.addrId,
        required this.dt,
        required this.cstId,
        required this.lc,
        required this.dinMealType,
        required this.ordrId,
        required this.lchMealType,
    });

    factory CalendarDataModel.fromJson(Map<String, dynamic> json) => CalendarDataModel(
        dc: json["dc"],
        bc: json["bc"],
        cntct: json["cntct"],
        addr: json["addr"],
        sbcrId: json["sbcr_id"],
        brkMealType: json["brkMealType"],
        addrId: json["addr_id"],
        dt: json["dt"],
        cstId: json["cst_id"],
        lc: json["lc"],
        dinMealType: json["dinMealType"],
        ordrId: json["ordr_id"],
        lchMealType: json["lchMealType"],
    );

    Map<String, dynamic> toJson() => {
        "dc": dc,
        "bc": bc,
        "cntct": cntct,
        "addr": addr,
        "sbcr_id": sbcrId,
        "brkMealType": brkMealType,
        "addr_id": addrId,
        "dt": dt,
        "cst_id": cstId,
        "lc": lc,
        "dinMealType": dinMealType,
        "ordr_id": ordrId,
        "lchMealType": lchMealType,
    };

    @override
  String toString() {
    return toJson().toString();
  }

  bool hasNoOrders() {
    return (lc + bc + dc == 0);
  }
}
