import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:litera_mobile/apps/authentication/models/User.dart';
import 'package:litera_mobile/apps/exchange/models/InventoryBook.dart';
import 'package:litera_mobile/apps/exchange/models/Offer.dart';
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
        'http://localhost:8000/exchange/detail-offer-flutter/${widget.offer.pk}/');
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
      appBar: AppBar(
        title: Text('Offer Details'),
      ),
      body: FutureBuilder(
        future: fetchInventories(),
        builder: (context, AsyncSnapshot<List<List<InventoryBook>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData) {
            return Center(
              child: Text('No inventory data available.'),
            );
          } else {
            List<InventoryBook> firstInventory = snapshot.data![0];
            List<InventoryBook> secondInventory = snapshot.data![1];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Display text above the first inventory
                if (widget.offer.fields.username1 ==
                    UserLoggedIn.user.username) ...[
                  Text(
                    "${widget.offer.fields.username2} Offered:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ] else ...[
                  Text(
                    'You Offered:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],

                // Display the first inventory vertically
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
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
                              Text('Amount: ${book.amount}'),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Add spacing between the sections
                SizedBox(height: 16.0),
                // Display text above the second inventory

                if (widget.offer.fields.username1 ==
                    UserLoggedIn.user.username) ...[
                  Text(
                    'For Your:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ] else ...[
                  Text(
                    'For ${widget.offer.fields.username1}\'s:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],

                // Display the second inventory vertically
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
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
                              Text('Amount: ${book.amount}'),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Add spacing between the sections
                SizedBox(height: 16.0),
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Back'),
                    ),
                    SizedBox(width: 11),
                    if (widget.offer.fields.username1 ==
                        UserLoggedIn.user.username) ...[
                      ElevatedButton(
                        onPressed: () async {
                          // Handle accept button press
                          final response = await request.postJson(
                              "http://localhost:8000/exchange/accept-offer-flutter/",
                              jsonEncode(<String, int>{
                                'id': widget.offer.pk,
                              }));
                          if (response['status'] == 200) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                  'Exchange successful. Your Inventory has been updated'),
                            ));
                          } else if (response['status'] == 404 &&
                              response['message'].contains('user')) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                  'Inventory not found for the specified book and user'),
                            ));
                          } else if (response['status'] == 404) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('The specified book is not found.'),
                            ));
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Invalid request method'),
                            ));
                          }
                          Navigator.pop(context);
                        },
                        child: Text('Accept'),
                      ),
                      SizedBox(width: 11),
                      ElevatedButton(
                        onPressed: () async {
                          // Handle reject button press
                          final response = await request.postJson(
                              "http://localhost:8000/exchange/delete-offer-flutter/",
                              jsonEncode(<String, int>{
                                'id': widget.offer.pk,
                              }));
                          if (response['status'] == 200) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Successfully removed the Offer'),
                            ));
                          } else if (response['status'] == 404) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Offer does not exist'),
                            ));
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Invalid request method'),
                            ));
                          }
                          Navigator.pop(context);
                        },
                        child: Text('Reject'),
                      ),
                    ] else ...[
                      ElevatedButton(
                        onPressed: () async {
                          // Handle cancel button press
                          final response = await request.postJson(
                              "http://localhost:8000/exchange/delete-offer-flutter/",
                              jsonEncode(<String, int>{
                                'id': widget.offer.pk,
                              }));
                          if (response['status'] == 200) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Successfully removed the Offer'),
                            ));
                          } else if (response['status'] == 404) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Offer does not exist'),
                            ));
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Invalid request method'),
                            ));
                          }
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 16.0),
              ],
            );
          }
        },
      ),
    );
  }
}
