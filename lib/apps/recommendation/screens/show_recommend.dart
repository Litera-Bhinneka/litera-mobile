import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:litera_mobile/apps/authentication/models/User.dart';
import 'package:litera_mobile/apps/recommendation/models/Recommendation.dart';
import 'package:litera_mobile/apps/recommendation/screens/add_recommendation.dart';
import 'package:litera_mobile/apps/review/pages/show_review.dart';
import 'package:litera_mobile/components/head.dart';
import 'package:readmore/readmore.dart';
import 'package:http/http.dart' as http;


class ShowRecommendation extends StatefulWidget {
  const ShowRecommendation({Key? key});

  @override
  State<ShowRecommendation> createState() => _ShowRecommendationState();
}

class _ShowRecommendationState extends State<ShowRecommendation> {

  Future<List<Recommendation>> fetchRecommendation() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url = Uri.parse(
        'http://localhost:8000/recommendation/get-recommendation-json/');
    var response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    
    // melakukan konversi data json menjadi object Product
    List<Recommendation> list_recommendation = [];
    for (var d in data) {
        if (d != null) {
            list_recommendation.add(Recommendation.fromJson(d));
        }
    }
    return list_recommendation;
}

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Color.fromRGBO(202, 209, 218, 1),
    body: FutureBuilder(
      future: fetchRecommendation(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Column(
            children: [
              MyHeader(height: 86),
              Text(
                "Tidak ada data item.",
                style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
              ),
              SizedBox(height: 8),
            ],
          );
        } else {
          List<Recommendation> recommendations = snapshot.data as List<Recommendation>;
          return CustomScrollView(
          slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: MyHeaderDelegate(),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                Recommendation recommendation = recommendations[index];
                String date = DateFormat("dd MMMM yyyy 'at' h:mm a").format(recommendation.fields.recommendationDate);

                return Card(
                  color: Color(0xFFDDDDDD),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Image.network(
                                Uri.encodeFull(recommendation.fields.bookImage),
                                width: 100,
                                height: 100,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Image.network(
                                Uri.encodeFull(recommendation.fields.anotherBookImage),
                                width: 100,
                                height: 100,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  // Navigate to a new page when the first text is clicked
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ShowReview(book_id: recommendation.fields.bookId,), // Replace with the actual widget/page
                                    ),
                                  );
                                },
                                child: Text.rich(
                                  TextSpan(
                                    text: recommendation.fields.bookTitle,
                                    style: const TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  // Navigate to a new page when the second text is clicked
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ShowReview(book_id: recommendation.fields.anotherBookId,), // Replace with the actual widget/page
                                    ),
                                  );
                                },
                                child: Text.rich(
                                  TextSpan(
                                    text: recommendation.fields.anotherBookTitle,
                                    style: const TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ReadMoreText(
                          recommendation.fields.description,
                          trimLines: 3,
                          colorClickableText: Colors.red,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: 'Show more',
                          trimExpandedText: ' Show less',
                          style: const TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.normal,
                          )
                        ),
                        Divider(),
                        Text(
                          recommendation.fields.recommenderName + " - " + date,
                          style: const TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF718096)
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: recommendations.length,
            ),
          ),
          ],
          );
        }
      },
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyAdd()),
        );
      },
      child: const Icon(Icons.add),
      backgroundColor: Color.fromARGB(255, 64, 183, 181),
      shape: CircleBorder(),
    )
  );
}
}

class MyHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return MyHeader(height: 86,);
  }

  @override
  double get maxExtent => 86; // Adjust this height according to your header height

  @override
  double get minExtent => 86; // Adjust this height according to your header height

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}