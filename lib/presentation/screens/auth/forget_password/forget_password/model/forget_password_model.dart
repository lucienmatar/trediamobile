class ForgetPasswordModel {
  ForgetPasswordModel({
      this.status, 
      this.msg, 
      this.data,});

  ForgetPasswordModel.fromJson(dynamic json) {
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
      this.forgetPasswordID, 
      this.userID, 
      this.phoneNumber,});

  Data.fromJson(dynamic json) {
    forgetPasswordID = json['ForgetPasswordID'];
    userID = json['UserID'];
    phoneNumber = json['PhoneNumber'];
  }
  num? forgetPasswordID;
  num? userID;
  String? phoneNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ForgetPasswordID'] = forgetPasswordID;
    map['UserID'] = userID;
    map['PhoneNumber'] = phoneNumber;
    return map;
  }

}
