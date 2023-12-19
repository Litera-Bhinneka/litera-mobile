// // // // // import 'dart:html';

// // // // // import 'package:flutter/material.dart';

// // // // // class DetailPage extends StatelessWidget {
// // // // //   final String title;
// // // // //   final int rating;
// // // // //   final String author;
// // // // //   final String category;
// // // // //   final String imageLink;
// // // // //   final String publisher;
// // // // //   final String description;
// // // // //   final int yearOfPublished;

// // // // //   // You can pass more data here as needed

// // // // //   DetailPage(
// // // // //       {required this.title,
// // // // //       required this.rating,
// // // // //       required this.author,
// // // // //       required this.category,
// // // // //       required this.imageLink,
// // // // //       required this.publisher,
// // // // //       required this.description,
// // // // //       required this.yearOfPublished});

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return Scaffold(
// // // // //       body: Padding(
// // // // //         padding: const EdgeInsets.all(16.0),
// // // // //         child: Column(
// // // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // // //           children: [
// // // // //             // Custom back button
// // // // //             GestureDetector(
// // // // //               onTap: () {
// // // // //                 // Navigate back to the previous screen
// // // // //                 Navigator.pop(context);
// // // // //               },
// // // // //               child: Row(
// // // // //                 children: [
// // // // //                   Icon(Icons.arrow_back),
// // // // //                   Text(' Back', style: TextStyle(fontSize: 16)),
// // // // //                 ],
// // // // //               ),
// // // // //             ),
// // // // //             const SizedBox(height: 20),
// // // // //             // Url(
// // // // //             //   $image_link,
// // // // //             // )
// // // // //             Image.asset(imageLink),
// // // // //             Text(
// // // // //               '$title',
// // // // //               style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
// // // // //             ),
// // // // //             const SizedBox(height: 10),
// // // // //             Text('Jumlah: $author'),
// // // // //             const SizedBox(height: 10),
// // // // //             Text('Harga: $category'),
// // // // //             const SizedBox(height: 10),
// // // // //             Text('Deskripsi: $yearOfPublished'),
// // // // //           ],
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }

// // // // import 'package:flutter/material.dart';
// // // // import 'package:http/http.dart' as http;
// // // // import 'dart:convert';
// // // // import 'package:intl/intl.dart';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:litera_mobile/apps/authentication/models/User.dart';
// // // // import 'package:litera_mobile/apps/catalog/models/Book.dart';
// // // // import 'package:litera_mobile/apps/review/pages/show_review.dart';
// // // // import 'package:litera_mobile/components/head.dart';
// // // // import 'package:readmore/readmore.dart';

// // // // class BookPage extends StatefulWidget {
// // // //   const BookPage({Key? key}) : super(key: key);

// // // //   @override
// // // //   _BookPageState createState() => _BookPageState();
// // // // }

// // // // class _BookPageState extends State<BookPage> {
// // // //   Future<List<Book>> fetchProduct() async {
// // // //     // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
// // // //     var url = Uri.parse('http://10.0.2.2:8000/catalog/get-product/');
// // // //     var response = await http.get(
// // // //       url,
// // // //       headers: {"Content-Type": "application/json"},
// // // //     );

// // // //     // melakukan decode response menjadi bentuk json
// // // //     var data = jsonDecode(utf8.decode(response.bodyBytes));

// // // //     // melakukan konversi data json menjadi object Product
// // // //     List<Book> list_book = [];
// // // //     for (var d in data) {
// // // //       if (d != null) {
// // // //         list_book.add(Book.fromJson(d));
// // // //       }
// // // //     }
// // // //     return list_book;
// // // //   }

// // // //   // @override
// // // //   // Widget build(BuildContext context) {
// // // //   //   return Scaffold(
// // // //   //       backgroundColor: Color.fromRGBO(202, 209, 218, 1),
// // // //   //       // appBar: AppBar(
// // // //   //       //   title: const Text('Daftar Item'),
// // // //   //       //   foregroundColor: Colors.white,
// // // //   //       // ),
// // // //   //       //drawer: const LeftDrawer(),
// // // //   //       body: FutureBuilder(
// // // //   //           future: fetchProduct(),
// // // //   //           builder: (context, AsyncSnapshot snapshot) {
// // // //   //             if (snapshot.connectionState == ConnectionState.waiting) {
// // // //   //               return const Center(child: CircularProgressIndicator());
// // // //   //             } else if (snapshot.hasError) {
// // // //   //               return const Center(child: Text('Error loading data'));
// // // //   //             } else if (!snapshot.hasData || snapshot.data == null) {
// // // //   //               return const Column(
// // // //   //                 children: [
// // // //   //                   Text(
// // // //   //                     "Tidak ada data buku.",
// // // //   //                     style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
// // // //   //                   ),
// // // //   //                   SizedBox(height: 8),
// // // //   //                 ],
// // // //   //               );
// // // //   //             } else {
// // // //   //               // return ListView.builder(
// // // //   //               //     itemCount: snapshot.data!.length,
// // // //   //               //     itemBuilder: (_, index) => Container(
// // // //   //               //           margin: const EdgeInsets.symmetric(
// // // //   //               //               horizontal: 16, vertical: 12),
// // // //   //               //           padding: const EdgeInsets.all(20.0),
// // // //   //               return ListView.builder(
// // // //   //                   //itemCount: snapshot.data!.length,
// // // //   //                   itemBuilder: (_, index) => InkWell(
// // // //   //                       onTap: () {
// // // //   //                         // Navigate ke detail page
// // // //   //                         Navigator.push(
// // // //   //                           context,
// // // //   //                           MaterialPageRoute(
// // // //   //                             builder: (context) => ShowReview(
// // // //   //                                 // image_link: snapshot.data![index].fields.name,
// // // //   //                                 // itemAmount:
// // // //   //                                 //     snapshot.data![index].fields.ammount,
// // // //   //                                 // price: snapshot.data![index].fields.price,
// // // //   //                                 // itemDescription:
// // // //   //                                 //     snapshot.data![index].fields.description,
// // // //   //                                 book_id: snapshot.data![index].fields.pk
// // // //   //                                 // Pass more data if needed
// // // //   //                                 ),
// // // //   //                           ),
// // // //   //                         );
// // // //   //                       },
// // // //   //                       child: Container(
// // // //   //                         margin: const EdgeInsets.symmetric(
// // // //   //                             horizontal: 16, vertical: 12),
// // // //   //                         padding: const EdgeInsets.all(20.0),
// // // //   //                         child: Column(
// // // //   //                           mainAxisAlignment: MainAxisAlignment.start,
// // // //   //                           crossAxisAlignment: CrossAxisAlignment.start,
// // // //   //                           children: [
// // // //   //                             Text(
// // // //   //                               "${snapshot.data![index].fields.image}",
// // // //   //                               style: const TextStyle(
// // // //   //                                 fontSize: 18.0,
// // // //   //                                 fontWeight: FontWeight.bold,
// // // //   //                               ),
// // // //   //                             ),
// // // //   //                             const SizedBox(height: 10),
// // // //   //                             Text("${snapshot.data![index].fields.ammount}"),
// // // //   //                             const SizedBox(height: 10),
// // // //   //                             Text("${snapshot.data![index].fields.price}"),
// // // //   //                             const SizedBox(height: 10),
// // // //   //                             Text(
// // // //   //                                 "${snapshot.data![index].fields.description}")
// // // //   //                           ],
// // // //   //                         ),
// // // //   //                       )));
// // // //   //             }
// // // //   //           }));
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       backgroundColor: Color.fromRGBO(202, 209, 218, 1),
// // // //       body: FutureBuilder(
// // // //         future: fetchProduct(),
// // // //         builder: (context, AsyncSnapshot<List<Book>> snapshot) {
// // // //           if (snapshot.connectionState == ConnectionState.waiting) {
// // // //             return Center(child: CircularProgressIndicator());
// // // //           } else if (snapshot.hasError) {
// // // //             return Center(child: Text('Error loading data'));
// // // //           } else if (!snapshot.hasData || snapshot.data == null) {
// // // //             return Column(
// // // //               children: [
// // // //                 Text(
// // // //                   "Tidak ada data buku.",
// // // //                   style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
// // // //                 ),
// // // //                 SizedBox(height: 8),
// // // //               ],
// // // //             );
// // // //           } else {
// // // //             return ListView.builder(
// // // //               itemCount: snapshot.data!.length,
// // // //               itemBuilder: (_, index) => InkWell(
// // // //                 onTap: () {
// // // //                   Navigator.push(
// // // //                     context,
// // // //                     MaterialPageRoute(
// // // //                       builder: (context) => ShowReview(
// // // //                         book_id: snapshot.data![index].pk,
// // // //                       ),
// // // //                     ),
// // // //                   );
// // // //                 },
// // // //                 child: Container(
// // // //                   margin: const EdgeInsets.symmetric(
// // // //                     horizontal: 16,
// // // //                     vertical: 12,
// // // //                   ),
// // // //                   padding: const EdgeInsets.all(20.0),
// // // //                   child: Column(
// // // //                     mainAxisAlignment: MainAxisAlignment.start,
// // // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // // //                     children: [
// // // //                       Image.network(
// // // //                         "${snapshot.data![index].fields.imageLink}",
// // // //                         width: 100,
// // // //                         height: 150,
// // // //                         fit: BoxFit.cover,
// // // //                       ),
// // // //                       const SizedBox(height: 10),
// // // //                       Text(
// // // //                         "${snapshot.data![index].fields.title}",
// // // //                         style: const TextStyle(
// // // //                           fontSize: 18.0,
// // // //                           fontWeight: FontWeight.bold,
// // // //                         ),
// // // //                       ),
// // // //                       const SizedBox(height: 10),
// // // //                       Text("Author: ${snapshot.data![index].fields.author}"),
// // // //                       const SizedBox(height: 10),
// // // //                       // Text("Author: ${snapshot.data![index].fields.author}"),
// // // //                       Text(
// // // //                           "Category: ${snapshot.data![index].fields.category}"),
// // // //                       const SizedBox(height: 10),
// // // //                       Text(
// // // //                           "Year of Publication: ${snapshot.data![index].fields.yearOfPublished}"),
// // // //                     ],
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //             );
// // // //           }
// // // //         },
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // import 'package:flutter/material.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'dart:convert';
// // // import 'package:litera_mobile/apps/catalog/models/Book.dart';
// // // import 'package:litera_mobile/apps/review/pages/show_review.dart';

// // // class BookPage extends StatefulWidget {
// // //   const BookPage({Key? key}) : super(key: key);

// // //   @override
// // //   _BookPageState createState() => _BookPageState();
// // // }

// // // class _BookPageState extends State<BookPage> {
// // //   Future<List<Book>> fetchProduct() async {
// // //     try {
// // //       var url = Uri.parse('http://localhost:8000/catalog/get-product/');
// // //       var response =
// // //           await http.get(url, headers: {"Content-Type": "application/json"});

// // //       if (response.statusCode == 200) {
// // //         var data = jsonDecode(utf8.decode(response.bodyBytes));
// // //         List<Book> listBook = [for (var d in data) Book.fromJson(d)];
// // //         return listBook;
// // //       } else {
// // //         // Handle the case when the server response is not successful
// // //         throw Exception('Failed to load books from the server');
// // //       }
// // //     } catch (e) {
// // //       // Handle any exceptions that occur during the HTTP request
// // //       print('Error fetching data: $e');
// // //       rethrow;
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: Color.fromRGBO(202, 209, 218, 1),
// // //       body: FutureBuilder<List<Book>>(
// // //         future: fetchProduct(),
// // //         builder: (context, snapshot) {
// // //           if (snapshot.connectionState == ConnectionState.waiting) {
// // //             return Center(child: CircularProgressIndicator());
// // //           } else if (snapshot.hasError) {
// // //             return Center(child: Text('Error loading data: ${snapshot.error}'));
// // //           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
// // //             return Center(child: Text("Tidak ada data buku."));
// // //           } else {
// // //             return ListView.builder(
// // //               itemCount: snapshot.data!.length,
// // //               itemBuilder: (_, index) => InkWell(
// // //                 onTap: () {
// // //                   Navigator.push(
// // //                     context,
// // //                     MaterialPageRoute(
// // //                       builder: (context) =>
// // //                           ShowReview(book_id: snapshot.data![index].pk),
// // //                     ),
// // //                   );
// // //                 },
// // //                 child: Container(
// // //                   margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// // //                   padding: EdgeInsets.all(20.0),
// // //                   child: Column(
// // //                     mainAxisAlignment: MainAxisAlignment.start,
// // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // //                     children: [
// // //                       Image.network(
// // //                         snapshot.data![index].fields.imageLink,
// // //                         width: 100,
// // //                         height: 150,
// // //                         fit: BoxFit.cover,
// // //                       ),
// // //                       SizedBox(height: 10),
// // //                       Text(
// // //                         snapshot.data![index].fields.title,
// // //                         style: TextStyle(
// // //                             fontSize: 18.0, fontWeight: FontWeight.bold),
// // //                       ),
// // //                       SizedBox(height: 10),
// // //                       Text("Author: ${snapshot.data![index].fields.author}"),
// // //                     ],
// // //                   ),
// // //                 ),
// // //               ),
// // //             );
// // //           }
// // //         },
// // //       ),
// // //     );
// // //   }
// // // }

// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// // import 'package:litera_mobile/apps/catalog/models/Book.dart';
// // import 'package:litera_mobile/apps/review/pages/show_review.dart';

// // class BookPage extends StatefulWidget {
// //   const BookPage({Key? key}) : super(key: key);

// //   @override
// //   _BookPageState createState() => _BookPageState();
// // }

// // class _BookPageState extends State<BookPage> {
// //   Future<List<Book>> fetchProduct() async {
// //     try {
// //       var url = Uri.parse('http://localhost:8000/catalog/get-product/');
// //       print('Sending request to: $url');

// //       var response =
// //           await http.get(url, headers: {"Content-Type": "application/json"});
// //       print('Response status code: ${response.statusCode}');

// //       if (response.statusCode == 200) {
// //         var data = jsonDecode(utf8.decode(response.bodyBytes));
// //         if (data is List) {
// //           return [for (var d in data) Book.fromJson(d)];
// //         }
// //       } else {
// //         print('Request failed with status: ${response.statusCode}.');
// //       }
// //     } catch (e) {
// //       print('Error fetching data: $e');
// //     }
// //     return []; // Return an empty list in case of failure
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Color.fromRGBO(202, 209, 218, 1),
// //       body: FutureBuilder<List<Book>>(
// //         future: fetchProduct(),
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return Center(child: CircularProgressIndicator());
// //           } else if (snapshot.hasError) {
// //             return Center(child: Text('Error loading data: ${snapshot.error}'));
// //           } else if (snapshot.data == null || snapshot.data!.isEmpty) {
// //             return Center(child: Text("Tidak ada data buku."));
// //           } else {
// //             return ListView.builder(
// //               itemCount: snapshot.data!.length,
// //               itemBuilder: (_, index) {
// //                 // Safe access using null-aware operators
// //                 var book = snapshot.data?[index];
// //                 return InkWell(
// //                   onTap: () {
// //                     if (book != null) {
// //                       Navigator.push(
// //                         context,
// //                         MaterialPageRoute(
// //                           builder: (context) => ShowReview(book_id: book.pk),
// //                         ),
// //                       );
// //                     }
// //                   },
// //                   child: Container(
// //                     margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //                     padding: EdgeInsets.all(20.0),
// //                     child: Column(
// //                       mainAxisAlignment: MainAxisAlignment.start,
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         // Safe access to book properties
// //                         if (book?.fields.imageLink != null)
// //                           Image.network(
// //                             book!.fields.imageLink,
// //                             width: 100,
// //                             height: 150,
// //                             fit: BoxFit.cover,
// //                           ),
// //                         SizedBox(height: 10),
// //                         Text(
// //                           book?.fields.title ?? 'Unknown Title',
// //                           style: TextStyle(
// //                               fontSize: 18.0, fontWeight: FontWeight.bold),
// //                         ),
// //                         SizedBox(height: 10),
// //                         Text("Author: ${book?.fields.author ?? 'Unknown'}"),
// //                       ],
// //                     ),
// //                   ),
// //                 );
// //               },
// //             );
// //           }
// //         },
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:litera_mobile/apps/catalog/models/Book.dart';
// import 'package:litera_mobile/apps/review/pages/show_review.dart';

// class BookPage extends StatefulWidget {
//   const BookPage({Key? key}) : super(key: key);

//   @override
//   _BookPageState createState() => _BookPageState();
// }

// class _BookPageState extends State<BookPage> {
//   Future<List<Book>> fetchProduct() async {
//     try {
//       var url = Uri.parse(
//           'http://127.0.0.1:8000/catalog/get-product/'); // Replace with actual server IP
//       var response =
//           await http.get(url, headers: {"Content-Type": "application/json"});

//       if (response.statusCode == 200) {
//         var data = jsonDecode(utf8.decode(response.bodyBytes));
//         //print(data);

//         if (data is List) {
//           List<Book> listBook = [for (var d in data) Book.fromJson(d)];
//           return listBook;
//         } else {
//           print('Unexpected data structure: $data');
//         }
//       } else {
//         print('Request failed with status: ${response.statusCode}.');
//         print('Response content: ${response.body}');
//       }
//     } catch (e) {
//       print('Error fetching data: $e');
//     }
//     return [];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromRGBO(202, 209, 218, 1),
//       body: FutureBuilder<List<Book>>(
//         future: fetchProduct(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error loading data: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text("No book data available."));
//           } else {
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (_, index) {
//                 var book = snapshot.data![index];
//                 return InkWell(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ShowReview(book_id: book.pk),
//                       ),
//                     );
//                   },
//                   child: Container(
//                     margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                     padding: EdgeInsets.all(20.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Image.network(
//                           book.fields.imageLink,
//                           width: 100,
//                           height: 150,
//                           fit: BoxFit.cover,
//                         ),
//                         SizedBox(height: 10),
//                         Text(
//                           book.fields.title,
//                           style: TextStyle(
//                               fontSize: 18.0, fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(height: 10),
//                         Text("Author: ${book.fields.author}"),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:litera_mobile/apps/catalog/models/Book.dart';
// import 'package:litera_mobile/apps/review/pages/show_review.dart';

// class BookPage extends StatefulWidget {
//   const BookPage({Key? key}) : super(key: key);

//   @override
//   _BookPageState createState() => _BookPageState();
// }

// class _BookPageState extends State<BookPage> {
//   Future<List<Book>> fetchProduct() async {
//     try {
//       var url = Uri.parse(
//           'http://localhost:8000/catalog/get-product/'); // Replace with actual server IP
//       var response =
//           await http.get(url, headers: {"Content-Type": "application/json"});

//       if (response.statusCode == 200) {
//         var data = jsonDecode(utf8.decode(response.bodyBytes));
//         if (data is List) {
//           return [for (var d in data) Book.fromJson(d)];
//         } else {
//           // If data is not a list, handle the error
//           print('Data received is not a list.');
//           throw 'Data format error: Expected a List';
//         }
//       } else {
//         // Handle non-200 responses
//         print(
//             'Request failed with status: ${response.statusCode}. Response Body: ${response.body}');
//         throw 'Request failed with status: ${response.statusCode}';
//       }
//     } catch (e) {
//       print('Error fetching data: $e');
//       throw 'Error fetching data: $e'; // Rethrow the error to be caught by FutureBuilder
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromRGBO(202, 209, 218, 1),
//       body: FutureBuilder<List<Book>>(
//         future: fetchProduct(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             // Display error message
//             return Center(child: Text('Error loading data: ${snapshot.error}'));
//           } else if (snapshot.hasData) {
//             if (snapshot.data!.isEmpty) {
//               return Center(child: Text("No book data available."));
//             }
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (_, index) {
//                 var book = snapshot.data![index];
//                 return InkWell(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ShowReview(book_id: book.pk),
//                       ),
//                     );
//                   },
//                   child: Container(
//                     margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                     padding: EdgeInsets.all(20.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Image.network(
//                           book.fields.imageLink,
//                           width: 100,
//                           height: 150,
//                           fit: BoxFit.cover,
//                         ),
//                         SizedBox(height: 10),
//                         Text(
//                           book.fields.title,
//                           style: TextStyle(
//                               fontSize: 18.0, fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(height: 10),
//                         Text("Author: ${book.fields.author}"),
//                         const SizedBox(height: 10),
//                         Text('Kategori: ${book.fields.category}'),
//                         const SizedBox(height: 10),
//                         Text('Tahun: ${book.fields.yearOfPublished}'),
//                         // const SizedBox(height: 10),
//                         // Text('Deskripsi: $yearOfPublished'),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           } else {
//             // Handle case where snapshot has no data
//             return Center(child: Text("Loading..."));
//           }
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:litera_mobile/apps/catalog/models/Book.dart';
// import 'package:litera_mobile/apps/catalog/screens/add_book.dart';
// import 'package:litera_mobile/apps/review/pages/show_review.dart';
// import 'package:litera_mobile/apps/catalog/screens/add_book.dart';

// class BookPage extends StatefulWidget {
//   const BookPage({Key? key}) : super(key: key);

//   @override
//   _BookPageState createState() => _BookPageState();
// }

// class _BookPageState extends State<BookPage> {
//   Future<List<Book>> fetchProduct() async {
//     try {
//       var url = Uri.parse('http://localhost:8000/catalog/get-product/');
//       var response =
//           await http.get(url, headers: {"Content-Type": "application/json"});

//       if (response.statusCode == 200) {
//         var data = jsonDecode(utf8.decode(response.bodyBytes));
//         if (data is List) {
//           return [for (var d in data) Book.fromJson(d)];
//         } else {
//           print('Unexpected data structure: $data');
//         }
//       } else {
//         print('Request failed with status: ${response.statusCode}.');
//         print('Response content: ${response.body}');
//       }
//     } catch (e) {
//       print('Error fetching data: $e');
//     }
//     return [];
//   }

//   Future<void> performReset() async {
//     setState(() {
//       searchController.text = '';
//       displayedProducts = allProducts;
//       selectedSearchCriteria = 'Title';
//     });
//   }

//   Future<void> performSearch() async {
//     String searchTerm = searchController.text.toLowerCase();

//     setState(() {
//       displayedProducts = allProducts.where((product) {
//         switch (selectedSearchCriteria) {
//           case 'Title':
//             return product.fields.title.toLowerCase().contains(searchTerm);
//           case 'Author':
//             return product.fields.author.toLowerCase().contains(searchTerm);
//           case 'Publisher':
//             return product.fields.publisher.toLowerCase().contains(searchTerm);
//           default:
//             return false;
//         }
//       }).toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromRGBO(202, 209, 218, 1),
//       body: Column(
//         children: [
//           ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => AddBook(),
//                 ),
//               );
//             },
//             child: Text('Add Book'),
//           ),
//           Expanded(
//             child: FutureBuilder<List<Book>>(
//               future: fetchProduct(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(
//                       child: Text('Error loading data: ${snapshot.error}'));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return Center(child: Text("No book data available."));
//                 } else {
//                   return ListView.builder(
//                     itemCount: snapshot.data!.length,
//                     itemBuilder: (_, index) {
//                       var book = snapshot.data![index];
//                       return InkWell(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   ShowReview(book_id: book.pk),
//                             ),
//                           );
//                         },
//                         child: Container(
//                           margin: EdgeInsets.symmetric(
//                               horizontal: 16, vertical: 12),
//                           padding: EdgeInsets.all(20.0),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Image.network(
//                                 book.fields.imageLink,
//                                 width: 100,
//                                 height: 150,
//                                 fit: BoxFit.cover,
//                               ),
//                               SizedBox(height: 10),
//                               Text(
//                                 book.fields.title,
//                                 style: TextStyle(
//                                     fontSize: 18.0,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                               SizedBox(height: 10),
//                               Text("Author: ${book.fields.author}"),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:litera_mobile/apps/catalog/models/Book.dart';
import 'package:litera_mobile/apps/catalog/screens/add_book.dart';
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
  String selectedSearchCriteria = 'Judul';

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
      selectedSearchCriteria = 'Judul';
    });
  }

  Future<void> search() async {
    String searchTerm = searchController.text.toLowerCase();

    setState(() {
      displayedProducts = allProducts.where((product) {
        switch (selectedSearchCriteria) {
          case 'Judul':
            return product.fields.title.toLowerCase().contains(searchTerm);
          case 'Penulis':
            return product.fields.author.toLowerCase().contains(searchTerm);
          case 'Tahun Terbit':
            int searchYear = int.tryParse(searchTerm) ?? 0;
            return product.fields.yearOfPublished == searchYear;
          case 'Kategori':
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
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddBook(),
                ),
              );
            },
            child: Text('Add Book'),
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
                    'Judul',
                    'Penulis',
                    'Tahun Terbit',
                    'Kategori'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: search,
                  child: Text('Search'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: performReset,
                  child: Text('Reset'),
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
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text("Author: ${book.fields.author}"),
                        const SizedBox(height: 10),
                        Text('Kategori: ${book.fields.category}'),
                        const SizedBox(height: 10),
                        Text('Tahun: ${book.fields.yearOfPublished}'),
                        ElevatedButton(
                          onPressed: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListOwners(id: book.pk),
                              ),
                            );
                          },
                          child: const Text('List Owners'),
                        )
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
}
