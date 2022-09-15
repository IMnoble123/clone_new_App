// To parse this JSON data, do
//
//     final item = itemFromJson(jsonString);

import 'dart:convert';

Item itemFromJson(String str) => Item.fromJson(json.decode(str));

String itemToJson(Item data) => json.encode(data.toJson());

class Item {
  Item({
    this.id,
    this.imgUrl,
    this.title,
    this.subtitle,
  });

  int? id;
  String? imgUrl;
  String? title;
  String? subtitle;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    imgUrl: json["imgUrl"],
    title: json["title"],
    subtitle: json["subtitle"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "imgUrl": imgUrl,
    "title": title,
    "subtitle": subtitle,
  };
}
