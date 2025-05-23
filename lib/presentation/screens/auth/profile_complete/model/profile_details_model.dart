class ProfileDetailsModel {
  ProfileDetailsModel({
    this.status,
    this.msg,
    this.data,
  });

  ProfileDetailsModel.fromJson(dynamic json) {
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
    this.username,
    this.firstName,
    this.middleName,
    this.lastName,
    this.phoneNumber,
    this.email,
    this.gender,
    this.dateOfBirth,
  });

  Data.fromJson(dynamic json) {
    username = json['Username'];
    firstName = json['FirstName'];
    middleName = json['MiddleName'];
    lastName = json['LastName'];
    phoneNumber = json['PhoneNumber'];
    email = json['Email'];
    gender = json['Gender'];
    dateOfBirth = json['DateOfBirth'];
  }
  String? username;
  String? firstName;
  String? middleName;
  String? lastName;
  String? phoneNumber;
  String? email;
  String? gender;
  String? dateOfBirth;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Username'] = username;
    map['FirstName'] = firstName;
    map['MiddleName'] = middleName;
    map['LastName'] = lastName;
    map['PhoneNumber'] = phoneNumber;
    map['Email'] = email;
    map['Gender'] = gender;
    map['DateOfBirth'] = dateOfBirth;
    return map;
  }
}
