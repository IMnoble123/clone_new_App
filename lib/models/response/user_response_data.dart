// To parse this JSON data, do
//
//     final userResponseData = userResponseDataFromJson(jsonString);

import 'dart:convert';

UserResponseData userResponseDataFromJson(String str) =>
    UserResponseData.fromJson(json.decode(str));

String userResponseDataToJson(UserResponseData data) =>
    json.encode(data.toJson());

class UserResponseData {
  UserResponseData({
    this.id,
    this.mobile,
    this.email,
    this.name,
    this.dob,
    this.gender,
    this.profileImage,
    this.source,
    this.prefLanguage,
    this.createdDate,
    this.modifiedDate,
    this.token
  });

  String? id;
  String? mobile;
  String? email;
  String? name;
  String? dob;
  String? gender;
  String? profileImage;
  String? source;
  String? prefLanguage;
  String? createdDate;
  String? modifiedDate;
  String? token;

  factory UserResponseData.fromJson(Map<String, dynamic> json) =>
      UserResponseData(
        id: json["id"],
        mobile: json["mobile"],
        email: json["email"],
        name: json["name"],
        dob: json["dob"],
        gender: json["gender"],
        profileImage: json["profile_image"],
        source: json["source"],
        prefLanguage: json["pref_language"],
        createdDate: json["created_date"],
        modifiedDate: json["modified_date"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "mobile": mobile,
        "email": email,
        "name": name,
        "dob": dob,
        "gender": gender,
        "profile_image": profileImage,
        "source": source,
        "pref_language": prefLanguage,
        "created_date": createdDate,
        "modified_date": modifiedDate,
        "token": token,
      };
}
