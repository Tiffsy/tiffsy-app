// To parse this JSON data, do
//
//     final subscriptionDataModel = subscriptionDataModelFromJson(jsonString);

import 'dart:convert';

SubscriptionDataModel subscriptionDataModelFromJson(String str) => SubscriptionDataModel.fromJson(json.decode(str));

String subscriptionDataModelToJson(SubscriptionDataModel data) => json.encode(data.toJson());

class SubscriptionDataModel {
    String cstId;
    String subId;
    String strDt;
    String endDt;
    String addrLine;
    String ts;
    int subtype;
    int bill;
    int bc;
    int lc;
    int dc;
    String cntct;
    String brkMealType;
    String lchMealType;
    String dinMealType;

    SubscriptionDataModel({
        required this.cstId,
        required this.subId,
        required this.strDt,
        required this.endDt,
        required this.addrLine,
        required this.ts,
        required this.subtype,
        required this.bill,
        required this.bc,
        required this.lc,
        required this.dc,
        required this.cntct,
        required this.brkMealType,
        required this.lchMealType,
        required this.dinMealType,
    });

    factory SubscriptionDataModel.fromJson(Map<String, dynamic> json) => SubscriptionDataModel(
        cstId: json["cst_id"],
        subId: json["subId"],
        strDt: json["str_dt"],
        endDt: json["end_dt"],
        addrLine: json["addr_line"],
        ts: json["ts"],
        subtype: json["subtype"],
        bill: json["bill"],
        bc: json["bc"],
        lc: json["lc"],
        dc: json["dc"],
        cntct: json["cntct"],
        brkMealType: json["brkMealType"],
        lchMealType: json["lchMealType"],
        dinMealType: json["dinMealType"],
    );

    Map<String, dynamic> toJson() => {
        "cst_id": cstId,
        "subId": subId,
        "str_dt": strDt,
        "end_dt": endDt,
        "addr_line": addrLine,
        "ts": ts,
        "subtype": subtype,
        "bill": bill,
        "bc": bc,
        "lc": lc,
        "dc": dc,
        "cntct": cntct,
        "brkMealType": brkMealType,
        "lchMealType": lchMealType,
        "dinMealType": dinMealType,
    };
}
