class CategoryModel {
  CategoryModel({
    this.status,
    this.msg,
    this.data,
  });

  CategoryModel.fromJson(dynamic json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }
  num? status;
  String? msg;
  List<Data>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['msg'] = msg;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Data {
  Data({
    this.display,
    this.value,
  });

  Data.fromJson(dynamic json) {
    display = json['Display'];
    value = json['Value'];
  }
  String? display;
  String? value;
  bool isChecked = false;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Display'] = display;
    map['Value'] = value;
    return map;
  }
}
