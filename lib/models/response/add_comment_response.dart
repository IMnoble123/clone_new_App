
import 'dart:convert';

AddCommentResponse podcastResponseFromJson(String str) =>
    AddCommentResponse.fromJson(json.decode(str));

String podcastResponseToJson(AddCommentResponse data) =>
    json.encode(data.toJson());

class AddCommentResponse {
  AddCommentResponse({
    this.status,
    this.statuscode,
    this.statusDescription,
    this.response,
  });

  String? status;
  String? statuscode;
  String? statusDescription;
  String? response;

  factory AddCommentResponse.fromJson(Map<String, dynamic> json) =>
      AddCommentResponse(
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