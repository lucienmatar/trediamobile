class ChangePhoneNumberModel {
  ChangePhoneNumberModel({
    this.status,
    this.msg,
    this.data,
  });

  ChangePhoneNumberModel.fromJson(dynamic json) {
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
    this.changePhoneNumberID,
    this.phoneNumber,
  });

  Data.fromJson(dynamic json) {
    changePhoneNumberID = json['ChangePhoneNumberID'];
    phoneNumber = json['PhoneNumber'];
  }
  num? changePhoneNumberID;
  String? phoneNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ChangePhoneNumberID'] = changePhoneNumberID;
    map['PhoneNumber'] = phoneNumber;
    return map;
  }
}
