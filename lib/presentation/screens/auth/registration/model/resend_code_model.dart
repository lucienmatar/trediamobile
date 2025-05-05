class ResendCodeModel {
  ResendCodeModel({
      this.status, 
      this.msg, 
      this.data,});

  ResendCodeModel.fromJson(dynamic json) {
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
      this.timeoutInMinutes,});

  Data.fromJson(dynamic json) {
    timeoutInMinutes = json['TimeoutInMinutes'];
  }
  num? timeoutInMinutes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['TimeoutInMinutes'] = timeoutInMinutes;
    return map;
  }

}
