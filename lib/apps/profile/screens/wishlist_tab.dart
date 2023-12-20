import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:litera_mobile/apps/authentication/models/User.dart';
import 'package:litera_mobile/apps/catalog/models/Book.dart';
import 'package:litera_mobile/apps/profile/models/WishlistBook.dart';
import 'package:litera_mobile/components/head.dart';
import 'package:litera_mobile/main.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class WishlistService {
  final String baseUrl; // Replace with your actual API base URL

  WishlistService(this.baseUrl);

  Future<void> addToWishlist(int bookId) async {
    final url = Uri.parse('$baseUrl/wishlist/add'); // Replace with your API endpoint
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"bookId": bookId}),
    );

    if (response.statusCode == 200) {
      // Wishlist addition successful
      print('Book added to wishlist successfully');
    } else {
      // Handle the error
      print('Failed to add book to wishlist');
    }
  }

  Future<void> removeFromWishlist(int bookId) async {
    final url = Uri.parse('$baseUrl/wishlist/remove'); // Replace with your API endpoint
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"bookId": bookId}),
    );

    if (response.statusCode == 200) {
      // Wishlist removal successful
      print('Book removed from wishlist successfully');
    } else {
      // Handle the error
      print('Failed to remove book from wishlist');
    }
  }
}

class WishlistTab extends StatefulWidget {
  @override
  _WishlistTabState createState() => _WishlistTabState();
}

class _WishlistTabState extends State<WishlistTab> {
  // Future<List<Book>> fetchAvailableBooks() async {
  //   final url = Uri.parse('https://litera-b06-tk.pbp.cs.ui.ac.id/catalog'); 
  //   final response = await http.get(
  //     url,
  //     headers: {"Content-Type": "application/json"},
  //   );
  //   final data = jsonDecode(utf8.decode(response.bodyBytes));
  //   List<Book> availableBooks = [];
  //   for (var d in data) {
  //     if (d != null) {
  //       availableBooks.add(Book.fromJson(d));
  //     }
  //   }
  //   return availableBooks;
  // }

  // Future<void> addToWishlist(int bookId) async {
  //   var url = Uri.parse('https://litera-b06-tk.pbp.cs.ui.ac.id/add_to_wishlist'); 
  //   var response = await http.post(
  //     url,
  //     headers: {"Content-Type": "application/json"},
  //     body: jsonEncode({'book_id': bookId}),
  //   );

  //   if (response.statusCode == 201) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text(
  //         'Book added to wishlist successfully.',
  //         style: TextStyle(
  //           fontFamily: 'Poppins',
  //         ),
  //       ),
  //     ));
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text(
  //         'Failed to add book to wishlist.',
  //         style: TextStyle(
  //           fontFamily: 'Poppins',
  //         ),
  //       ),
  //     ));
  //   }
  // }

  // Future<List<WishlistBook>> fetchWishlistBooks() async {
  //   final url = Uri.parse('https://litera-b06-tk.pbp.cs.ui.ac.id/wishlist_books'); 
  //   final response = await http.get(
  //     url,
  //     headers: {"Content-Type": "application/json"},
  //   );
  //   final data = jsonDecode(utf8.decode(response.bodyBytes));
  //   List<WishlistBook> wishlistBooks = [];
  //   for (var d in data) {
  //     if (d != null) {
  //       wishlistBooks.add(WishlistBook.fromJson(d));
  //     }
  //   }
  //   return wishlistBooks;
  // }

  @override
  // Widget build(BuildContext context) {
  //   final request = context.watch<CookieRequest>();

  //   return Scaffold(
  //     backgroundColor: const Color.fromRGBO(202, 209, 218, 1),
  //     body: FutureBuilder(
  //       future: fetchAvailableBooks(),
  //       builder: (context, AsyncSnapshot<List<Book>> snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return Center(child: CircularProgressIndicator());
  //         } else if (!snapshot.hasData) {
  //           return const Center(
  //             child: Text(
  //               'No available books.',
  //               style: TextStyle(
  //                 fontSize: 18.0,
  //                 fontWeight: FontWeight.bold,
  //                 fontFamily: 'Poppins',
  //               ),
  //             ),
  //           );
  //         } else {
  //           List<Book> availableBooks = snapshot.data!;

  //           return Column(
  //             crossAxisAlignment: CrossAxisAlignment.stretch,
  //             children: [
  //               const MyHeader(height: 86),
  //               const SizedBox(height: 11),

  //               Text(
  //                 'Available Books:',
  //                 style: const TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                   fontFamily: 'Poppins',
  //                 ),
  //                 textAlign: TextAlign.center,
  //               ),
  //               Expanded(
  //                 child: Container(
  //                   padding: const EdgeInsets.symmetric(vertical: 8.0),
  //                   margin: const EdgeInsets.symmetric(horizontal: 8.0),
  //                   decoration: BoxDecoration(
  //                     color: const Color.fromARGB(255, 154, 161, 171),
  //                     border: Border.all(
  //                       color: Colors.black,
  //                       width: 0.5,
  //                     ),
  //                   ),
  //                   child: GridView.builder(
  //                     shrinkWrap: true,
  //                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //                       crossAxisCount: 3,
  //                       crossAxisSpacing: 0,
  //                       mainAxisSpacing: 0,
  //                     ),
  //                     itemCount: availableBooks.length,
  //                     itemBuilder: (context, index) {
  //                       Book book = availableBooks[index];
  //                       return GridTile(
  //                         child: Column(
  //                           children: [
  //                             Image.network(
  //                               book.fields.imageLink,
  //                               height: 100,
  //                               width: 80,
  //                               fit: BoxFit.cover,
  //                             ),
  //                             ElevatedButton(
  //                               onPressed: () {
  //                                 addToWishlist(book.pk);
  //                               },
  //                               child: const Text('Add to Wishlist'),
  //                             ),
  //                           ],
  //                         ),
  //                       );
  //                     },
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(height: 16.0),
  //               // Additional widgets or buttons can be added here as needed
  //             ],
  //           );
  //         }
  //       },
  //     ),
  //   );
  // }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(202, 209, 218, 1),
      body: Center(
        child: Text(
          'This is a blank page.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
