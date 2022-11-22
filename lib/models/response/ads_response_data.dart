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





// To parse this JSON data, do
//
//     final dashbordResponsemodel = dashbordResponsemodelFromJson(jsonString);


// import 'dart:convert';

// DashbordResponsemodel dashbordResponsemodelFromJson(String str) => DashbordResponsemodel.fromJson(json.decode(str));

// String dashbordResponsemodelToJson(DashbordResponsemodel data) => json.encode(data.toJson());

// class DashbordResponsemodel {
//     DashbordResponsemodel({
//         required this.status,
//         required this.statuscode,
//         required this.statusDescription,
//         required this.totalRows,
//         required this.response,
//     });

//     final String status;
//     final String statuscode;
//     final String statusDescription;
//     final String totalRows;
//     final List<AdItem> response;

//     factory DashbordResponsemodel.fromJson(Map<String, dynamic> json) => DashbordResponsemodel(
//         status: json["Status"],
//         statuscode: json["Statuscode"],
//         statusDescription: json["StatusDescription"],
//         totalRows: json["TotalRows"],
//         response: List<AdItem>.from(json["Response"].map((x) => AdItem.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "Status": status,
//         "Statuscode": statuscode,
//         "StatusDescription": statusDescription,
//         "TotalRows": totalRows,
//         "Response": List<dynamic>.from(response.map((x) => x.toJson())),
//     };
// }

// class AdItem {
//     AdItem({
//         required this.addspotId,
//         required this.title,
//         required this.image,
//         required this.sequence,
//         required this.linkType,
//         required this.linkValue,
//         required this.id,
//     });

//     final String addspotId;
//     final String title;
//     final String image;
//     final String sequence;
//     final LinkType? linkType;
//     final dynamic linkValue;
//     final String id;

//     factory AdItem.fromJson(Map<String, dynamic> json) => AdItem(
//         addspotId: json["addspot_id"],
//         title: json["title"],
//         image: json["image"],
//         sequence: json["sequence"],
//         linkType: linkTypeValues.map?[json["link_type"]],
//         linkValue: json["link_value"],
//         id: json["id"],
//     );

//     Map<String, dynamic> toJson() => {
//         "addspot_id": addspotId,
//         "title": title,
//         "image": image,
//         "sequence": sequence,
//         "link_type": linkTypeValues.reverse[linkType],
//         "link_value": linkValue,
//         "id": id,
//     };
// }

// enum LinkType { PODCAST, WEB }

// final linkTypeValues = EnumValues({
//     "podcast": LinkType.PODCAST,
//     "web": LinkType.WEB
// });

// class LinkValueClass {
//     LinkValueClass({
//         required this.oid,
//     });

//     final String oid;

//     factory LinkValueClass.fromJson(Map<String, dynamic> json) => LinkValueClass(
//         oid: json["\u0024oid"],
//     );

//     Map<String, dynamic> toJson() => {
//         "\u0024oid": oid,
//     };
// }

// class EnumValues<T> {
//     Map<String, T>? map;
//     Map<T, String>? reverseMap;

//     EnumValues(this.map);

//     Map<T, String> get reverse {
//         reverseMap ??= map?.map((k, v) => MapEntry(v, k));
//         return reverseMap!;
//     }
// }


