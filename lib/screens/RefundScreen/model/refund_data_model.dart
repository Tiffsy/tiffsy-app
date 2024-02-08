// To parse this JSON data, do
//
//     final refundDataModel = refundDataModelFromJson(jsonString);

import 'dart:convert';

RefundDataModel refundDataModelFromJson(String str) => RefundDataModel.fromJson(json.decode(str));

String refundDataModelToJson(RefundDataModel data) => json.encode(data.toJson());

class RefundDataModel {
    String rfndId;
    String subscriptionId;
    String subcriptionName;
    String refundDate;
    int refundAmount;
    String status;

    RefundDataModel({
        required this.rfndId,
        required this.subscriptionId,
        required this.subcriptionName,
        required this.refundDate,
        required this.refundAmount,
        required this.status,
    });

    factory RefundDataModel.fromJson(Map<String, dynamic> json) => RefundDataModel(
        rfndId: json["rfndId"],
        subscriptionId: json["subscriptionId"],
        subcriptionName: json["subcriptionName"],
        refundDate: json["refundDate"],
        refundAmount: json["refundAmount"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "rfndId": rfndId,
        "subscriptionId": subscriptionId,
        "subcriptionName": subcriptionName,
        "refundDate": refundDate,
        "refundAmount": refundAmount,
        "status": status,
    };
}
