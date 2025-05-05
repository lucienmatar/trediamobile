class MyCartItemModel {
  MyCartItemModel({
      this.status, 
      this.msg, 
      this.data,});

  MyCartItemModel.fromJson(dynamic json) {
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
      this.items, 
      this.count,});

  Data.fromJson(dynamic json) {
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items?.add(Items.fromJson(v));
      });
    }
    count = json['count'];
  }
  List<Items>? items;
  num? count;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (items != null) {
      map['items'] = items?.map((v) => v.toJson()).toList();
    }
    map['count'] = count;
    return map;
  }

}

class Items {
  Items({
      this.idCart, 
      this.idItem, 
      this.itemName, 
      this.categoryName, 
      this.qty, 
      this.sellingCurrencyLogo, 
      this.sumOnlinePrice, 
      this.sumOnlinePriceBeforeDiscount, 
      this.onlinePromoteValue, 
      this.imageURL,});

  Items.fromJson(dynamic json) {
    idCart = json['Id_Cart'];
    idItem = json['Id_Item'];
    itemName = json['ItemName'];
    categoryName = json['CategoryName'];
    qty = json['Qty'];
    sellingCurrencyLogo = json['SellingCurrencyLogo'];
    sumOnlinePrice = json['SumOnlinePrice'];
    sumOnlinePriceBeforeDiscount = json['SumOnlinePriceBeforeDiscount'];
    onlinePromoteValue = json['OnlinePromoteValue'];
    imageURL = json['ImageURL'];
  }
  num? idCart;
  num? idItem;
  String? itemName;
  String? categoryName;
  num? qty;
  String? sellingCurrencyLogo;
  num? sumOnlinePrice;
  num? sumOnlinePriceBeforeDiscount;
  num? onlinePromoteValue;
  String? imageURL;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id_Cart'] = idCart;
    map['Id_Item'] = idItem;
    map['ItemName'] = itemName;
    map['CategoryName'] = categoryName;
    map['Qty'] = qty;
    map['SellingCurrencyLogo'] = sellingCurrencyLogo;
    map['SumOnlinePrice'] = sumOnlinePrice;
    map['SumOnlinePriceBeforeDiscount'] = sumOnlinePriceBeforeDiscount;
    map['OnlinePromoteValue'] = onlinePromoteValue;
    map['ImageURL'] = imageURL;
    return map;
  }

}
