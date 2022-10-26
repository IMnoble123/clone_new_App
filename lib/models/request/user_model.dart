class UsersDetails {
  String? displayname;
  String? email;
  String? photoURL;
  UsersDetails({this.displayname, this.email, this.photoURL});

  UsersDetails.fromJson(Map<String, dynamic> json) {
    displayname = json["displayname"];
    photoURL = json["photoURL"];
    email = json["email"];
  }

  Map<String, dynamic> toJson() {
    final Map< String, dynamic> data = < String, dynamic>{};
    data["displayname"] = displayname;
    data["email"] = email;
    data["photoURL"] = photoURL;

    return data;
  }
}
