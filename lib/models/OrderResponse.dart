class OrderResponse {
  final String id;
  final String entity;
  final int amount;
  final int amountPaid;
  final int amountDue;
  final String currency;
  final String status;
  final List<Transfer> transfers;

  OrderResponse({
    required this.id,
    required this.entity,
    required this.amount,
    required this.amountPaid,
    required this.amountDue,
    required this.currency,
    required this.status,
    required this.transfers,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    var transferList = json['transfers'] as List;
    List<Transfer> transferItems = transferList.map((i) => Transfer.fromJson(i)).toList();

    return OrderResponse(
      id: json['id'],
      entity: json['entity'],
      amount: json['amount'],
      amountPaid: json['amount_paid'],
      amountDue: json['amount_due'],
      currency: json['currency'],
      status: json['status'],
      transfers: transferItems,
    );
  }
}

class Transfer {
  final String id;
  final String status;
  final String recipient;
  final int amount;
  final String currency;
  final bool onHold;
  final String createdAt;
  final Map<String, dynamic>? notes;

  Transfer({
    required this.id,
    required this.status,
    required this.recipient,
    required this.amount,
    required this.currency,
    required this.onHold,
    required this.createdAt,
    required this.notes,
  });

  factory Transfer.fromJson(Map<String, dynamic> json) {
    return Transfer(
      id: json['id'],
      status: json['status'],
      recipient: json['recipient'],
      amount: json['amount'],
      currency: json['currency'],
      onHold: json['on_hold'],
      notes: json["notes"],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at'] * 1000).toString(), // Convert to readable date
    );
  }
}