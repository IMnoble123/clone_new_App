// To parse this JSON data, do
//
//     final categoryResponse = categoryResponseFromJson(jsonString);

import 'dart:convert';

CategoryResponse categoryResponseFromJson(String str) =>
    CategoryResponse.fromJson(json.decode(str));

String categoryResponseToJson(CategoryResponse data) =>
    json.encode(data.toJson());

class CategoryResponse {
  CategoryResponse({
    this.status,
    this.statuscode,
    this.statusDescription,
    this.totalRows,
    this.categories,
  });

  String? status;
  String? statuscode;
  String? statusDescription;
  String? totalRows;
  List<Category>? categories;

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      CategoryResponse(
        status: json["Status"],
        statuscode: json["Statuscode"],
        statusDescription: json["StatusDescription"],
        totalRows: json["TotalRows"],
        categories: List<Category>.from(
            json["Response"].map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Statuscode": statuscode,
        "StatusDescription": statusDescription,
        "TotalRows": totalRows,
        "Response": List<dynamic>.from(categories!.map((x) => x.toJson())),
      };
}

class Category {
  Category({this.id, this.name, this.image, this.podcastsCount});

  String? id;
  String? name;
  String? image;
  String? podcastsCount;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        podcastsCount: json["podcast_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "podcast_count": podcastsCount,
      };
}
