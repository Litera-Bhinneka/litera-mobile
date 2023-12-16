import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:litera_mobile/apps/authentication/models/User.dart';
import 'package:litera_mobile/apps/exchange/models/Offer.dart';
import 'package:litera_mobile/apps/exchange/screens/detail_offer.dart';
import 'package:litera_mobile/components/head.dart';
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
        'https://litera-b06-tk.pbp.cs.ui.ac.id/exchange/get-offers-flutter/${UserLoggedIn.user.username}/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
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
    return [offers_sent, offers_received];
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: const Color.fromRGBO(202, 209, 218, 1),
      body: FutureBuilder(
        future: fetchOffers(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            List<Offer> sent_offers = snapshot.data![0];
            List<Offer> received_offers = snapshot.data![1];

            return Column(
              children: [
                const MyHeader(),
                TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(text: 'Sent'),
                    Tab(text: 'Received'),
                  ],
                ),
                Expanded(
                    child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Sent offers tab
                    sent_offers.isEmpty
                        ? const Center(
                            child: Text(
                              'No sent offers.',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: sent_offers.length,
                            itemBuilder: (context, index) {
                              Offer sentOffer = sent_offers[index];

                              return ListTile(
                                title: Row(
                                  children: [
                                    Container(
                                      width: 40.0, // Set your desired width
                                      height: 40.0, // Set your desired height
                                      child: ClipOval(
                                        child: Image.network(
                                          'https://media.discordapp.net/attachments/1054028087551078452/1167449134421254194/def.png?ex=658ec43b&is=657c4f3b&hm=96e12f02884650d2bac6e451822b9bf07e9b3d1772ac57804eda08c5f2a97f87&=&format=webp&quality=lossless&width=125&height=125',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      sentOffer.fields.username1,
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        final response = await request.postJson(
                                            "https://litera-b06-tk.pbp.cs.ui.ac.id/exchange/delete-offer-flutter/",
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
                                            content:
                                                Text('Offer does not exist'),
                                          ));
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content:
                                                Text('Invalid request method'),
                                          ));
                                        }
                                      },
                                      // child: Text('Cancel'),
                                      icon: const Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                      ),
                                      iconSize: 30,
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetailOfferPage(
                                                    offer: sentOffer),
                                          ),
                                        );
                                      },
                                      // child: Text('Details'),
                                      icon: const Icon(
                                        Icons.info_rounded,
                                        color: Colors.indigo,
                                      ),
                                      iconSize: 30,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                    // Received offers tab
                    received_offers.isEmpty
                        ? const Center(
                            child: Text(
                              'No received offers.',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: received_offers.length,
                            itemBuilder: (context, index) {
                              Offer receivedOffer = received_offers[index];

                              return ListTile(
                                title: Row(
                                  children: [
                                    Container(
                                      width: 40.0, // Set your desired width
                                      height: 40.0, // Set your desired height
                                      child: ClipOval(
                                        child: Image.network(
                                          'https://media.discordapp.net/attachments/1054028087551078452/1167449134421254194/def.png?ex=658ec43b&is=657c4f3b&hm=96e12f02884650d2bac6e451822b9bf07e9b3d1772ac57804eda08c5f2a97f87&=&format=webp&quality=lossless&width=125&height=125',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      receivedOffer.fields.username2,
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        final response = await request.postJson(
                                            "https://litera-b06-tk.pbp.cs.ui.ac.id/exchange/accept-offer-flutter/",
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
                                            response['message']
                                                .contains('user')) {
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
                                            content:
                                                Text('Invalid request method'),
                                          ));
                                        }
                                      },
                                      // child: Text('Accept'),
                                      icon: const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      ),
                                      iconSize: 30,
                                    ),
                                    // const SizedBox(width: 1),
                                    IconButton(
                                      onPressed: () async {
                                        final response = await request.postJson(
                                            "https://litera-b06-tk.pbp.cs.ui.ac.id/exchange/delete-offer-flutter/",
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
                                            content:
                                                Text('Offer does not exist'),
                                          ));
                                          setState(() {});
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content:
                                                Text('Invalid request method'),
                                          ));
                                        }
                                      },
                                      // child: Text('Reject'),
                                      icon: const Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                      ),
                                      iconSize: 30,
                                    ),
                                    // const SizedBox(width: 8),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetailOfferPage(
                                                    offer: receivedOffer),
                                          ),
                                        );
                                      },
                                      // style: ElevatedButton.styleFrom(
                                      //   padding: const EdgeInsets.symmetric(
                                      //       horizontal:
                                      //           10), // Set your desired padding here
                                      // ),
                                      // child: Row(
                                      //   children: [
                                      //     Text('Details'),
                                      //     SizedBox(width: 2),
                                      //     Icon(Icons.info_outlined),
                                      //   ],
                                      // )
                                      icon: const Icon(
                                        Icons.info_rounded,
                                        color: Colors.indigo,
                                      ),
                                      iconSize: 30,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ],
                ))
              ],
            );
          }
        },
      ),
    );
  }
}
