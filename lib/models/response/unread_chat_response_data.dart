// To parse this JSON data, do
//
//     final unreadChatResponseData = unreadChatResponseDataFromJson(jsonString);

import 'dart:convert';

UnreadChatResponseData unreadChatResponseDataFromJson(String str) => UnreadChatResponseData.fromJson(json.decode(str));

String unreadChatResponseDataToJson(UnreadChatResponseData data) => json.encode(data.toJson());

class UnreadChatResponseData {
  UnreadChatResponseData({
    this.status,
    this.statuscode,
    this.statusDescription,
    this.response,
  });

  String? status;
  String? statuscode;
  String? statusDescription;
  List<Response>? response;

  factory UnreadChatResponseData.fromJson(Map<String, dynamic> json) => UnreadChatResponseData(
    status: json["Status"],
    statuscode: json["Statuscode"],
    statusDescription: json["StatusDescription"],
    response: List<Response>.from(json["Response"].map((x) => Response.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "Statuscode": statuscode,
    "StatusDescription": statusDescription,
    "Response": List<dynamic>.from(response!.map((x) => x.toJson())),
  };
}

class Response {
  Response({
    this.unreadCount,
  });

  String? unreadCount;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    unreadCount: json["unread_count"],
  );

  Map<String, dynamic> toJson() => {
    "unread_count": unreadCount,
  };
}
