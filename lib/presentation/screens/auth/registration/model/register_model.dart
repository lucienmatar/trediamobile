class RegisterModel {
  RegisterModel({
      this.status, 
      this.msg, 
      this.data,});

  RegisterModel.fromJson(dynamic json) {
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
      this.userID, 
      this.phoneNumber,});

  Data.fromJson(dynamic json) {
    userID = json['UserID'];
    phoneNumber = json['PhoneNumber'];
  }
  num? userID;
  String? phoneNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['UserID'] = userID;
    map['PhoneNumber'] = phoneNumber;
    return map;
  }

}
