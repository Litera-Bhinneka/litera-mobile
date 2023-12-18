import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:litera_mobile/apps/authentication/models/User.dart';
import 'package:litera_mobile/apps/recommendation/screens/show_recommend.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class RecommendationDialog extends StatefulWidget {
  const RecommendationDialog({Key? key}) : super(key: key);
  @override
  _RecommendationDialogState createState() => _RecommendationDialogState();
}
double? initialDialogWidth = null;
class _RecommendationDialogState extends State<RecommendationDialog> {
  final _formKey = GlobalKey<FormState>();
  String _book_title = "";
  String _another_book_title = "";

  String _description = "";

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    
    if (initialDialogWidth == null) {
      // Calculate the initial width only for the first time
      initialDialogWidth = MediaQuery.of(context).size.width * 0.8;
    }
    return AlertDialog(
      title: const Text('Write your recommendation'),
      content: Container(
        width: initialDialogWidth,
        child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Choose your book that you would like to make a recommendation for",
              style: TextStyle(
                fontSize: 13.0,
                fontFamily: 'Poppins',
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Book title 1',
                labelText: 'book title',
              ),
              onChanged: (value) {
                setState(() {
                  _book_title = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Book title cannot be empty';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Text(
              "Choose a book similar to your book",
              style: TextStyle(
                fontSize: 13.0,
                fontFamily: 'Poppins',
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Book title 2',
                labelText: 'book title',
              ),
              onChanged: (value) {
                setState(() {
                  _another_book_title = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Book title cannot be empty';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Text(
              "Description",
              style: TextStyle(
                fontSize: 13.0,
                fontFamily: 'Poppins',
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'description',
                labelText: 'description',
              ),
              onChanged: (value) {
                setState(() {
                  _description = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Description cannot be empty';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                SizedBox(width: initialDialogWidth! / 4.5),
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
                          if (_formKey.currentState!.validate()) {
                              final http.Response response = await http.post(
                                  Uri.parse("http://localhost:8000/recommendation/create-flutter/"),
                                  headers: <String, String>{
                                    'Content-Type': 'application/json',
                                  },
                                  body: jsonEncode(<String, String>{
                                    'recommender_name': UserLoggedIn.user.username,
                                    'book_title': _book_title,
                                    'another_book_title': _another_book_title,
                                    'description': _description,
                                  }),
                                );
                              if (response.statusCode == 200) {
                              // Successful response
                              final Map<String, dynamic> responseBody = jsonDecode(response.body);

                              if (responseBody['status'] == 'success') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Recommendation berhasil disimpan!"),
                                  ),
                                );
                                 
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => ShowRecommendation()),
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
                      child: const Text(
                        "Post",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.red),
                      ),
                      onPressed: () async {
                        
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
          ],
        ),
      ),
      )
    );
  }
}