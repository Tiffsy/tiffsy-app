class PaymentHistoryDataModel {
  String trnId;
  String subscriptionId;
  String paymentDate;
  double paymentAmount;

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
        paymentAmount: json["amt"],
        paymentDate: json["ts"],
      );
}
// trn_id: trn_id,
// sbcr_id: sbcr_id,
// amt: amt,
// cst_id: cst_id,
  // ts: ts
