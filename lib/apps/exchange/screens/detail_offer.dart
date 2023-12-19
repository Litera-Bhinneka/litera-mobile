import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:litera_mobile/apps/authentication/models/User.dart';
import 'package:litera_mobile/apps/exchange/models/InventoryBook.dart';
import 'package:litera_mobile/apps/exchange/models/Offer.dart';
import 'package:litera_mobile/components/head.dart';
import 'package:litera_mobile/main.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class DetailOfferPage extends StatefulWidget {
  final Offer offer;

  const DetailOfferPage({super.key, required this.offer});

  @override
  State<DetailOfferPage> createState() => _DetailOfferPageState();
}

class _DetailOfferPageState extends State<DetailOfferPage> {
  Future<List<List<InventoryBook>>> fetchInventories() async {
    var url = Uri.parse(
        'https://litera-b06-tk.pbp.cs.ui.ac.id/exchange/detail-offer-flutter/${widget.offer.pk}/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    // melakukan konversi data json menjadi object Product
    List<InventoryBook> first_inventory = [], second_inventory = [];
    for (var d in data["inventory1"]) {
      if (d != null) {
        first_inventory.add(InventoryBook.fromJson(d));
      }
    }
    for (var d in data["inventory2"]) {
      if (d != null) {
        second_inventory.add(InventoryBook.fromJson(d));
      }
    }
    return [first_inventory, second_inventory];
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: const Color.fromRGBO(202, 209, 218, 1),
      body: FutureBuilder(
        future: fetchInventories(),
        builder: (context, AsyncSnapshot<List<List<InventoryBook>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'No inventory data available.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                ),
              ),
            );
          } else {
            List<InventoryBook> firstInventory = snapshot.data![0];
            List<InventoryBook> secondInventory = snapshot.data![1];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const MyHeader(height: 86),
                const SizedBox(height: 11),
                // Display text above the first inventory
                if (widget.offer.fields.username1 ==
                        UserLoggedIn.user.username ||
                    UserLoggedIn.user.role == "admin") ...[
                  Text(
                    "${widget.offer.fields.username2} Offered:",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins'),
                    textAlign: TextAlign.center,
                  ),
                ] else ...[
                  const Text(
                    'You Offered:',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins'),
                    textAlign: TextAlign.center,
                  ),
                ],

                // Display the first inventory vertically
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 154, 161, 171),
                      border: Border.all(
                        color: Colors.black, // Set the color of the border
                        width: 0.5, // Set the width of the border
                      ),
                    ),
                    // padding: EdgeInsets.all(2.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 0,
                      ),
                      itemCount: firstInventory.length,
                      itemBuilder: (context, index) {
                        InventoryBook book = firstInventory[index];
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
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Add spacing between the sections
                const SizedBox(height: 16.0),
                // Display text above the second inventory

                if (widget.offer.fields.username1 ==
                    UserLoggedIn.user.username) ...[
                  const Text(
                    'For Your:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ] else ...[
                  Text(
                    'For ${widget.offer.fields.username1}\'s:',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],

                // Display the second inventory vertically
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 154, 161, 171),
                      border: Border.all(
                        color: Colors.black, // Set the color of the border
                        width: 0.5, // Set the width of the border
                      ),
                    ),
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 0,
                      ),
                      itemCount: secondInventory.length,
                      itemBuilder: (context, index) {
                        InventoryBook book = secondInventory[index];
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
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Add spacing between the sections
                const SizedBox(height: 16.0),
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 11),
                    if (widget.offer.fields.username1 ==
                            UserLoggedIn.user.username ||
                        UserLoggedIn.user.role == "admin") ...[
                      ElevatedButton(
                        onPressed: () async {
                          // Handle accept button press
                          final response = await request.postJson(
                              "https://litera-b06-tk.pbp.cs.ui.ac.id/exchange/accept-offer-flutter/",
                              jsonEncode(<String, int>{
                                'id': widget.offer.pk,
                              }));
                          if (response['status'] == 200) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                'Exchange successful. Your Inventory has been updated',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ));
                          } else if (response['status'] == 404 &&
                              response['message'].contains('user')) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                'Inventory not found for the specified book and user',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ));
                          } else if (response['status'] == 404) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                'The specified book is not found.',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ));
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                'Invalid request method',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ));
                          }
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyHomePage(title: "LITERA"),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF105857),
                        ),
                        child: const Text(
                          'Accept',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 11),
                      ElevatedButton(
                        onPressed: () async {
                          // Handle reject button press
                          final response = await request.postJson(
                              "https://litera-b06-tk.pbp.cs.ui.ac.id/exchange/delete-offer-flutter/",
                              jsonEncode(<String, int>{
                                'id': widget.offer.pk,
                              }));
                          if (response['status'] == 200) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                'Successfully removed the Offer',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ));
                          } else if (response['status'] == 404) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                'Offer does not exist',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ));
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                'Invalid request method',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ));
                          }
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyHomePage(title: "LITERA"),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text(
                          'Reject',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ] else ...[
                      ElevatedButton(
                        onPressed: () async {
                          // Handle cancel button press
                          final response = await request.postJson(
                              "https://litera-b06-tk.pbp.cs.ui.ac.id/exchange/delete-offer-flutter/",
                              jsonEncode(<String, int>{
                                'id': widget.offer.pk,
                              }));
                          if (response['status'] == 200) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                'Successfully removed the Offer',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ));
                          } else if (response['status'] == 404) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                'Offer does not exist',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ));
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                'Invalid request method',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ));
                          }
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyHomePage(title: "LITERA"),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Cancel',
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'Poppins')),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16.0),
              ],
            );
          }
        },
      ),
    );
  }
}
