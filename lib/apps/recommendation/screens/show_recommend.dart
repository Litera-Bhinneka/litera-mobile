import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:litera_mobile/apps/recommendation/models/Recommendation.dart';
import 'package:litera_mobile/components/head.dart';
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
        backgroundColor: Color.fromRGBO(202,209,218, 1),
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
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Image.network(
                              Uri.encodeFull(recommendation.fields.bookImage),
                              width: 100,
                              height: 100,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              recommendation.fields.bookTitle,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(recommendation.fields.description),
                          ],
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

