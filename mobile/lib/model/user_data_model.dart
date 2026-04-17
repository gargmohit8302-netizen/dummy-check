class UserDataModel {
  bool? success;
  int? statusCode;
  String? message;
  Data? mainData;

  UserDataModel({this.success, this.statusCode, this.message, this.mainData});

  UserDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    mainData = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (mainData != null) {
      data['data'] = mainData!.toJson();
    }
    return data;
  }
}

class Data {
  List<UserData>? data;
  int? totalData;
  int? perPage;
  int? page;
  int? totalPages;

  Data({this.data, this.totalData, this.perPage, this.page, this.totalPages});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <UserData>[];
      json['data'].forEach((v) {
        data!.add(UserData.fromJson(v));
      });
    }
    totalData = json['totalData'];
    perPage = json['perPage'];
    page = json['page'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['totalData'] = totalData;
    data['perPage'] = perPage;
    data['page'] = page;
    data['totalPages'] = totalPages;
    return data;
  }
}

class UserData {
  String? id;
  String? email;
  String? name;
  String? password;
  String? isBlocked;
  num? walletBalance;
  int? tradeLimit; // Added missing trade_limit field
  String? createdAt;
  String? updatedAt;
  int? version;

  UserData({
    this.id,
    this.email,
    this.name,
    this.password,
    this.isBlocked,
    this.walletBalance,
    this.tradeLimit,
    this.createdAt,
    this.updatedAt,
    this.version,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    email = json['email'];
    name = json['name'];
    password = json['password'];
    isBlocked = json['isBlocked'];
    walletBalance = json['walletBalance'];
    tradeLimit = json['trade_limit']; // Parsing trade_limit field
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    version = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['password'] = password;
    data['isBlocked'] = isBlocked;
    data['walletBalance'] = walletBalance;
    data['trade_limit'] = tradeLimit; // Added trade_limit field
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = version;
    return data;
  }
}
