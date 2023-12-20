import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:litera_mobile/apps/authentication/models/User.dart';
import 'package:litera_mobile/apps/authentication/pages/LoginPage.dart';
import 'package:litera_mobile/apps/exchange/models/Owner.dart';
import 'package:litera_mobile/apps/exchange/screens/send_offer.dart';
import 'package:litera_mobile/components/head.dart';

class ListOwners extends StatefulWidget {
  final int id;

  const ListOwners({super.key, required this.id});

  @override
  _ListOwnersState createState() => _ListOwnersState();
}

class _ListOwnersState extends State<ListOwners> {
  Future<List<Owner>> fetchProduct() async {
    var url;
    if (UserLoggedIn.user.role != "guest") {
      url = Uri.parse(
          'https://litera-b06-tk.pbp.cs.ui.ac.id/exchange/get-owners-flutter/${widget.id}/${UserLoggedIn.user.username}/');
    } else {
      url = Uri.parse(
          'https://litera-b06-tk.pbp.cs.ui.ac.id/exchange/get-owners-flutter/${widget.id}/%/');
    }
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
        backgroundColor: const Color.fromRGBO(202, 209, 218, 1),
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
                      style: TextStyle(
                          color: Color(0xFF105857),
                          fontSize: 20,
                          fontFamily: 'Poppins'),
                    ),
                  );
                } else {
                  return Column(
                    children: [
                      const MyHeader(height: 86),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (_, index) => Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                // padding:
                                //     const EdgeInsets.symmetric(vertical: 4.0),
                                child: Container(
                                  // decoration: const BoxDecoration(
                                  //     border: Border(
                                  //   top: BorderSide(
                                  //     color: Color.fromRGBO(174, 191, 214, 1),
                                  //     width: 0.5,
                                  //   ),
                                  //   bottom: BorderSide(
                                  //     color: Color.fromRGBO(174, 191, 214, 1),
                                  //     width: 0.5,
                                  //   ),
                                  // )),
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(children: [
                                        Container(
                                          width: 50.0,
                                          height: 50.0,
                                          child: ClipOval(
                                            child: Image.network(
                                              'https://media.discordapp.net/attachments/1054028087551078452/1167449134421254194/def.png?ex=658ec43b&is=657c4f3b&hm=96e12f02884650d2bac6e451822b9bf07e9b3d1772ac57804eda08c5f2a97f87&=&format=webp&quality=lossless&width=125&height=125',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 11),
                                        if (snapshot
                                                .data![index].fields.username
                                                .toString()
                                                .length >
                                            18) ...[
                                          Text(
                                            snapshot.data![index].fields
                                                    .username
                                                    .toString()
                                                    .substring(1, 18) +
                                                "...",
                                            style: const TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Poppins',
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ] else ...[
                                          Text(
                                            snapshot
                                                .data![index].fields.username,
                                            style: const TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Poppins',
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ]
                                      ]),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (UserLoggedIn.user.role !=
                                              "guest") {
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
                                          } else {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LoginPage(
                                                        title: "Login",
                                                      )),
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF105857),
                                        ),
                                        child: const Text(
                                          'Send Offer',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ))),
                      ),
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
                      const SizedBox(height: 11),
                    ],
                  );
                }
              }
            }));
  }
}
