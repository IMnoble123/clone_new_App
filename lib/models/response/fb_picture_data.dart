// To parse this JSON data, do
//
//     final fbPictureData = fbPictureDataFromJson(jsonString);

import 'dart:convert';

FbPictureData fbPictureDataFromJson(String str) => FbPictureData.fromJson(json.decode(str));

String fbPictureDataToJson(FbPictureData data) => json.encode(data.toJson());

class FbPictureData {
  FbPictureData({
    this.data,
  });

  Data? data;

  factory FbPictureData.fromJson(Map<String, dynamic> json) => FbPictureData(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.isSilhouette,
    this.height,
    this.url,
    this.width,
  });

  bool? isSilhouette;
  int? height;
  String? url;
  int? width;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    isSilhouette: json["is_silhouette"],
    height: json["height"],
    url: json["url"],
    width: json["width"],
  );

  Map<String, dynamic> toJson() => {
    "is_silhouette": isSilhouette,
    "height": height,
    "url": url,
    "width": width,
  };
}
