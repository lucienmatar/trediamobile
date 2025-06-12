class MyOrderModel {
  MyOrderModel({
    this.status,
    this.msg,
    this.data,
  });

  MyOrderModel.fromJson(dynamic json) {
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
    this.orders,
  });

  Data.fromJson(dynamic json) {
    if (json['orders'] != null) {
      orders = [];
      json['orders'].forEach((v) {
        orders?.add(Orders.fromJson(v));
      });
    }
  }
  List<Orders>? orders;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (orders != null) {
      map['orders'] = orders?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Orders {
  Orders({
    this.orderID,
    this.orderNO,
    this.purchaseDate,
    this.sellingCurrencyLogo,
    this.total,
    this.orderStatus,
    this.orderItems,
    this.otherItemsText,
  });

  Orders.fromJson(dynamic json) {
    orderID = json['OrderID'];
    orderNO = json['OrderNO'];
    purchaseDate = json['PurchaseDate'];
    sellingCurrencyLogo = json['SellingCurrencyLogo'];
    total = json['Total'];
    orderStatus = json['OrderStatus'];
    if (json['OrderItems'] != null) {
      orderItems = [];
      json['OrderItems'].forEach((v) {
        orderItems?.add(OrderItems.fromJson(v));
      });
    }
    otherItemsText = json['OtherItemsText'];
  }
  num? orderID;
  String? orderNO;
  String? purchaseDate;
  String? sellingCurrencyLogo;
  num? total;
  int? orderItemsLength = 0;
  String? orderStatus;
  List<OrderItems>? orderItems;
  String? otherItemsText;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['OrderID'] = orderID;
    map['OrderNO'] = orderNO;
    map['PurchaseDate'] = purchaseDate;
    map['SellingCurrencyLogo'] = sellingCurrencyLogo;
    map['Total'] = total;
    map['OrderStatus'] = orderStatus;
    if (orderItems != null) {
      map['OrderItems'] = orderItems?.map((v) => v.toJson()).toList();
    }
    map['OtherItemsText'] = otherItemsText;
    return map;
  }
}

class OrderItems {
  OrderItems({
    this.itemName,
    this.qty,
  });

  OrderItems.fromJson(dynamic json) {
    itemName = json['ItemName'];
    qty = json['Qty'];
  }
  String? itemName;
  num? qty;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ItemName'] = itemName;
    map['Qty'] = qty;
    return map;
  }
}
