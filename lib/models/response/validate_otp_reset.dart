// To parse this JSON data, do
//
//     final validateOtpReset = validateOtpResetFromJson(jsonString);

import 'dart:convert';

ValidateOtpReset validateOtpResetFromJson(String str) => ValidateOtpReset.fromJson(json.decode(str));

String validateOtpResetToJson(ValidateOtpReset data) => json.encode(data.toJson());

class ValidateOtpReset {
  ValidateOtpReset({
    this.status,
    this.statuscode,
    this.statusDescription,
    this.response,
  });

  String? status;
  String? statuscode;
  String? statusDescription;
  Response? response;

  factory ValidateOtpReset.fromJson(Map<String, dynamic> json) => ValidateOtpReset(
    status: json["Status"],
    statuscode: json["Statuscode"],
    statusDescription: json["StatusDescription"],
    response: Response.fromJson(json["Response"]),
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "Statuscode": statuscode,
    "StatusDescription": statusDescription,
    "Response": response!.toJson(),
  };
}

class Response {
  Response({
    this.isvalid,
    this.token,
  });

  bool? isvalid;
  String? token;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    isvalid: json["isvalid"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "isvalid": isvalid,
    "token": token,
  };
}
