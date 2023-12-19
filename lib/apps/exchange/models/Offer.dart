// To parse this JSON data, do
//
//     final offer = offerFromJson(jsonString);

import 'dart:convert';

List<Offer> offerFromJson(String str) =>
    List<Offer>.from(json.decode(str).map((x) => Offer.fromJson(x)));

String offerToJson(List<Offer> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Offer {
  String model;
  int pk;
  Fields fields;

  Offer({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  String username1;
  String username2;

  Fields({
    required this.username1,
    required this.username2,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        username1: json["Username1"],
        username2: json["Username2"],
      );

  Map<String, dynamic> toJson() => {
        "Username1": username1,
        "Username2": username2,
      };
}
