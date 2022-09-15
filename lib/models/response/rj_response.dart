// To parse this JSON data, do
//
//     final rjResponse = rjResponseFromJson(jsonString);

import 'dart:convert';

RjResponse rjResponseFromJson(String str) =>
    RjResponse.fromJson(json.decode(str));

String rjResponseToJson(RjResponse data) => json.encode(data.toJson());

class RjResponse {
  RjResponse({
    this.status,
    this.statuscode,
    this.statusDescription,
    this.totalRows,
    this.rjItems,
  });

  String? status;
  String? statuscode;
  String? statusDescription;
  String? totalRows;
  List<RjItem>? rjItems;

  factory RjResponse.fromJson(Map<String, dynamic> json) => RjResponse(
        status: json["Status"],
        statuscode: json["Statuscode"],
        statusDescription: json["StatusDescription"],
        totalRows: json["TotalRows"],
        rjItems:
            List<RjItem>.from(json["Response"].map((x) => RjItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Statuscode": statuscode,
        "StatusDescription": statusDescription,
        "TotalRows": totalRows,
        "Response": List<dynamic>.from(rjItems!.map((x) => x.toJson())),
      };
}

class RjItem {
  RjItem({
    this.rjUserId,
    this.rjName,
    this.rjDob,
    this.rjPhone,
    this.rjEmail,
    this.podcasterType,
    this.podcasterValue,
    this.state,
    this.country,
    this.profileImage,
    this.aboutme,
    this.facebook,
    this.twitter,
    this.snapchat,
    this.blogger,
    this.telegram,
    this.linkedin,
    this.podcastCount,
    this.rjRating,
    this.isRated,
    this.subscribed,
  });

  String? rjUserId;
  String? rjName;
  String? rjDob;
  String? rjPhone;
  String? rjEmail;
  String? podcasterType;
  String? podcasterValue;
  String? state;
  String? country;
  String? profileImage;
  String? aboutme;
  String? facebook;
  String? twitter;
  String? snapchat;
  String? blogger;
  String? telegram;
  String? linkedin;
  String? podcastCount;
  String? rjRating;
  String? isRated;
  String? subscribed;

  factory RjItem.fromJson(Map<String, dynamic> json) => RjItem(
        rjUserId: json["rj_user_id"],
        rjName: json["rj_name"],
        rjDob: json["rj_dob"],
        rjPhone: json["rj_phone"],
        rjEmail: json["rj_email"],
        podcasterType: json["podcaster_type"],
        podcasterValue: json["podcaster_value"],
        state: json["state"],
        country: json["country"],
        profileImage: json["profile_image"],
        aboutme: json["aboutme"],
        facebook: json["facebook"],
        twitter: json["twitter"],
        snapchat: json["snapchat"],
        blogger: json["blogger"],
        telegram: json["telegram"],
        linkedin: json["linkedin"],
        podcastCount: json["podcast_count"],
        rjRating: json["rj_rating"],
        isRated: json["is_rated"],
        subscribed: json["is_subscribed"],
      );

  Map<String, dynamic> toJson() => {
        "rj_user_id": rjUserId,
        "rj_name": rjName,
        "rj_dob": rjDob,
        "rj_phone": rjPhone,
        "rj_email": rjEmail,
        "podcaster_type": podcasterType,
        "podcaster_value": podcasterValue,
        "state": state,
        "country": country,
        "profile_image": profileImage,
        "aboutme": aboutme,
        "facebook": facebook,
        "twitter": twitter,
        "snapchat": snapchat,
        "blogger": blogger,
        "telegram": telegram,
        "linkedin": linkedin,
        "podcast_count": podcastCount,
        "rj_rating": rjRating,
        "is_rated": isRated,
        "is_subscribed": subscribed,
      };
}
