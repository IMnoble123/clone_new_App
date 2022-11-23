// To parse this JSON data, do

//     final adsResponseData = adsResponseDataFromJson(jsonString);

import 'dart:convert';

AdsResponseData adsResponseDataFromJson(String str) =>
    AdsResponseData.fromJson(json.decode(str));

String adsResponseDataToJson(AdsResponseData data) =>
    json.encode(data.toJson());

class AdsResponseData {
  AdsResponseData({
    this.status,
    this.statuscode,
    this.statusDescription,
    this.response,
  });

  String? status;
  String? statuscode;
  String? statusDescription;
  List<AdItem>? response;

  factory AdsResponseData.fromJson(dynamic json) {
    return AdsResponseData(
      status: json["Status"],
      statuscode: json["Statuscode"],
      statusDescription: json["StatusDescription"],
      response:
          List<AdItem>.from(json["Response"].map((x) => AdItem.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Statuscode": statuscode,
        "StatusDescription": statusDescription,
        "Response": List<dynamic>.from(response!.map((x) => x.toJson())),
      };
}

class AdItem {
  AdItem({
    this.addspotId,
    this.title,
    this.image,
    this.linkType,
    this.linkValue,
    this.id,
  });

  String? addspotId;
  String? title;
  String? image;
  String? linkType;
  String? linkValue;
  String? id;

  factory AdItem.fromJson(Map<String, dynamic> json) => AdItem(
        addspotId: json["addspot_id"],
        title: json["title"],
        image: json["image"],
        linkType: json["link_type"],
        linkValue: json["link_value"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "addspot_id": addspotId,
        "title": title,
        "image": image,
        "link_type": linkType,
        "link_value": linkValue,
        "id": id
      };
}




