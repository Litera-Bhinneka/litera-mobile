import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:litera_mobile/components/head.dart';
import 'package:http/http.dart' as http;


class ShowRecommendation extends StatefulWidget {
  const ShowRecommendation({Key? key});

  @override
  State<ShowRecommendation> createState() => _ShowRecommendationState();
}

class _ShowRecommendationState extends State<ShowRecommendation> {

//   Future<List<Review>> fetchProduct() async {
//     // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
//     var url = Uri.parse(
//         'https://litera-b06-tk.pbp.cs.ui.ac.id/review/get-review-json/$book_id/');
//     var response = await http.get(
//         url,
//         headers: {"Content-Type": "application/json"},
//     );

//     // melakukan decode response menjadi bentuk json
//     var data = jsonDecode(utf8.decode(response.bodyBytes));

//     // melakukan konversi data json menjadi object Product
//     List<Review> list_review = [];
//     for (var d in data) {
//         if (d != null) {
//             list_review.add(Review.fromJson(d));
//         }
//     }
//     print(list_review);
//     return list_review;
// }

  @override
Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Color.fromRGBO(202,209,218, 1),
        body: Column(
          children: [
            MyHeader(),
          ],
        ),
      );
    }
}

