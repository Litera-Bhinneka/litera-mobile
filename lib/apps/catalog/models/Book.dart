// To parse this JSON data, do
//
//     final book = bookFromJson(jsonString);

import 'dart:convert';

List<Book> bookFromJson(String str) => List<Book>.from(json.decode(str).map((x) => Book.fromJson(x)));

String bookToJson(List<Book> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Book {
    String model;
    int pk;
    Fields fields;

    Book({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Book.fromJson(Map<String, dynamic> json) => Book(
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
    String title;
    int rating;
    String author;
    String category;
    String imageLink;
    String publisher;
    String description;
    int yearOfPublished;

    Fields({
        required this.title,
        required this.rating,
        required this.author,
        required this.category,
        required this.imageLink,
        required this.publisher,
        required this.description,
        required this.yearOfPublished,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        title: json["title"],
        rating: json["rating"],
        author: json["author"],
        category: json["category"],
        imageLink: json["image_link"],
        publisher: json["publisher"],
        description: json["description"],
        yearOfPublished: json["year_of_published"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "rating": rating,
        "author": author,
        "category": category,
        "image_link": imageLink,
        "publisher": publisher,
        "description": description,
        "year_of_published": yearOfPublished,
    };
}
