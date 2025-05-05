class SubTotalPriceCart {
  SubTotalPriceCart({
      this.status, 
      this.msg, 
      this.data,});

  SubTotalPriceCart.fromJson(dynamic json) {
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
      this.subtotal,});

  Data.fromJson(dynamic json) {
    subtotal = json['subtotal'] != null ? Subtotal.fromJson(json['subtotal']) : null;
  }
  Subtotal? subtotal;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (subtotal != null) {
      map['subtotal'] = subtotal?.toJson();
    }
    return map;
  }

}

class Subtotal {
  Subtotal({
      this.sellingCurrencyLogo, 
      this.subTotalPrice, 
      this.subTotalPriceBeforeDiscount,});

  Subtotal.fromJson(dynamic json) {
    sellingCurrencyLogo = json['SellingCurrencyLogo'];
    subTotalPrice = json['SubTotalPrice'];
    subTotalPriceBeforeDiscount = json['SubTotalPriceBeforeDiscount'];
  }
  String? sellingCurrencyLogo;
  num? subTotalPrice;
  num? subTotalPriceBeforeDiscount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['SellingCurrencyLogo'] = sellingCurrencyLogo;
    map['SubTotalPrice'] = subTotalPrice;
    map['SubTotalPriceBeforeDiscount'] = subTotalPriceBeforeDiscount;
    return map;
  }

}
