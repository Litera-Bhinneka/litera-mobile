import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:litera_mobile/apps/authentication/models/User.dart';
import 'package:litera_mobile/apps/exchange/models/Offer.dart';
import 'package:litera_mobile/apps/exchange/screens/detail_offer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ListOffers extends StatefulWidget {
  const ListOffers({Key? key}) : super(key: key);

  @override
  _ListOffersState createState() => _ListOffersState();
}

class _ListOffersState extends State<ListOffers>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<List<List<Offer>>> fetchOffers() async {
    var url = Uri.parse(
        'http://localhost:8000/exchange/get-offers-flutter/${UserLoggedIn.user.username}/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    print(UserLoggedIn.user.username);
    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    // melakukan konversi data json menjadi object Product
    List<Offer> offers_sent = [], offers_received = [];
    for (var d in data["sent"]) {
      if (d != null) {
        offers_sent.add(Offer.fromJson(d));
      }
    }
    for (var d in data["received"]) {
      if (d != null) {
        offers_received.add(Offer.fromJson(d));
      }
    }
    print(offers_sent);
    print(offers_received);
    return [offers_sent, offers_received];
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exchange'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Sent'),
            Tab(text: 'Received'),
          ],
        ),
      ),
      body: FutureBuilder(
        future: fetchOffers(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            List<Offer> sent_offers = snapshot.data![0];
            List<Offer> received_offers = snapshot.data![1];

            return TabBarView(
              controller: _tabController,
              children: [
                // Sent offers tab
                sent_offers.isEmpty
                    ? Center(
                        child: Text('No sent offers.'),
                      )
                    : ListView.builder(
                        itemCount: sent_offers.length,
                        itemBuilder: (context, index) {
                          Offer sentOffer = sent_offers[index];

                          return ListTile(
                            title: Text('To: ${sentOffer.fields.username1}'),
                            // Add other UI elements based on your 'Offer' class

                            // Buttons for each sent offer
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    final response = await request.postJson(
                                        "http://localhost:8000/exchange/delete-offer-flutter/",
                                        jsonEncode(<String, int>{
                                          'id': sentOffer.pk,
                                        }));
                                    if (response['status'] == 200) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            'Successfully removed the Offer'),
                                      ));
                                      setState(() {});
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
                                  },
                                  child: Text('Cancel'),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DetailOfferPage(offer: sentOffer),
                                      ),
                                    );
                                  },
                                  child: Text('Details'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                // Received offers tab
                received_offers.isEmpty
                    ? Center(
                        child: Text('No received offers.'),
                      )
                    : ListView.builder(
                        itemCount: received_offers.length,
                        itemBuilder: (context, index) {
                          Offer receivedOffer = received_offers[index];

                          return ListTile(
                            title:
                                Text('From: ${receivedOffer.fields.username2}'),
                            // Add other UI elements based on your 'Offer' class

                            // Buttons for each received offer
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    final response = await request.postJson(
                                        "http://localhost:8000/exchange/accept-offer-flutter/",
                                        jsonEncode(<String, int>{
                                          'id': receivedOffer.pk,
                                        }));
                                    if (response['status'] == 200) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            'Exchange successful. Your Inventory has been updated'),
                                      ));
                                      setState(() {});
                                    } else if (response['status'] == 404 &&
                                        response['message'].contains('user')) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            'Inventory not found for the specified book and user'),
                                      ));
                                      setState(() {});
                                    } else if (response['status'] == 404) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            'The specified book is not found.'),
                                      ));
                                      setState(() {});
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text('Invalid request method'),
                                      ));
                                    }
                                  },
                                  child: Text('Accept'),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () async {
                                    final response = await request.postJson(
                                        "http://localhost:8000/exchange/delete-offer-flutter/",
                                        jsonEncode(<String, int>{
                                          'id': receivedOffer.pk,
                                        }));
                                    if (response['status'] == 200) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            'Successfully removed the Offer'),
                                      ));
                                      setState(() {});
                                    } else if (response['status'] == 404) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text('Offer does not exist'),
                                      ));
                                      setState(() {});
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text('Invalid request method'),
                                      ));
                                    }
                                  },
                                  child: Text('Reject'),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailOfferPage(
                                            offer: receivedOffer),
                                      ),
                                    );
                                  },
                                  child: Text('Details'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ],
            );
          }
        },
      ),
    );
  }
}
