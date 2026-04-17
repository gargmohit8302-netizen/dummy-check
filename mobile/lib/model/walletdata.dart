class WalletResponse {
  bool success;
  int statusCode;
  String message;
  WalletData data;

  WalletResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory WalletResponse.fromJson(Map<String, dynamic> json) {
    return WalletResponse(
      success: json["success"] as bool,
      statusCode: json["statusCode"] as int,
      message: json["message"] as String,
      data: WalletData.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "statusCode": statusCode,
    "message": message,
    "data": data.toJson(),
  };
}

class WalletData {
  double walletBalance;
  List<Transaction> transactions;

  WalletData({
    required this.walletBalance,
    required this.transactions,
  });

  factory WalletData.fromJson(Map<String, dynamic> json) {
    return WalletData(
      walletBalance: (json["walletBalance"] as num).toDouble(),
      transactions: (json["transactions"] as List<dynamic>)
          .map((e) => Transaction.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "walletBalance": walletBalance,
    "transactions": transactions.map((e) => e.toJson()).toList(),
  };
}

class Transaction {
  String id;
  String type;
  int? instrumentId;
  double amount;
  String description;
  String user;
  String? tradeId;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String? admin;

  Transaction({
    required this.id,
    required this.type,
    this.instrumentId,
    required this.amount,
    required this.description,
    required this.user,
    this.tradeId,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.admin,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json["_id"] as String,
      type: json["type"] as String,
      instrumentId:
      json["instrument_id"] != null ? json["instrument_id"] as int : null,
      amount: (json["amount"] as num).toDouble(),
      description: json["description"] as String,
      user: json["user"] as String,
      tradeId: json["trade_id"] as String?,
      createdAt: DateTime.parse(json["createdAt"] as String),
      updatedAt: DateTime.parse(json["updatedAt"] as String),
      v: json["__v"] as int,
      admin: json["admin"] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "type": type,
    "instrument_id": instrumentId,
    "amount": amount,
    "description": description,
    "user": user,
    "trade_id": tradeId,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "admin": admin,
  };
}
