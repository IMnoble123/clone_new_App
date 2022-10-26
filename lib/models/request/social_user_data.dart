// To parse this JSON data, do
//
//     final socialUserData = socialUserDataFromJson(jsonString);

import 'dart:convert';

// SocialUserData socialUserDataFromJson(String str) => SocialUserData.fromJson(json.decode(str));

// String socialUserDataToJson(SocialUserData data) => json.encode(data.toJson());

class SocialUserData {
  SocialUserData({
    this.name,
    this.mobile,
    this.email,
    this.password,
    this.dob,
    this.profileImage,
    this.gender,
    this.source,
    this.gmailId,
    this.facebookId,
    this.appleId,
  });

  String? name;
  String? mobile;
  String? email;
  String? password;
  String? dob;
  String? profileImage;
  String? gender;
  String? source;
  String? gmailId;
  String? facebookId;
  String? appleId;

  factory SocialUserData.fromJson(Map<String, dynamic> json) => SocialUserData(
    name: json["name"],
    mobile: json["mobile"],
    email: json["email"],
    password: json["password"],
    dob: json["dob"],
    profileImage: json["profile_image"],
    gender: json["gender"],
    source: json["source"],
    gmailId: json["gmail_id"],
    facebookId: json["facebook_id"],
    appleId: json["apple_id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "mobile": mobile,
    "email": email,
    "password": password,
    "dob": dob,
    "profile_image": profileImage,
    "gender": gender,
    "source": source,
    "gmail_id": gmailId,
    "facebook_id": facebookId,
    "apple_id": appleId
  };
}
