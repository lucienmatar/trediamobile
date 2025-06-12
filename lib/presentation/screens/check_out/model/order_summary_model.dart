class OrderSummaryModel {
  OrderSummaryModel({
    this.status,
    this.msg,
    this.data,
  });

  OrderSummaryModel.fromJson(dynamic json) {
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
  });

  Data.fromJson(dynamic json) {
    orderSummary = json['orderSummary'] != null ? OrderSummary.fromJson(json['orderSummary']) : null;
  }
  OrderSummary? orderSummary;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (orderSummary != null) {
      map['orderSummary'] = orderSummary?.toJson();
    }
    return map;
  }
}

class OrderSummary {
  OrderSummary({
    this.sellingCurrencyLogo,
    this.subtotal,
    this.discount,
    this.shippingFee,
    this.vat,
    this.total,
  });

  OrderSummary.fromJson(dynamic json) {
    sellingCurrencyLogo = json['SellingCurrencyLogo'];
    subtotal = json['Subtotal'];
    discount = json['Discount'];
    shippingFee = json['ShippingFee'];
    vat = json['Vat'];
    total = json['Total'];
  }
  String? sellingCurrencyLogo;
  num? subtotal;
  num? discount;
  num? shippingFee;
  num? vat;
  num? total;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['SellingCurrencyLogo'] = sellingCurrencyLogo;
    map['Subtotal'] = subtotal;
    map['Discount'] = discount;
    map['ShippingFee'] = shippingFee;
    map['Vat'] = vat;
    map['Total'] = total;
    return map;
  }
}
