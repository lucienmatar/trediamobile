class GuestLoginModel {
  GuestLoginModel({
    this.status,
    this.msg,
    this.data,
  });

  factory GuestLoginModel.fromJson(Map<String, dynamic> json) {
    return GuestLoginModel(
      status: json['status'] ?? 0, // Default value 0 if null
      msg: json['msg'] ?? '', // Default empty string if null
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }

  num? status;
  String? msg;
  Data? data;

  Map<String, dynamic> toJson() {
    return {
      'status': status ?? 0, // Ensure status is not null
      'msg': msg ?? '', // Ensure msg is not null
      'data': data?.toJson(),
    };
  }
}

class Data {
  Data({
    this.guidUser,
    this.currency,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      guidUser: json['GuidUser'] ?? '', // Default empty string if null
      currency: json['Currency'] ?? '', // Default empty string if null
    );
  }

  String? guidUser;
  String? currency;

  Map<String, dynamic> toJson() {
    return {
      'GuidUser': guidUser ?? '', // Ensure it's not null
      'Currency': currency ?? '', // Ensure it's not null
    };
  }
}
