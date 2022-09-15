// To parse this JSON data, do
//
//     final notificationResponseData = notificationResponseDataFromJson(jsonString);

import 'dart:convert';

NotificationResponseData notificationResponseDataFromJson(String str) => NotificationResponseData.fromJson(json.decode(str));

String notificationResponseDataToJson(NotificationResponseData data) => json.encode(data.toJson());

class NotificationResponseData {
  NotificationResponseData({
    this.status,
    this.statuscode,
    this.statusDescription,
    this.response,
  });

  String? status;
  String? statuscode;
  String? statusDescription;
  NotificationsList? response;

  factory NotificationResponseData.fromJson(Map<String, dynamic> json) => NotificationResponseData(
    status: json["Status"],
    statuscode: json["Statuscode"],
    statusDescription: json["StatusDescription"],
    response: NotificationsList.fromJson(json["Response"]),
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "Statuscode": statuscode,
    "StatusDescription": statusDescription,
    "Response": response!.toJson(),
  };
}

class NotificationsList {
  NotificationsList({
    this.notificationCount,
    this.notificationList,
  });

  int? notificationCount;
  List<NotificationItem>? notificationList;

  factory NotificationsList.fromJson(Map<String, dynamic> json) => NotificationsList(
    notificationCount: json["notification_count"],
    notificationList: List<NotificationItem>.from(json["notification_list"].map((x) => NotificationItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "notification_count": notificationCount,
    "notification_list": List<dynamic>.from(notificationList!.map((x) => x.toJson())),
  };
}

class NotificationItem {
  NotificationItem({
    this.podcastId,
    this.message,
    this.viewed,
    this.createdDate,
  });

  String? podcastId;
  String? message;
  String? viewed;
  String? createdDate;

  factory NotificationItem.fromJson(Map<String, dynamic> json) => NotificationItem(
    podcastId: json["podcast_id"],
    message: json["message"],
    viewed: json["viewed"],
    createdDate: json["created_date"],
  );

  Map<String, dynamic> toJson() => {
    "podcast_id": podcastId,
    "message": message,
    "viewed": viewed,
    "created_date": createdDate,
  };
}
