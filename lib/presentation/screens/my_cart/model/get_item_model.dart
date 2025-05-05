class GetItemModel {
  GetItemModel({
    this.status,
    this.msg,
    this.data,
  });

  GetItemModel.fromJson(dynamic json) {
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
    this.count,
  });

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
    this.idItem,
    this.categoryName,
    this.itemName,
    this.onlineDetails,
    this.isFavorite,
    this.sellingCurrencyLogo,
    this.onlinePrice,
    this.onlinePriceBeforeDiscount,
    this.onlinePromoteValue,
    this.imageURL,
  });

  Items.fromJson(dynamic json) {
    idItem = json['Id_Item'];
    categoryName = json['CategoryName'];
    itemName = json['ItemName'];
    onlineDetails = json['OnlineDetails'];
    isFavorite = json['IsFavorite'];
    sellingCurrencyLogo = json['SellingCurrencyLogo'];
    onlinePrice = json['OnlinePrice'];
    onlinePriceBeforeDiscount = json['OnlinePriceBeforeDiscount'];
    onlinePromoteValue = json['OnlinePromoteValue'];
    imageURL = json['ImageURL'];
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
  String? imageURL;

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
    map['ImageURL'] = imageURL;
    return map;
  }
}
