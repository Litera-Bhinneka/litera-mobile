import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:litera_mobile/apps/authentication/pages/LoginPage.dart';
import 'package:litera_mobile/apps/catalog/models/Book.dart';
import 'package:litera_mobile/apps/review/components/star_rating.dart';
import 'package:litera_mobile/apps/review/models/Review.dart';
import 'package:litera_mobile/apps/review/pages/add_review.dart';
import 'package:litera_mobile/components/head.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:readmore/readmore.dart';


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
        'http://localhost:8000/review/get-review-json/$book_id/');
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
        'http://localhost:8000/review/get-book-json/$book_id/');
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

                  // Calculate total and average rating
                  double totalRating = 0.0;
                  double averageRating = 0.0;

                  for (int index = 0; index < reviews.length; index++) {
                    totalRating += reviews[index].fields.reviewScore.toDouble();
                  }

                  if (reviews.length > 0) {
                    averageRating = totalRating / reviews.length;
                  }

                  // Display book details as the first item in the list
                  Widget bookDetails = Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
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
                        ReadMoreText(
                          "${book[0].fields.description}",
                          trimLines: 3,
                          colorClickableText: Color.fromARGB(255, 63, 101, 240),
                          trimMode: TrimMode.Line,
                          trimCollapsedText: 'Read more',
                          trimExpandedText: '\nRead less',
                          lessStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color:Color.fromARGB(255, 63, 101, 240)),
                          moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color:Color.fromARGB(255, 63, 101, 240)),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            StarRating(rating: averageRating.toDouble()),
                            Text(" (${reviews.length} ratings)", style: TextStyle(fontSize: 16),)
                          ],
                        )
                      ],
                    ),
                  )
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
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFFDDDDDD),
                      ),
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
                          const SizedBox(height: 8),
                          Text(
                            "${reviews[index].fields.reviewSummary}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ReadMoreText(
                            "${reviews[index].fields.reviewText}",
                            trimLines: 3,
                            colorClickableText: Color.fromARGB(255, 63, 101, 240),
                            trimMode: TrimMode.Line,
                            trimCollapsedText: 'Read more',
                            trimExpandedText: '\nRead less',
                            lessStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color:Color.fromARGB(255, 63, 101, 240)),
                            moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color:Color.fromARGB(255, 63, 101, 240)),
                          ),
                          const SizedBox(height: 15),
                          // 'dd MMMM yyyy "at" h:mm a'
                          Text("${DateFormat('dd MMMM yyyy').format(reviews[index].fields.reviewDate)} at ${DateFormat('h:mm a').format(reviews[index].fields.reviewDate)}")
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