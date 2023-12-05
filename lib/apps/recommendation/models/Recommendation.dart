// To parse this JSON data, do
//
//     final recommendation = recommendationFromJson(jsonString);

import 'dart:convert';

List<Recommendation> recommendationFromJson(String str) => List<Recommendation>.from(json.decode(str).map((x) => Recommendation.fromJson(x)));

String recommendationToJson(List<Recommendation> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Recommendation {
    String model;
    int pk;
    Fields fields;

    Recommendation({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Recommendation.fromJson(Map<String, dynamic> json) => Recommendation(
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
    dynamic review;
    String bookTitle;
    String anotherBookTitle;
    int bookId;
    int anotherBookId;
    String bookImage;
    String anotherBookImage;
    String recommenderName;
    int recommendationScale;
    String description;
    DateTime recommendationDate;

    Fields({
        required this.review,
        required this.bookTitle,
        required this.anotherBookTitle,
        required this.bookId,
        required this.anotherBookId,
        required this.bookImage,
        required this.anotherBookImage,
        required this.recommenderName,
        required this.recommendationScale,
        required this.description,
        required this.recommendationDate,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        review: json["review"],
        bookTitle: json["book_title"],
        anotherBookTitle: json["another_book_title"],
        bookId: json["book_id"],
        anotherBookId: json["another_book_id"],
        bookImage: json["book_image"],
        anotherBookImage: json["another_book_image"],
        recommenderName: json["recommender_name"],
        recommendationScale: json["recommendation_scale"],
        description: json["description"],
        recommendationDate: DateTime.parse(json["recommendation_date"]),
    );

    Map<String, dynamic> toJson() => {
        "review": review,
        "book_title": bookTitle,
        "another_book_title": anotherBookTitle,
        "book_id": bookId,
        "another_book_id": anotherBookId,
        "book_image": bookImage,
        "another_book_image": anotherBookImage,
        "recommender_name": recommenderName,
        "recommendation_scale": recommendationScale,
        "description": description,
        "recommendation_date": recommendationDate.toIso8601String(),
    };
}
