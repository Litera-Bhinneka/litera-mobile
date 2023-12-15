// To parse this JSON data, do
//
//     final owner = ownerFromJson(jsonString);

import 'dart:convert';

List<Owner> ownerFromJson(String str) =>
    List<Owner>.from(json.decode(str).map((x) => Owner.fromJson(x)));

String ownerToJson(List<Owner> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Owner {
  String model;
  int pk;
  Fields fields;

  Owner({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
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
  String username;

  Fields({
    required this.username,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
      };
}
