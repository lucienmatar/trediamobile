class ChangePasswordModel {
  ChangePasswordModel({
    this.status,
    this.msg,
    this.data,
  });

  ChangePasswordModel.fromJson(dynamic json) {
    status = json['status'];
    msg = json['msg'];
    data = json['data'];
  }
  num? status;
  String? msg;
  bool? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['msg'] = msg;
    map['data'] = data;
    return map;
  }
}
