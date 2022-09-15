// To parse this JSON data, do
//
//     final rjCategoriesData = rjCategoriesDataFromJson(jsonString);

import 'dart:convert';

RjCategoriesData rjCategoriesDataFromJson(String str) => RjCategoriesData.fromJson(json.decode(str));

String rjCategoriesDataToJson(RjCategoriesData data) => json.encode(data.toJson());

class RjCategoriesData {
  RjCategoriesData({
    this.status,
    this.statuscode,
    this.statusDescription,
    this.rjCategories,
  });

  String? status;
  String? statuscode;
  String? statusDescription;
  List<RjCategory>? rjCategories;

  factory RjCategoriesData.fromJson(Map<String, dynamic> json) => RjCategoriesData(
    status: json["Status"],
    statuscode: json["Statuscode"],
    statusDescription: json["StatusDescription"],
    rjCategories: List<RjCategory>.from(json["Response"].map((x) => RjCategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "Statuscode": statuscode,
    "StatusDescription": statusDescription,
    "rjCategories": List<dynamic>.from(rjCategories!.map((x) => x.toJson())),
  };
}

class RjCategory {
  RjCategory({
    this.category,
    this.podcastCount,
  });

  String? category;
  String? podcastCount;

  factory RjCategory.fromJson(Map<String, dynamic> json) => RjCategory(
    category: json["category"],
    podcastCount: json["podcast_count"],
  );

  Map<String, dynamic> toJson() => {
    "category": category,
    "podcast_count": podcastCount,
  };
}
