import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:litera_mobile/apps/authentication/models/User.dart';
import 'package:litera_mobile/apps/exchange/models/Owner.dart';
import 'package:litera_mobile/apps/exchange/screens/send_offer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ListOwners extends StatefulWidget {
  final int id;

  const ListOwners({super.key, required this.id});

  @override
  _ListOwnersState createState() => _ListOwnersState();
}

class _ListOwnersState extends State<ListOwners> {
  Future<List<Owner>> fetchProduct() async {
    var url = Uri.parse(
        'http://localhost:8000/exchange/get-owners-flutter/${widget.id}/${UserLoggedIn.user.username}/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Product
    List<Owner> list_owners = [];
    for (var d in data) {
      if (d != null) {
        list_owners.add(Owner.fromJson(d));
      }
    }
    return list_owners;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Exchange'),
        ),
        // drawer: const LeftDrawer(),
        body: FutureBuilder(
            future: fetchProduct(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text(
                      "There are no users with this book.",
                      style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                    ),
                  );
                } else {
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        "List of Owners",
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (_, index) => Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${snapshot.data![index].fields.username}",
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SendOfferPage(
                                                      username: snapshot
                                                          .data![index]
                                                          .fields
                                                          .username),
                                            ),
                                          );
                                        },
                                        child: const Text('Send Offer'),
                                      ),
                                    ],
                                  ),
                                )),
                      ),
                    ],
                  );
                }
              }
            }));
  }
}
