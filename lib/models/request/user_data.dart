// To parse this JSON data, do
//
//     final userData = userDataFromJson(jsonString);

import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  UserData({
    this.name,
    this.mobile,
    this.email,
    this.password,
    this.dob,
    this.profileImage,
    this.gender,
  });

  String? name;
  String? mobile;
  String? email;
  String? password;
  String? dob;
  String? profileImage;
  String? gender;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        name: json["name"],
        mobile: json["mobile"],
        email: json["email"],
        password: json["password"],
        dob: json["dob"],
        profileImage: json["profile_image"],
        gender: json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "mobile": mobile,
        "email": email,
        "password": password,
        "dob": dob,
        "profile_image": profileImage,
        "gender": gender,
      };
}
