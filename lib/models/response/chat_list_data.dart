// To parse this JSON data, do
//
//     final chatListData = chatListDataFromJson(jsonString);

import 'dart:convert';

ChatListData chatListDataFromJson(String str) => ChatListData.fromJson(json.decode(str));

String chatListDataToJson(ChatListData data) => json.encode(data.toJson());

class ChatListData {
  ChatListData({
    this.status,
    this.statuscode,
    this.statusDescription,
    this.chatList,
  });

  String? status;
  String? statuscode;
  String? statusDescription;
  List<ChatItem>? chatList;

  factory ChatListData.fromJson(Map<String, dynamic> json) => ChatListData(
    status: json["Status"],
    statuscode: json["Statuscode"],
    statusDescription: json["StatusDescription"],
    chatList: List<ChatItem>.from(json["Response"].map((x) => ChatItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "Statuscode": statuscode,
    "StatusDescription": statusDescription,
    "Response": List<dynamic>.from(chatList!.map((x) => x.toJson())),
  };
}

class ChatItem {
  ChatItem({
    this.senderId,
    this.senderType,
    this.rjName,
    this.profileImage,
    this.message,
    this.createdDate,
    this.isPlaying,
  });

  String? senderId;
  String? senderType;
  String? rjName;
  String? profileImage;
  String? message;
  String? createdDate;
  bool? isPlaying;

  factory ChatItem.fromJson(Map<String, dynamic> json) => ChatItem(
    senderId: json["sender_id"],
    senderType: json["sender_type"],
    rjName: json["rj_name"],
    profileImage: json["profile_image"],
    message: json["message"],
    createdDate: json["created_date"],
    isPlaying: json["isPlaying"],
  );

  Map<String, dynamic> toJson() => {
    "sender_id": senderId,
    "sender_type": senderType,
    "rj_name": rjName ,
    "profile_image": profileImage,
    "message": message,
    "created_date": createdDate,
    "isPlaying": isPlaying,
  };
}



