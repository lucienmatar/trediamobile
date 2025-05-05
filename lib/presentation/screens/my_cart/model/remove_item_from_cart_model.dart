class RemoveItemFromCartModel {
  RemoveItemFromCartModel({
      this.status, 
      this.msg, 
      this.data,});

  RemoveItemFromCartModel.fromJson(dynamic json) {
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
      this.item,});

  Data.fromJson(dynamic json) {
    item = json['item'] != null ? Item.fromJson(json['item']) : null;
  }
  Item? item;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (item != null) {
      map['item'] = item?.toJson();
    }
    return map;
  }

}

class Item {
  Item({
      this.idItem, 
      this.categoryName, 
      this.itemName, 
      this.onlineDetails, 
      this.isFavorite, 
      this.sellingCurrencyLogo, 
      this.onlinePrice, 
      this.onlinePriceBeforeDiscount, 
      this.onlinePromoteValue,});

  Item.fromJson(dynamic json) {
    idItem = json['Id_Item'];
    categoryName = json['CategoryName'];
    itemName = json['ItemName'];
    onlineDetails = json['OnlineDetails'];
    isFavorite = json['IsFavorite'];
    sellingCurrencyLogo = json['SellingCurrencyLogo'];
    onlinePrice = json['OnlinePrice'];
    onlinePriceBeforeDiscount = json['OnlinePriceBeforeDiscount'];
    onlinePromoteValue = json['OnlinePromoteValue'];
  }
  num? idItem;
  String? categoryName;
  String? itemName;
  String? onlineDetails;
  bool? isFavorite;
  String? sellingCurrencyLogo;
  num? onlinePrice;
  num? onlinePriceBeforeDiscount;
  num? onlinePromoteValue;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id_Item'] = idItem;
    map['CategoryName'] = categoryName;
    map['ItemName'] = itemName;
    map['OnlineDetails'] = onlineDetails;
    map['IsFavorite'] = isFavorite;
    map['SellingCurrencyLogo'] = sellingCurrencyLogo;
    map['OnlinePrice'] = onlinePrice;
    map['OnlinePriceBeforeDiscount'] = onlinePriceBeforeDiscount;
    map['OnlinePromoteValue'] = onlinePromoteValue;
    return map;
  }

}
