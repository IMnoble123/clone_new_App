// To parse this JSON data, do
//
//     final collectionsDataResponse = collectionsDataResponseFromJson(jsonString);

import 'dart:convert';

CollectionsDataResponse collectionsDataResponseFromJson(String str) => CollectionsDataResponse.fromJson(json.decode(str));

String collectionsDataResponseToJson(CollectionsDataResponse data) => json.encode(data.toJson());

class CollectionsDataResponse {
  CollectionsDataResponse({
    this.status,
    this.statuscode,
    this.statusDescription,
    this.response,
  });

  String? status;
  String? statuscode;
  String? statusDescription;
  List<CollectionItem>? response;

  factory CollectionsDataResponse.fromJson(Map<String, dynamic> json) => CollectionsDataResponse(
    status: json["Status"],
    statuscode: json["Statuscode"],
    statusDescription: json["StatusDescription"],
    response: List<CollectionItem>.from(json["Response"].map((x) => CollectionItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "Statuscode": statuscode,
    "StatusDescription": statusDescription,
    "Response": List<dynamic>.from(response!.map((x) => x.toJson())),
  };
}

class CollectionItem {
  CollectionItem({
    this.folderId,
    this.folderName,
    this.podcastCount,
    this.folderCreatedDate,
  });

  String? folderId;
  String? folderName;
  String? podcastCount;
  String? folderCreatedDate;

  factory CollectionItem.fromJson(Map<String, dynamic> json) => CollectionItem(
    folderId: json["folder_id"],
    folderName: json["folder_name"],
    podcastCount: json["podcast_count"],
    folderCreatedDate: json["folder_created_date"],
  );

  Map<String, dynamic> toJson() => {
    "folder_id": folderId,
    "folder_name": folderName,
    "podcast_count": podcastCount,
    "folder_created_date": folderCreatedDate,
  };
}
