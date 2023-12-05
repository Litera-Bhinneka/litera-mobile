import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:litera_mobile/apps/review/components/star_rating.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ReviewDialog extends StatefulWidget {
  const ReviewDialog({Key? key, required this.book_id, required this.book_title}) : super(key: key);

  final int book_id;
  final String book_title;

  @override
  _ReviewDialogState createState() => _ReviewDialogState(book_id: book_id, book_title: book_title);
}

class _ReviewDialogState extends State<ReviewDialog> {
  final int book_id;
  final String book_title;

  _ReviewDialogState({required this.book_id, required this.book_title});

  final _reviewFormKey = GlobalKey<FormState>();
  String _reviewerName = "";
  int _reviewScore = 0;
  String _reviewSummary = "";
  String _reviewText = "";

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return AlertDialog(
      title: const Text('Add Review'),
      content: Form(
        key: _reviewFormKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Review Summary',
                labelText: 'Review Summary',
              ),
              onChanged: (value) {
                setState(() {
                  _reviewSummary = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Review Summary cannot be empty';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Review Text',
                labelText: 'Review Text',
              ),
              onChanged: (value) {
                setState(() {
                  _reviewText = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Review Text cannot be empty';
                }
                return null;
              },
            ),
            Row(
              children: [
                Text('Review Score: '),
                // Use your StarRatingInput widget here
                StarRatingInput(
                  rating: _reviewScore.toDouble(),
                  onRatingChanged: (newRating) {
                    setState(() {
                      _reviewScore = newRating.toInt();
                    });
                  },
                ),
              ],
            ),
            Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.indigo),
                      ),
                      onPressed: () async {
                          if (_reviewFormKey.currentState!.validate()) {
                              // Kirim ke Django dan tunggu respons
                              // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                              // final response = await request.postJson(
                              // "http://localhost:8000/create-flutter/",
                              // jsonEncode(<String, String>{
                              //     'name': _name,
                              //     'price': _price.toString(),
                              //     'amount': _amount.toString(),
                              //     'category': _category,
                              //     'description': _description,
                              //     // TODO: Sesuaikan field data sesuai dengan aplikasimu
                              // }));
                              Cookie? usernameCookie = request.cookies['username'];

                              String? username;

                              if (usernameCookie != null) {
                                // Use the value property of the Cookie object to get the username
                                username = usernameCookie.value;
                                print('Logged-in username: $username');
                              } else {
                                print('Username cookie not available.');
                              }

                              final http.Response response = await http.post(
                                  Uri.parse("https://litera-b06-tk.pbp.cs.ui.ac.id/review/add-review-ajax/$book_id/"),
                                  headers: <String, String>{
                                    'Content-Type': 'application/json',
                                  },
                                  // book_title = models.CharField(max_length=255)
                                  // reviewer_name = models.CharField(max_length=255)
                                  // review_score = models.IntegerField()
                                  // review_summary = models.CharField(max_length=255)
                                  // review_text = models.TextField() 
                                  // review_date = models.DateTimeField(auto_now_add=True)
                                  body: jsonEncode(<String, String>{
                                    'book_title': book_title,
                                    'reviewer_name': username!,
                                    'review_score': _reviewScore.toString(),
                                    'review_summary': _reviewSummary,
                                    'review_text': _reviewText,
                                  }),
                                );
                              if (response.statusCode == 200) {
                              // Successful response
                              final Map<String, dynamic> responseBody = jsonDecode(response.body);

                              if (responseBody['status'] == 'success') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Produk baru berhasil disimpan!"),
                                  ),
                                );
                                 Navigator.pop(context, 'Post');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Terdapat kesalahan, silakan coba lagi."),
                                  ),
                                );
                              }
                            }
                          }
                      },
                      child: const Text(
                        "Post",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:litera_mobile/apps/review/components/star_rating.dart';
// import 'package:litera_mobile/apps/review/components/star_rating.dart'; // Assuming you have a StarRating widget

// class AddReviewScreen extends StatefulWidget {
//   @override
//   _AddReviewScreenState createState() => _AddReviewScreenState();
// }

// class _AddReviewScreenState extends State<AddReviewScreen> {
//   double _rating = 0.0;
//   TextEditingController _summaryController = TextEditingController();
//   TextEditingController _reviewController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Add Review"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               "Summary",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             TextField(
//               controller: _summaryController,
//               decoration: InputDecoration(
//                 hintText: "Enter a summary",
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               "Review",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             TextField(
//               controller: _reviewController,
//               maxLines: 5,
//               decoration: InputDecoration(
//                 hintText: "Write your review",
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               "Rating",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             StarRatingInput(
//               rating: _rating,
//               onRatingChanged: (rating) {
//                 setState(() {
//                   _rating = rating;
//                 });
//               },
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 // Handle the review submission logic
//                 // For example, you can save the review to your database
//                 // and navigate back to the previous screen
//                 Navigator.pop(context);
//               },
//               child: Text("Post"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
