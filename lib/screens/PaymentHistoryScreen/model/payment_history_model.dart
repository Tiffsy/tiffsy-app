class PaymentHistoryDataModel {
  String trnId;
  String subscriptionId;
  String paymentDate;
  int paymentAmount;

  PaymentHistoryDataModel({
    required this.trnId,
    required this.subscriptionId,
    required this.paymentAmount,
    required this.paymentDate,
  });

  factory PaymentHistoryDataModel.formJson(Map<String, dynamic> json) =>
      PaymentHistoryDataModel(
        trnId: json["trn_id"],
        subscriptionId: json["sbcr_id"],
        paymentAmount: (json["amt"].runtimeType == String) ? int.parse(json["amt"]) : json["amt"],
        paymentDate: json["ts"],
      );
}

