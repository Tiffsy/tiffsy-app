// To parse this JSON data, do
//
//     final subscriptionDataModel = subscriptionDataModelFromJson(jsonString);

import 'dart:convert';

SubscriptionDataModel subscriptionDataModelFromJson(String str) =>
    SubscriptionDataModel.fromJson(json.decode(str));

String subscriptionDataModelToJson(SubscriptionDataModel data) =>
    json.encode(data.toJson());

class SubscriptionDataModel {
  String? nickname;
  int dc;
  String ts;
  int bc;
  String cntct;
  String strDt;
  String endDt;
  int subtype;
  String sbcrId;
  String brkMealType;
  String addrId;
  String addrLine;
  int bill;
  String cstId;
  int lc;
  String dinMealType;
  String lchMealType;

  SubscriptionDataModel({
    this.nickname,
    required this.dc,
    required this.ts,
    required this.bc,
    required this.cntct,
    required this.strDt,
    required this.endDt,
    required this.subtype,
    required this.sbcrId,
    required this.brkMealType,
    required this.addrId,
    required this.addrLine,
    required this.bill,
    required this.cstId,
    required this.lc,
    required this.dinMealType,
    required this.lchMealType,
  });

  factory SubscriptionDataModel.fromJson(Map<String, dynamic> json) {
    //print(json);
    return SubscriptionDataModel(
      nickname: json["nickname"],
      dc: json["dc"],
      ts: json["ts"],
      bc: json["bc"],
      cntct: json["cntct"],
      strDt: json["str_dt"],
      endDt: json["end_dt"],
      subtype: json["subtype"],
      sbcrId: json["sbcr_id"],
      brkMealType: json["brkMealType"],
      addrId: json["addr_id"],
      addrLine: json["addr_line"],
      bill: json["bill"],
      cstId: json["cst_id"],
      lc: json["lc"],
      dinMealType: json["dinMealType"],
      lchMealType: json["lchMealType"],
    );
  }

  Map<String, dynamic> toJson() => {
        "nickname": nickname,
        "dc": dc,
        "ts": ts,
        "bc": bc,
        "cntct": cntct,
        "str_dt": strDt,
        "end_dt": endDt,
        "subtype": subtype,
        "sbcr_id": sbcrId,
        "brkMealType": brkMealType,
        "addr_id": addrId,
        "addr_line": addrLine,
        "bill": bill,
        "cst_id": cstId,
        "lc": lc,
        "dinMealType": dinMealType,
        "lchMealType": lchMealType,
      };

  @override
  String toString() => toJson().toString();
}
