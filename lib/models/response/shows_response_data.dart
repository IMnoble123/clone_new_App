// To parse this JSON data, do
//
//     final showsResponseData = showsResponseDataFromJson(jsonString);

import 'dart:convert';

ShowsResponseData showsResponseDataFromJson(String str) => ShowsResponseData.fromJson(json.decode(str));

String showsResponseDataToJson(ShowsResponseData data) => json.encode(data.toJson());

class ShowsResponseData {
  ShowsResponseData({
    this.status,
    this.statuscode,
    this.statusDescription,
    this.totalRows,
    this.showsList,
  });

  String? status;
  String? statuscode;
  String? statusDescription;
  String? totalRows;
  List<ShowItem>? showsList;

  factory ShowsResponseData.fromJson(Map<String, dynamic> json) => ShowsResponseData(
    status: json["Status"],
    statuscode: json["Statuscode"],
    statusDescription: json["StatusDescription"],
    totalRows: json["TotalRows"],
    showsList: List<ShowItem>.from(json["Response"].map((x) => ShowItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "Statuscode": statuscode,
    "StatusDescription": statusDescription,
    "TotalRows": totalRows,
    "Response": List<dynamic>.from(showsList!.map((x) => x.toJson())),
  };
}

class ShowItem {
  ShowItem({
    this.showsId,
    this.showsName,
    this.showsImage,
    this.totalPodcast,
  });

  String? showsId;
  String? showsName;
  String? showsImage;
  String? totalPodcast;

  factory ShowItem.fromJson(Map<String, dynamic> json) => ShowItem(
    showsId: json["shows_id"],
    showsName: json["shows_name"],
    showsImage: json["shows_image"],
    totalPodcast: json["total_podcast"],
  );

  Map<String, dynamic> toJson() => {
    "shows_id": showsId,
    "shows_name": showsName,
    "shows_image": showsImage,
    "total_podcast": totalPodcast,
  };
}
