import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:litera_mobile/apps/authentication/models/User.dart';
import 'package:litera_mobile/apps/authentication/pages/LoginPage.dart';
import 'dart:convert';
import 'package:litera_mobile/apps/catalog/models/Book.dart';
import 'package:litera_mobile/apps/catalog/screens/add_book.dart';
import 'package:litera_mobile/apps/catalog/screens/edit_book.dart';
import 'package:litera_mobile/apps/exchange/screens/list_owners.dart';
import 'package:litera_mobile/apps/review/pages/add_review.dart';
import 'package:litera_mobile/apps/review/pages/show_review.dart';
import 'package:litera_mobile/apps/catalog/screens/add_book.dart';
import 'package:litera_mobile/apps/review/utils/util.dart';
import 'package:litera_mobile/components/head.dart';
import 'package:litera_mobile/components/status.dart';
import 'package:litera_mobile/main.dart';

class BookPage extends StatefulWidget {
  const BookPage({Key? key}) : super(key: key);

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  TextEditingController searchController = TextEditingController();
  List<Book> allProducts = [];
  List<Book> displayedProducts = [];
  String selectedSearchCriteria = 'Title';

  @override
  void initState() {
    super.initState();
    fetchProduct();
  }

  Future<void> fetchProduct() async {
    try {
      var url = Uri.parse(
          'https://litera-b06-tk.pbp.cs.ui.ac.id/catalog/get-product/');
      var response =
          await http.get(url, headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data is List) {
          setState(() {
            allProducts = [for (var d in data) Book.fromJson(d)];
            displayedProducts = allProducts;
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

  Future<void> performReset() async {
    setState(() {
      searchController.text = '';
      displayedProducts = allProducts;
      selectedSearchCriteria = 'Title';
    });
  }

  Future<void> search() async {
    String searchTerm = searchController.text.toLowerCase();

    setState(() {
      displayedProducts = allProducts.where((product) {
        switch (selectedSearchCriteria) {
          case 'Title':
            return product.fields.title.toLowerCase().contains(searchTerm);
          case 'Author':
            return product.fields.author.toLowerCase().contains(searchTerm);
          case 'Year Of Published':
            int searchYear = int.tryParse(searchTerm) ?? 0;
            return product.fields.yearOfPublished == searchYear;
          case 'Category':
            return product.fields.category.toLowerCase().contains(searchTerm);
          default:
            return false;
        }
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(202, 209, 218, 1),
      body: Column(
        children: [
          MyHeader(
            height: 86,
          ),
          SizedBox(height: 8),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Color(0xFF105857)),
            ),
            onPressed: () {
              if (isGuestUser()) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(title: "Login"),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddBook(),
                  ),
                );
              }
            },
            child: Text('Add Book',
                style: TextStyle(color: Colors.white, fontFamily: "Poppins")),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                    ),
                  ),
                ),
                SizedBox(width: 8),
                DropdownButton<String>(
                  value: selectedSearchCriteria,
                  onChanged: (String? value) {
                    setState(() {
                      selectedSearchCriteria = value!;
                    });
                  },
                  items: <String>[
                    'Title',
                    'Author',
                    'Year Of Published',
                    'Category'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFF105857)),
                  ),
                  onPressed: search,
                  child: Text('Search',
                      style: TextStyle(
                          color: Colors.white, fontFamily: "Poppins")),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFF105857)),
                  ),
                  onPressed: performReset,
                  child: Text('Reset',
                      style: TextStyle(
                          color: Colors.white, fontFamily: "Poppins")),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: displayedProducts.length,
              itemBuilder: (_, index) {
                var book = displayedProducts[index];
                return InkWell(
                  onTap: () {
                    // Status.selectedBookId = book.pk;
                    // Status.currentPageIndex = 4;
                    // print(Status.currentPageIndex);
                    BookState.bookId = book.pk;
                    BookState.bookTitle = book.fields.title;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowReview(book_id: book.pk),
                      ),
                    );
                    // Navigator.pushReplacement(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                     builder: (context) =>
                    //                         MyHomePage(title: "LITERA")),
                    //               );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          book.fields.imageLink,
                          width: 100,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 10),
                        Text(
                          book.fields.title,
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins"),
                        ),
                        SizedBox(height: 8),
                        Text("Author: ${book.fields.author}",
                            style: TextStyle(fontFamily: "Poppins")),
                        const SizedBox(height: 5),
                        Text('Category: ${book.fields.category}',
                            style: TextStyle(fontFamily: "Poppins")),
                        const SizedBox(height: 5),
                        Text(
                            'Year Of Published: ${book.fields.yearOfPublished}',
                            style: TextStyle(fontFamily: "Poppins")),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xFF105857))),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListOwners(id: book.pk),
                              ),
                            );
                          },
                          child: const Text('List Owners',
                              style: TextStyle(
                                  color: Colors.white, fontFamily: "Poppins")),
                        ),
                        if (UserLoggedIn.user.role == "admin")
                          SizedBox(height: 16),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xFF105857))),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditBookPage(
                                  bookId: book.pk,
                                ),
                              ),
                            );
                          },
                          child: const Text('Edit',
                              style: TextStyle(
                                  color: Colors.white, fontFamily: "Poppins")),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool isGuestUser() {
    return UserLoggedIn.user.role == "guest";
  }
}
