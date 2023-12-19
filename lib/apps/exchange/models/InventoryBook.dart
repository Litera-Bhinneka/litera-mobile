// To parse this JSON data, do
//
//     final inventoryBook = inventoryBookFromJson(jsonString);

import 'dart:convert';

List<InventoryBook> inventoryBookFromJson(String str) =>
    List<InventoryBook>.from(
        json.decode(str).map((x) => InventoryBook.fromJson(x)));

String inventoryBookToJson(List<InventoryBook> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InventoryBook {
  int id;
  String title;
  String image;
  int amount;

  InventoryBook({
    required this.id,
    required this.title,
    required this.image,
    required this.amount,
  });

  factory InventoryBook.fromJson(Map<String, dynamic> json) => InventoryBook(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "amount": amount,
      };
}
