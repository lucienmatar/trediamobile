class MyAddressesModel {
  MyAddressesModel({
    this.status,
    this.msg,
    this.data,
  });

  MyAddressesModel.fromJson(dynamic json) {
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
    this.addresses,
  });

  Data.fromJson(dynamic json) {
    if (json['addresses'] != null) {
      addresses = [];
      json['addresses'].forEach((v) {
        addresses?.add(Addresses.fromJson(v));
      });
    }
  }
  List<Addresses>? addresses;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (addresses != null) {
      map['addresses'] = addresses?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Addresses {
  Addresses({
    this.addressID,
    this.townID,
    this.qazaTown,
    this.addressDetails,
    this.longitude,
    this.latitude,
  });

  Addresses.fromJson(dynamic json) {
    addressID = json['AddressID'];
    townID = json['TownID'];
    qazaTown = json['QazaTown'];
    addressDetails = json['AddressDetails'];
    longitude = json['Longitude'];
    latitude = json['Latitude'];
  }
  num? addressID;
  num? townID;
  String? qazaTown;
  String? addressDetails;
  num? longitude;
  num? latitude;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['AddressID'] = addressID;
    map['TownID'] = townID;
    map['QazaTown'] = qazaTown;
    map['AddressDetails'] = addressDetails;
    map['Longitude'] = longitude;
    map['Latitude'] = latitude;
    return map;
  }
}
