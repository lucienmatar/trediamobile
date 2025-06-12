class PlaceOrderModel {
  PlaceOrderModel({
    this.status,
    this.msg,
    this.data,
  });

  PlaceOrderModel.fromJson(dynamic json) {
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
    this.order,
  });

  Data.fromJson(dynamic json) {
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
  }
  Order? order;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (order != null) {
      map['order'] = order?.toJson();
    }
    return map;
  }
}

class Order {
  Order({
    this.orderID,
    this.orderNO,
    this.purchaseDate,
  });

  Order.fromJson(dynamic json) {
    orderID = json['OrderID'];
    orderNO = json['OrderNO'];
    purchaseDate = json['PurchaseDate'];
  }
  num? orderID;
  String? orderNO;
  String? purchaseDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['OrderID'] = orderID;
    map['OrderNO'] = orderNO;
    map['PurchaseDate'] = purchaseDate;
    return map;
  }
}
