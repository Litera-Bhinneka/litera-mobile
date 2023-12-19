import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:litera_mobile/apps/authentication/models/User.dart';
import 'package:litera_mobile/apps/authentication/pages/LoginPage.dart';
import 'package:litera_mobile/apps/catalog/models/Book.dart';
import 'package:litera_mobile/apps/review/components/multiselect.dart';
import 'package:litera_mobile/apps/review/components/star_rating.dart';
import 'package:litera_mobile/apps/review/models/Review.dart';
import 'package:litera_mobile/apps/review/pages/add_review.dart';
import 'package:litera_mobile/apps/review/utils/util.dart';
import 'package:litera_mobile/components/head.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:readmore/readmore.dart';
import 'package:data_filters/data_filters.dart';

class ShowReview extends StatefulWidget {
  const ShowReview({Key? key, required this.book_id}) : super(key: key);

  final int book_id;

  @override
  State<ShowReview> createState() => _ShowReviewState(book_id: book_id);
}

class DataFetcher {
  static Future<List<Review>> fetchReviews(int bookId) async {
    var url = Uri.parse(
        'http://localhost:8000/review/get-review-json/$bookId/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<Review> listReview = [];
    for (var d in data) {
      if (d != null) {
        listReview.add(Review.fromJson(d));
      }
    }
    return listReview;
  }

  static Future<List<Book>> fetchBooks(int bookId) async {
    var url = Uri.parse(
        'http://localhost:8000/review/get-book-json/$bookId/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<Book> listBook = [];
    for (var d in data) {
      if (d != null) {
        listBook.add(Book.fromJson(d));
      }
    }
    return listBook;
  }
}

class _ShowReviewState extends State<ShowReview> {
  Future<List<dynamic>> combinedFuture = Future.value(List.empty());
  List<int> ratingSelected = [1, 2, 3, 4, 5];
  List<String> _selectedItems = [];
  late String bookTitle;

  final int book_id;

  _ShowReviewState({required this.book_id});

  void _showMultiSelect() async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API
    final List<String> items = [
      '5 Star',
      '4 Star',
      '3 Star',
      '2 Star',
      '1 Star',
    ];

    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: items, selectedItems: _selectedItems);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        _selectedItems = results;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize combinedFuture with an empty list
    combinedFuture = Future.value(List.empty());
    // Load combined data initially
    loadCombinedData();
  }

  Future<void> loadCombinedData() async {
    setState(() {
      // Combine both book and review futures
      combinedFuture = Future.wait(
          [DataFetcher.fetchBooks(book_id), DataFetcher.fetchReviews(book_id)]);
    });
  }
  Future<void> deleteReview(int objectId) async {
    final response = await http.delete(
      Uri.parse('http://localhost:8000/review/delete-review/$objectId/'),
    );
    if (response.statusCode == 200) {
      // Deletion successful
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Review deleted successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // Deletion not successful
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete review'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  List<int> extractNumericValues(List<String> starRatings) {
    List<int> numericValues = [];

    for (String rating in starRatings) {
      // Split the string by space and take the first part
      String numericPart = rating.split(' ')[0];

      // Parse the numeric part to an integer and add it to the list
      int numericValue = int.parse(numericPart);
      numericValues.add(numericValue);
    }

    if (numericValues.length == 0) {
      numericValues = [1, 2, 3, 4, 5];
    }

    return numericValues;
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
            Expanded(
              child: SingleChildScrollView(
                child: FutureBuilder(
                future: combinedFuture,
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading data'));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Column(
                      children: [
                        Text(
                          "Tidak ada data item.",
                          style:
                              TextStyle(color: Color(0xff59A5D8), 
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.normal,
                              fontSize: 20),
                        ),
                        SizedBox(height: 8),
                      ],
                    );
                  } else {
                    List<Review> reviews = snapshot.data![1] as List<Review>;
                    List<Book> book = snapshot.data![0] as List<Book>;

                    // Calculate total and average rating
                    double totalRating = 0.0;
                    double averageRating = 0.0;

                    for (int index = 0; index < reviews.length; index++) {
                      totalRating += reviews[index].fields.reviewScore.toDouble();
                    }

                    if (reviews.length > 0) {
                      averageRating = totalRating / reviews.length;
                    }

                    // Display book details as the first item in the list
                    Widget bookDetails = Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        padding: const EdgeInsets.all(20.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Assuming book.cover is a URL to the cover image
                              Image.network(
                                Uri.encodeFull(book[0].fields.imageLink),
                                width: 200,
                                height: 300,
                                fit: BoxFit
                                    .contain, // Maintain aspect ratio without cropping
                              ),
                              const SizedBox(height: 16),
                              Text(
                                book[0].fields.title,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ReadMoreText(
                                "${book[0].fields.description}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w200,
                                ),
                                trimLines: 3,
                                colorClickableText:
                                    Color.fromARGB(255, 63, 101, 240),
                                trimMode: TrimMode.Line,
                                trimCollapsedText: 'Read more',
                                trimExpandedText: '\nRead less',
                                lessStyle: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 63, 101, 240)),
                                moreStyle: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 63, 101, 240)),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    "${double.parse(averageRating.toStringAsFixed(1))}  ",
                                    style: TextStyle(fontSize: 16, fontFamily: "Poppins",),
                                  ),
                                  RatingBarIndicator(
                                    rating: averageRating,
                                    itemBuilder: (context, index) => FaIcon(
                                      FontAwesomeIcons.solidStar,
                                      color: Color.fromARGB(255, 255, 207,
                                          63), // Adjust the opacity for partial stars
                                      size: 20.0,
                                    ),
                                    itemCount: 5,
                                    itemSize: 18,
                                  ),
                                  Text(
                                    "  (${reviews.length} ratings)",
                                    style: TextStyle(fontSize: 16, fontFamily: "Poppins", fontWeight: FontWeight.w200),
                                  )
                                ],
                              )
                            ],
                          ),
                        ));

                    Widget addReviewButton = TextButton(
                      style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF105857)), // Change the color as needed
                            ),
                      onPressed: () {
                        if (UserLoggedIn.user.role != "guest") {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => ReviewDialog(
                                book_id: book_id,
                                book_title: book[0].fields.title),
                          ).then((result) {
                            if (result == null) {
                              setState(() {
                                // Your refresh logic
                                if (AddedState.isAdded) {
                                  AddedState.isAdded = false;
                                  combinedFuture = Future.wait([
                                    DataFetcher.fetchBooks(book_id),
                                    DataFetcher.fetchReviews(book_id)
                                  ]);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Review added successfully!"),
                                    ),
                                  );
                                }
                              });
                            }
                          });
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage(
                                      title: "Login",
                                    )),
                          );
                        }
                      },
                      child: const Text('Add Review', 
                                        style: TextStyle(fontFamily: "Poppins", 
                                                        fontSize: 16,
                                                        color: Color(0xFFDDDDDD),
                                                        fontWeight: FontWeight.bold),),
                    );

                    Widget filterButton = ElevatedButton(
                      onPressed: _showMultiSelect,
                      style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF105857)), // Change the color as needed
                            ),
                      child: const Text('Rating Filter', 
                                        style: TextStyle(fontFamily: "Poppins", 
                                                        fontSize: 16,
                                                        color: Color(0xFFDDDDDD),
                                                        fontWeight: FontWeight.bold),),
                    );
                    print(_selectedItems);
                    ratingSelected = extractNumericValues(_selectedItems);

                    // Display review items for the remaining items in the list
                    List<Widget> reviewItems = List.generate(
                      reviews.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFFDDDDDD),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                                UserLoggedIn.user.role == "admin" ?
                                GestureDetector(
                                  onTap: () async{
                                    deleteReview(reviews[index].pk);
                                    setState(() {});
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ShowReview(
                                                book_id: BookState.bookId,
                                              )
                                        ),
                                    );
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red, // Set your desired color
                                    size: 24.0, // Set your desired size
                                  ),
                                ) : Container(),
                              ]
                            ),
                            Text(
                              "${reviews[index].fields.reviewerName}",
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Poppins",
                              ),
                            ),
                            const SizedBox(height: 6),
                            RatingBarIndicator(
                              rating:
                                  reviews[index].fields.reviewScore.toDouble(),
                              itemBuilder: (context, index) => FaIcon(
                                FontAwesomeIcons.solidStar,
                                color: Color.fromARGB(255, 255, 207,
                                    63), // Adjust the opacity for partial stars
                                size: 20.0,
                              ),
                              itemCount: 5,
                              itemSize: 18,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${reviews[index].fields.reviewSummary}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Poppins",
                              ),
                            ),
                            const SizedBox(height: 8),
                            ReadMoreText(
                              "${reviews[index].fields.reviewText}",
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w200,
                                ),
                              trimLines: 3,
                              colorClickableText:
                                  Color.fromARGB(255, 63, 101, 240),
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'Read more',
                              trimExpandedText: '\nRead less',
                              lessStyle: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 63, 101, 240)),
                              moreStyle: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 63, 101, 240)),
                            ),
                            const SizedBox(height: 15),
                            // 'dd MMMM yyyy "at" h:mm a'
                            Text(
                                "${DateFormat('dd MMMM yyyy').format(reviews[index].fields.reviewDate)} at ${DateFormat('h:mm a').format(reviews[index].fields.reviewDate)}",
                                style: TextStyle(fontFamily: "Poppins", 
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.normal))
                          ],
                        ),
                      ),
                    );

                    List<Widget> filteredReviewItems =
                        reviewItems.where((reviewWidget) {
                      int reviewScore = reviews[reviewItems.indexOf(reviewWidget)]
                          .fields
                          .reviewScore
                          .toInt();
                      return ratingSelected.contains(reviewScore);
                    }).toList();

                    

                    Widget reviewPage;

                    if (reviews.length == 0) {
                      reviewPage = Column(
                        children: [
                          bookDetails,
                          // addReviewButton,
                          SizedBox(height: 8),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xFFDDDDDD)),
                            // color: Color.fromARGB(255, 173, 175, 170), // Set the background color of the container
                            child: Text(
                              "No reviews yet, be the first to review!",
                              style: TextStyle(
                                color: Colors.black, // Set the text color
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                        ],
                      );
                    } else {
                      reviewPage = Column(
                      children: [
                        bookDetails,
                        // addReviewButton,
                        filterButton,
                        SizedBox(height: 8),
                        ...filteredReviewItems,
                        const SizedBox(height: 25),
                      ],
                    );

                    } 

                    // Combine book details and review items in the Column
                    return reviewPage;
                  }
                },
              ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog<String>(
            context: context,
              builder: (BuildContext context) => ReviewDialog(
                book_id: BookState.bookId,
              book_title: BookState.bookTitle
              ),
          ).then((result) {
                          if (result == null) {
                            setState(() {
                              // Your refresh logic
                              if (AddedState.isAdded) {
                                AddedState.isAdded = false;
                                combinedFuture = Future.wait([
                                  DataFetcher.fetchBooks(book_id),
                                  DataFetcher.fetchReviews(book_id)
                                ]);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Review added successfully!"),
                                  ),
                                );
                              }
                            });
                          }
                        });;
        },
        child: const Icon(Icons.add),
        backgroundColor: Color(0xFF105857),
        foregroundColor: Colors.white,
        shape: CircleBorder(),
      ),
    );
  }  
}
