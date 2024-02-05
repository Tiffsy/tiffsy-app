// To parse this JSON data, do
//
//     final couponDataModel = couponDataModelFromJson(jsonString);

import 'dart:convert';

CouponDataModel couponDataModelFromJson(String str) => CouponDataModel.fromJson(json.decode(str));

String couponDataModelToJson(CouponDataModel data) => json.encode(data.toJson());
class CouponDataModel {
    String cstId;
    String cpnCode;
    int cpnCnt;
    String expiryDt;
    int discountPrnct;
    int minPrice;
    int maxDiscount;

    CouponDataModel({
        required this.cstId,
        required this.cpnCode,
        required this.cpnCnt,
        required this.expiryDt,
        required this.discountPrnct,
        required this.minPrice,
        required this.maxDiscount,
    });

    factory CouponDataModel.fromJson(Map<String, dynamic> json) => CouponDataModel(
        cstId: json["cst_id"],
        cpnCode: json["cpn_code"],
        cpnCnt: json["cpn_cnt"],
        expiryDt: json["expiry_dt"],
        discountPrnct: json["discount_prnct"],
        minPrice: json["min_price"],
        maxDiscount: json["max_discount"],
    );

    Map<String, dynamic> toJson() => {
        "cst_id": cstId,
        "cpn_code": cpnCode,
        "cpn_cnt": cpnCnt,
        "expiry_dt": expiryDt,
        "discount_prnct": discountPrnct,
        "min_price": minPrice,
        "max_discount": maxDiscount,
    };
}
