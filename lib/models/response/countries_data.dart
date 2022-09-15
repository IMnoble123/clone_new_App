// To parse this JSON data, do
//
//     final countriesData = countriesDataFromJson(jsonString);

import 'dart:convert';

CountriesData countriesDataFromJson(String str) => CountriesData.fromJson(json.decode(str));

String countriesDataToJson(CountriesData data) => json.encode(data.toJson());

class CountriesData {
  CountriesData({
    this.status,
    this.statuscode,
    this.statusDescription,
    this.countries,
  });

  String? status;
  String? statuscode;
  String? statusDescription;
  List<Country>? countries;

  factory CountriesData.fromJson(Map<String, dynamic> json) => CountriesData(
    status: json["Status"],
    statuscode: json["Statuscode"],
    statusDescription: json["StatusDescription"],
    countries: List<Country>.from(json["Response"].map((x) => Country.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "Statuscode": statuscode,
    "StatusDescription": statusDescription,
    "Response": List<dynamic>.from(countries!.map((x) => x.toJson())),
  };
}

class Country {
  Country({
    this.id,
    this.name,
    this.dialcode,
    this.isocode2,
    this.isocode3,
    this.flagpath,
  });

  String? id;
  String? name;
  String? dialcode;
  String? isocode2;
  String? isocode3;
  String? flagpath;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    id: json["id"],
    name: json["name"],
    dialcode: json["dialcode"],
    isocode2: json["isocode2"],
    isocode3: json["isocode3"],
    flagpath: json["flagpath"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "dialcode": dialcode,
    "isocode2": isocode2,
    "isocode3": isocode3,
    "flagpath": flagpath,
  };
}
