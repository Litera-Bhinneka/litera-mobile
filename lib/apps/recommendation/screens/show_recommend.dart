import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:litera_mobile/apps/authentication/models/User.dart';
import 'package:litera_mobile/apps/recommendation/models/Recommendation.dart';
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
        'https://litera-b06-tk.pbp.cs.ui.ac.id/recommendation/get-recommendation-json/');
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
              MyHeader(),
              Text(
                "Tidak ada data item.",
                style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
              ),
              SizedBox(height: 8),
            ],
          );
        } else {
          List<Recommendation> recommendations = snapshot.data as List<Recommendation>;
          return ListView(
            children: [
              MyHeader(),
              Column(
                children: recommendations.map((recommendation) {
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
                                child: Text(
                                  recommendation.fields.bookTitle,
                                  style: const TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  recommendation.fields.anotherBookTitle,
                                  style: const TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
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
                }).toList(),
              ),
            ],
          );
        }
      },
    ),
  );
}
}