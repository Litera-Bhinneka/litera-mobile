// To parse this JSON data, do
//
//     final review = reviewFromJson(jsonString);

import 'dart:convert';

List<Review> reviewFromJson(String str) => List<Review>.from(json.decode(str).map((x) => Review.fromJson(x)));

String reviewToJson(List<Review> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Review {
    String model;
    int pk;
    Fields fields;

    Review({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Review.fromJson(Map<String, dynamic> json) => Review(
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
    String bookTitle;
    String reviewerName;
    int reviewScore;
    String reviewSummary;
    String reviewText;
    DateTime reviewDate;

    Fields({
        required this.bookTitle,
        required this.reviewerName,
        required this.reviewScore,
        required this.reviewSummary,
        required this.reviewText,
        required this.reviewDate,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        bookTitle: json["book_title"],
        reviewerName: json["reviewer_name"],
        reviewScore: json["review_score"],
        reviewSummary: json["review_summary"],
        reviewText: json["review_text"],
        reviewDate: DateTime.parse(json["review_date"]),
    );

    Map<String, dynamic> toJson() => {
        "book_title": bookTitle,
        "reviewer_name": reviewerName,
        "review_score": reviewScore,
        "review_summary": reviewSummary,
        "review_text": reviewText,
        "review_date": reviewDate.toIso8601String(),
    };
}
