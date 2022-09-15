// To parse this JSON data, do
//
//     final reportResponse = reportResponseFromJson(jsonString);

import 'dart:convert';

ReportItemsResponse reportResponseFromJson(String str) => ReportItemsResponse.fromJson(json.decode(str));

String reportResponseToJson(ReportItemsResponse data) => json.encode(data.toJson());

class ReportItemsResponse {
  ReportItemsResponse({
    this.status,
    this.statuscode,
    this.statusDescription,
    this.reportItems,
  });

  String? status;
  String? statuscode;
  String? statusDescription;
  List<ReportItem>? reportItems;

  factory ReportItemsResponse.fromJson(Map<String, dynamic> json) => ReportItemsResponse(
    status: json["Status"],
    statuscode: json["Statuscode"],
    statusDescription: json["StatusDescription"],
    reportItems: List<ReportItem>.from(json["Response"].map((x) => ReportItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "Statuscode": statuscode,
    "StatusDescription": statusDescription,
    "Response": List<dynamic>.from(reportItems!.map((x) => x.toJson())),
  };
}

class ReportItem {
  ReportItem({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory ReportItem.fromJson(Map<String, dynamic> json) => ReportItem(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
