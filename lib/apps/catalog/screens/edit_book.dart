import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:litera_mobile/apps/catalog/screens/catalog.dart';
import 'package:litera_mobile/components/head.dart';
import 'package:litera_mobile/main.dart';

class EditBookPage extends StatefulWidget {
  final int bookId;

  EditBookPage({required this.bookId});

  @override
  _EditBookPageState createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  late TextEditingController titleController;
  late TextEditingController authorController;
  late TextEditingController yearController;
  late TextEditingController categoryController;
  late TextEditingController imageLinkController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    authorController = TextEditingController();
    yearController = TextEditingController();
    categoryController = TextEditingController();
    imageLinkController = TextEditingController();
    descriptionController = TextEditingController();
    loadBookDetails();
  }

  Future<void> loadBookDetails() async {
    try {
      var url = Uri.parse(
          'https://litera-b06-tk.pbp.cs.ui.ac.id/catalog/get_product_id/${widget.bookId}/');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data is Map<String, dynamic>) {
          setState(() {
            titleController.text = data['title'];
            imageLinkController.text = data['imageLink'];
            authorController.text = data['author'];
            yearController.text = data['yearOfPublished'].toString();
            categoryController.text = data['category'];
            descriptionController.text = data['description'];
          });
        } else {
          print('Unexpected data structure: $data');
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
        print('Response content: ${response.body}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> editBook() async {
    try {
      var url = Uri.parse(
          'https://litera-b06-tk.pbp.cs.ui.ac.id/catalog/edit_product_flutter/${widget.bookId}/');
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'title': titleController.text,
          'imageLink': imageLinkController.text,
          'author': authorController.text,
          'yearOfPublished': int.parse(yearController.text),
          'category': categoryController.text,
          'description': descriptionController.text,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BookPage()),
        );
      } else {
        // Update not successful
        print('Update failed with status: ${response.statusCode}.');
        print('Response content: ${response.body}');
      }
    } catch (e) {
      print('Error updating book: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(202, 209, 218, 1),
      body: Column(
        children: [
          MyHeader(height: 86),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: imageLinkController,
                      decoration: InputDecoration(
                        labelText: 'Image Link',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: authorController,
                      decoration: InputDecoration(
                        labelText: 'Author',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: yearController,
                      decoration: InputDecoration(
                        labelText: 'Year Of Published',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: categoryController,
                      decoration: InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color(0xFF105857)), // Warna background button
                      ),
                      onPressed: editBook,
                      child: Text(
                        'Edit Book',
                        style: TextStyle(
                            color: Colors.white, fontFamily: "Poppins"),
                      ),
                    ),
                  ],
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
