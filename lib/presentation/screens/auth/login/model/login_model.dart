class LoginModel {
  LoginModel({
      this.status, 
      this.msg, 
      this.data,});

  LoginModel.fromJson(dynamic json) {
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  num? status;
  String? msg;
  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['msg'] = msg;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

class Data {
  Data({
      this.token, 
      this.guidUser, 
      this.currency,});

  Data.fromJson(dynamic json) {
    token = json['token'];
    guidUser = json['GuidUser'];
    currency = json['Currency'];
  }
  String? token;
  String? guidUser;
  String? currency;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = token;
    map['GuidUser'] = guidUser;
    map['Currency'] = currency;
    return map;
  }

}
