import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:litera_mobile/apps/authentication/models/User.dart';
import 'package:litera_mobile/apps/recommendation/screens/show_recommend.dart';
import 'package:litera_mobile/main.dart';
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

  late List<String> userItems;
  String username = UserLoggedIn.user.username;
  Future<List<String>> fetchUserItem() async {
    var url = Uri.parse(
        'https://litera-b06-tk.pbp.cs.ui.ac.id/recommendation/get-user-inventory-flutter/$username/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<String> items = List<String>.from(data['book_titles'].map((dynamic item) {
      if (item != null) {
        return item.toString();
      }
      return '';
    }));
    return items;
  }
  late List<DropdownMenuItem<String>> dropdownItems;
  @override
  void initState() {
    super.initState();
    userItems = [];
    dropdownItems = [];
    fetchUserItem().then((List<String> result) {
      setState(() {
        userItems = result;
        dropdownItems = userItems.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList();
      });
    });
  }
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
            DropdownButtonFormField<String>(
              items: dropdownItems.length < 2 ? null : dropdownItems,
              onChanged: dropdownItems.length < 2 ? null: (String? value) {
                setState(() {
                  _book_title = value!;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Book title cannot be empty';
                }else if (value == _another_book_title) {
                  return 'You cannot recommend the same book';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: dropdownItems.length < 2 ? 'You must atleast have 2 books' : 'Select Book Title',
              ),
              isExpanded: true,
            ),
            const SizedBox(height: 20),
            Text(
              "Choose a book similar to your book",
              style: TextStyle(
                fontSize: 13.0,
                fontFamily: 'Poppins',
              ),
            ),
            DropdownButtonFormField<String>(
              items: dropdownItems.length < 2 ? null : dropdownItems,
              onChanged: dropdownItems.length < 2 ? null: (String? value) {
                setState(() {
                  _another_book_title = value!;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Book title cannot be empty';
                }else if (value == _book_title) {
                  return 'You cannot recommend the same book';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: dropdownItems.length < 2 ? 'You must atleast have 2 books' : 'Select Book Title',
              ),
              isExpanded: true,
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
                labelText: dropdownItems.length < 2 ? 'You must atleast have 2 books' : 'Description',
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
              enabled: dropdownItems.length >= 2,
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
                                  Uri.parse("https://litera-b06-tk.pbp.cs.ui.ac.id/recommendation/create-flutter/"),
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
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MyHomePage(title: "LITERA")),
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
                        Navigator.pop(context);
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