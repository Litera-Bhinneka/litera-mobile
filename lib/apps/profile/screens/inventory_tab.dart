import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:litera_mobile/apps/authentication/models/User.dart';
import 'package:litera_mobile/apps/catalog/screens/add_book.dart';
import 'package:litera_mobile/apps/exchange/models/InventoryBook.dart';
import 'package:litera_mobile/apps/profile/screens/AddInventroyDialog.dart';
import 'package:litera_mobile/components/head.dart';
import 'package:litera_mobile/main.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';


class InventoryTab extends StatefulWidget {
  InventoryBook? selectedBook;
  @override
  _InventoryTabState createState() => _InventoryTabState();
}

class _InventoryTabState extends State<InventoryTab> {
  set selectedBook(AddInventoryDialog selectedBook) {}

  Future<List<InventoryBook>> fetchAvailableBooks() async {
    var url = Uri.parse(
        'https://litera-b06-tk.pbp.cs.ui.ac.id/catalog/get-product/'); // Replace with your actual API URL
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<InventoryBook> availableBooks = [];
    for (var d in data) {
      if (d != null) {
        availableBooks.add(InventoryBook.fromJson(d));
      }
    }
    return availableBooks;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
        backgroundColor: const Color.fromRGBO(202, 209, 218, 1),
        body: FutureBuilder(
          future: fetchAvailableBooks(),
          builder: (context, AsyncSnapshot<List<InventoryBook>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData) {
              return const Center(
                child: Text(
                  'No available books.',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              );
            } else {
              List<InventoryBook> availableBooks = snapshot.data!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const MyHeader(height: 86),
                  const SizedBox(height: 11),
                  Text(
                    'Available Books:',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 154, 161, 171),
                        border: Border.all(
                          color: Colors.black,
                          width: 0.5,
                        ),
                      ),
                      child:  GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                  ),
                  itemCount: availableBooks.length,
                  itemBuilder: (context, index) {
                    InventoryBook book = availableBooks[index];
                    return GridTile(
                      child: Column(
                        children: [
                          Image.network(
                            book.image,
                            height: 100,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                          Text(
                            'Amount: ${book.amount}',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedBook = AddInventoryDialog(bookId: widget.selectedBook!.id);
                              });
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) =>
                                    AddInventoryDialog(bookId: book.id),
                              );
                            },
                            child: const Text('Add to Inventory'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // Additional widgets or buttons can be added here as needed
                ],
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          backgroundColor: Color(0xFF105857),
          foregroundColor: Colors.white,
          shape: CircleBorder(),
          onPressed: () {
            // showDialog<String>(
            //     context: context,
            //     builder: (BuildContext context) => AddInventoryDialog(bookId: widget.selectedBook!.id));
          },
        ));
  }
}
