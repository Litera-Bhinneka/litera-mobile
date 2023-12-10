import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:litera_mobile/apps/authentication/pages/LoginPage.dart';
import 'package:litera_mobile/apps/catalog/models/Book.dart';
import 'package:litera_mobile/apps/review/components/star_rating.dart';
import 'package:litera_mobile/apps/review/models/Review.dart';
import 'package:litera_mobile/apps/review/pages/add_review.dart';
import 'package:litera_mobile/components/head.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;


class ShowReview extends StatefulWidget {
  const ShowReview({Key? key, required this.book_id}) : super(key: key);

  final int book_id;

  @override
  State<ShowReview> createState() => _ShowReviewState(book_id: book_id);
}

class _ShowReviewState extends State<ShowReview> {
  final int book_id;

  _ShowReviewState({required this.book_id});

  Future<List<Review>> fetchProduct() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url = Uri.parse(
        'https://litera-b06-tk.pbp.cs.ui.ac.id/review/get-review-json/$book_id/');
    var response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Product
    List<Review> list_review = [];
    for (var d in data) {
        if (d != null) {
            list_review.add(Review.fromJson(d));
        }
    }
    return list_review;
  }

  Future<List<Book>> fetchBook() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url = Uri.parse(
        'https://litera-b06-tk.pbp.cs.ui.ac.id/review/get-book-json/$book_id/');
    var response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Product
    List<Book> list_book = [];
    for (var d in data) {
        if (d != null) {
            list_book.add(Book.fromJson(d));
        }
    }
    return list_book;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(202, 209, 218, 1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MyHeader(height: 86,),
            FutureBuilder(
              future: Future.wait([fetchProduct(), fetchBook()]),
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading data'));
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Column(
                    children: [
                      Text(
                        "Tidak ada data item.",
                        style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                      ),
                      SizedBox(height: 8),
                    ],
                  );
                } else {
                  List<Review> reviews = snapshot.data![0] as List<Review>;
                  List<Book> book = snapshot.data![1] as List<Book>;

                  // Display book details as the first item in the list
                  Widget bookDetails = Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Assuming book.cover is a URL to the cover image
                        Image.network(
                          Uri.encodeFull(book[0].fields.imageLink),
                          fit: BoxFit.contain, // Maintain aspect ratio without cropping
                        ),
                        const SizedBox(height: 16),
                        Text(
                          book[0].fields.title,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(book[0].fields.description),
                      ],
                    ),
                  );

                  Widget addReviewButton = TextButton(
                    onPressed: () {
                      showDialog<String>(
                        context: context,
                          builder: (BuildContext context) => ReviewDialog(book_id: book_id,book_title: book[0].fields.title),
                      );
                    },
                    child: const Text('Add Review'),
                  );

                  // Display review items for the remaining items in the list
                  List<Widget> reviewItems = List.generate(
                    reviews.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "${reviews[index].fields.reviewerName}",
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          StarRating(rating: reviews[index].fields.reviewScore.toDouble()),
                          const SizedBox(height: 10),
                          Text("${reviews[index].fields.reviewText}")
                        ],
                      ),
                    ),
                  );

                  // Combine book details and review items in the Column
                  return Column(
                    children: [
                      bookDetails,
                      addReviewButton, // Optional divider between book details and reviews
                      ...reviewItems,
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }



}