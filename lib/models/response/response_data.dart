// To parse this JSON data, do
//
//     final responseData = responseDataFromJson(jsonString);

import 'dart:convert';

ResponseData responseDataFromJson(String str) => ResponseData.fromJson(json.decode(str));

String responseDataToJson(ResponseData data) => json.encode(data.toJson());

class ResponseData {
  ResponseData({
    this.status,
    this.statuscode,
    this.statusDescription,
    this.response,
  });

  String? status;
  String? statuscode;
  String? statusDescription;
  dynamic response;

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
    status: json["Status"],
    statuscode: json["Statuscode"],
    statusDescription: json["StatusDescription"],
    response: json["Response"],
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "Statuscode": statuscode,
    "StatusDescription": statusDescription,
    "Response": response,
  };
}
