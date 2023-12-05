import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:litera_mobile/apps/authentication/pages/LoginPage.dart';
import 'package:litera_mobile/apps/review/models/Review.dart';
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
    print(list_review);
    return list_review;
}

  @override
Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(202,209,218, 1),
        body: SingleChildScrollView(
        child: Column(
          children: [
            MyHeader(),
            FutureBuilder(
              future: fetchProduct(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (!snapshot.hasData) {
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
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) => GestureDetector(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${snapshot.data![index].fields.reviewerName}",
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text("${snapshot.data![index].fields.reviewScore}"),
                              const SizedBox(height: 10),
                              Text("${snapshot.data![index].fields.reviewText}")
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
     );
    }
}

