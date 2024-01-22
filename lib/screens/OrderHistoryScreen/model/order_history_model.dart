class OrderHistoryModel {
  int count;
  String dish;
  String mealType;
  String subscriptionType;
  DateTime deliveryDate;
  double amount;
  bool delivered;
  bool cancelled;

  OrderHistoryModel(
      {required this.count,
      required this.dish,
      required this.mealType,
      required this.subscriptionType,
      required this.deliveryDate,
      required this.amount,
      required this.delivered,
      required this.cancelled});

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    bool delivered = true;
    bool cancelled = false;
    DateTime dateAndTime = DateTime.parse(json["deliveryDate"]);

    if (dateAndTime.isAfter(DateTime.now())) {
      delivered = false;
    }
    if (json["cancelled"] == true) {
      cancelled = true;
    }
    return OrderHistoryModel(
      amount: json["amount"].toDouble(),
      count: json["count"],
      deliveryDate: dateAndTime,
      dish: json["dish"],
      mealType: json["mealType"],
      subscriptionType: json["subscriptionType"],
      delivered: delivered,
      cancelled: cancelled,
    );
  }

  Map<String, dynamic> toMap() => {
        "count": count,
        "dish": dish,
        "mealType": mealType,
        "subscriptionType": subscriptionType,
        "deliveryDate": deliveryDate
            .millisecondsSinceEpoch, // This is milli-seconds since epoch,
        "amount": amount,
        "delivered": delivered,
        "cancelled": cancelled
      };
}
