import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:litera_mobile/apps/authentication/models/User.dart';
import 'package:litera_mobile/apps/review/components/star_rating.dart';
import 'package:litera_mobile/apps/review/pages/show_review.dart';
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
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.all(16.0),
      content: Container(
      width: 380, 
      height: 450,
      child: Column(
      children: [ 
        const Padding(
              padding: const EdgeInsets.only(left: 9.0, right: 18.0, top: 15.0, bottom: 1.0),
              child: Center(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Share your thoughts about this book!',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      // fontFamily: 'Poppins',
                      color: Color.fromARGB(255, 31, 31, 31),
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
        Form(
        key: _reviewFormKey,
        child: Column(
          children: [
            const Padding(
              padding: const EdgeInsets.only(left: 9.0, right: 18.0, top: 15.0, bottom: 1.0),
              child: Center(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Review Summary',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      // fontFamily: 'Poppins',
                      color: Color.fromARGB(255, 31, 31, 31),
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 9.0, vertical: 5.0),
              
            child: TextFormField(
                style: const TextStyle(
                                // fontFamily: 'Poppins',
                                fontSize: 15,
                                color: Color.fromARGB(255, 31, 31, 31)
                                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xE1F3F2F2), 
                  hintText: 'My new FAVORITE COOKBOOK!',
                  hintStyle: TextStyle(
                                // fontFamily: 'Poppins',
                                fontSize: 15,
                                color: Color.fromARGB(255, 31, 31, 31),
                                fontWeight: FontWeight.normal,
                                ),
                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Color.fromARGB(221, 80, 80, 80), width: 0.3),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Color.fromARGB(221, 80, 80, 80), width: 0.3),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
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
            ),
            const Padding(
              padding: const EdgeInsets.only(left: 9.0, right: 18.0, top: 15.0, bottom: 1.0),
              child: Center(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Your Review',  
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      // fontFamily: 'Poppins',
                      color: Color.fromARGB(255, 31, 31, 31),
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 9.0, vertical: 5.0),
                
              child: TextFormField(
                  style: const TextStyle(
                                  // fontFamily: 'Poppins',
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 31, 31, 31)
                                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xE1F3F2F2), 
                    hintText: 'I recently bought this book and I love it so much!',
                    hintStyle: TextStyle(
                                  // fontFamily: 'Poppins',
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 31, 31, 31),
                                  fontWeight: FontWeight.normal,
                                  ),
                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0)),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Color.fromARGB(221, 80, 80, 80), width: 0.3),
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Color.fromARGB(221, 80, 80, 80), width: 0.3),
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
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
              )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 5.0),
              child: Center(
                child: StarRatingInput(
                  rating: _reviewScore.toDouble(),
                  onRatingChanged: (newRating) {
                    setState(() {
                      _reviewScore = newRating.toInt();
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 100),
            Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xFF0F5756)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0), // Adjust the radius as needed
                          ),
                        ),
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

                              final http.Response response = await http.post(
                                  Uri.parse("http://localhost:8000/review/add-review-flutter/"),
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
                                    'reviewer_name': UserLoggedIn.user.username,
                                    'review_score': _reviewScore.toString(),
                                    'review_summary': _reviewSummary,
                                    'review_text': _reviewText,
                                  }),
                                );
                              print(jsonEncode(<String, String>{
                                    'book_title': book_title,
                                    'reviewer_name': UserLoggedIn.user.username,
                                    'review_score': _reviewScore.toString(),
                                    'review_summary': _reviewSummary,
                                    'review_text': _reviewText,
                                  }));
                              if (response.statusCode == 200) {
                              // Successful response
                              final Map<String, dynamic> responseBody = jsonDecode(response.body);

                              if (responseBody['status'] == 'success') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Produk baru berhasil disimpan!"),
                                  ),
                                );
                                 
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => ShowReview(book_id: book_id,)),
                                );
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
                      child: Container(
                        width: double.infinity, // Make the button span from left to right
                        child: const Text(
                          "Post",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),]
    )
    ));
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
