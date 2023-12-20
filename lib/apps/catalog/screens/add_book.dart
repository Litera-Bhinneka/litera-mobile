import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:litera_mobile/components/head.dart';
import 'package:litera_mobile/apps/catalog/screens/catalog.dart';
import 'package:litera_mobile/main.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class AddBook extends StatefulWidget {
  const AddBook({Key? key});

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _imageLink = "";
  String _description = "";
  String _author = "";
  String _category = "";
  int _yearOfPublished = 0;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: Color.fromRGBO(202, 209, 218, 1),
      body: Column(
        children: [
          MyHeader(height: 86),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Title",
                          labelText: "Title",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _title = value ?? "";
                          });
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Title cannot be empty!";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "Image Link",
                            labelText: "Image Link",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              _imageLink = value!;
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Image Link cannot be empty!";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "Description",
                            labelText: "Description",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              _description = value!;
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Description cannot be emptyg!";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "Author",
                            labelText: "Author",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              _author = value!;
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Author cannot be empty!";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "Category",
                            labelText: "Category",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              _category = value!;
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Category cannot be empty!";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "Year Of Published",
                            labelText: "Year Of Published",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              _yearOfPublished = int.parse(value!);
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Year Of Published cannot be empty!";
                            }
                            if (int.tryParse(value) == null) {
                              return "Year Of Published must be a number!";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color(0xFF105857)), // Warna background button
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final response = await request.postJson(
                                "https://litera-b06-tk.pbp.cs.ui.ac.id/catalog/create-flutter/",
                                jsonEncode(<String, dynamic>{
                                  'title': _title,
                                  'imageLink': _imageLink,
                                  'description': _description,
                                  'author': _author,
                                  'category': _category,
                                  'yearOfPublished':
                                      _yearOfPublished.toString(),
                                }),
                              );
                              if (response['status'] == 'success') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text("New item successfully saved!"),
                                  ),
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BookPage()),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "There was an error, please try again."),
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text(
                            "Save",
                            style: TextStyle(
                                color: Colors.white, fontFamily: "Poppins"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: FloatingActionButton(
                child: const Icon(Icons.arrow_back),
                backgroundColor: Color(0xFF105857),
                foregroundColor: Colors.white,
                shape: CircleBorder(),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(title: "LITERA"),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
