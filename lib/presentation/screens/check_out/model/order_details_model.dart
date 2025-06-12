class OrderDetailsModel {
  OrderDetailsModel({
    this.status,
    this.msg,
    this.data,
  });

  OrderDetailsModel.fromJson(dynamic json) {
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
    this.orderSummary,
    this.orderItems,
  });

  Data.fromJson(dynamic json) {
    orderSummary = json['orderSummary'] != null ? OrderSummary.fromJson(json['orderSummary']) : null;
    if (json['orderItems'] != null) {
      orderItems = [];
      json['orderItems'].forEach((v) {
        orderItems?.add(OrderItems.fromJson(v));
      });
    }
  }
  OrderSummary? orderSummary;
  List<OrderItems>? orderItems;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (orderSummary != null) {
      map['orderSummary'] = orderSummary?.toJson();
    }
    if (orderItems != null) {
      map['orderItems'] = orderItems?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class OrderItems {
  OrderItems({
    this.idItem,
    this.itemName,
    this.qty,
    this.sellingCurrencyLogo,
    this.totalPrice,
    this.totalPriceBeforeDiscount,
    this.imageURL,
  });

  OrderItems.fromJson(dynamic json) {
    idItem = json['Id_Item'];
    itemName = json['ItemName'];
    qty = json['Qty'];
    sellingCurrencyLogo = json['SellingCurrencyLogo'];
    totalPrice = json['TotalPrice'];
    totalPriceBeforeDiscount = json['TotalPriceBeforeDiscount'];
    imageURL = json['ImageURL'];
  }
  num? idItem;
  String? itemName;
  num? qty;
  String? sellingCurrencyLogo;
  num? totalPrice;
  num? totalPriceBeforeDiscount;
  String? imageURL;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id_Item'] = idItem;
    map['ItemName'] = itemName;
    map['Qty'] = qty;
    map['SellingCurrencyLogo'] = sellingCurrencyLogo;
    map['TotalPrice'] = totalPrice;
    map['TotalPriceBeforeDiscount'] = totalPriceBeforeDiscount;
    map['ImageURL'] = imageURL;
    return map;
  }
}

class OrderSummary {
  OrderSummary({
    this.addressDetails,
    this.orderStatus,
    this.sellingCurrencyLogo,
    this.subtotal,
    this.discount,
    this.shippingFee,
    this.vat,
    this.total,
    this.paymentMethod,
  });

  OrderSummary.fromJson(dynamic json) {
    addressDetails = json['AddressDetails'];
    orderStatus = json['OrderStatus'];
    sellingCurrencyLogo = json['SellingCurrencyLogo'];
    subtotal = json['Subtotal'];
    discount = json['Discount'];
    shippingFee = json['ShippingFee'];
    vat = json['Vat'];
    total = json['Total'];
    paymentMethod = json['PaymentMethod'];
  }
  String? addressDetails;
  String? orderStatus;
  String? sellingCurrencyLogo;
  num? subtotal;
  num? discount;
  num? shippingFee;
  num? vat;
  num? total;
  String? paymentMethod;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['AddressDetails'] = addressDetails;
    map['OrderStatus'] = orderStatus;
    map['SellingCurrencyLogo'] = sellingCurrencyLogo;
    map['Subtotal'] = subtotal;
    map['Discount'] = discount;
    map['ShippingFee'] = shippingFee;
    map['Vat'] = vat;
    map['Total'] = total;
    map['PaymentMethod'] = paymentMethod;
    return map;
  }
}
