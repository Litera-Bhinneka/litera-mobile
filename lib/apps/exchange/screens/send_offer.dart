import 'package:flutter/material.dart';
import 'package:litera_mobile/apps/authentication/models/User.dart';
import 'package:litera_mobile/apps/exchange/models/InventoryBook.dart';
import 'package:http/http.dart' as http;
import 'package:litera_mobile/apps/exchange/screens/list_offers.dart';
import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class SendOfferPage extends StatefulWidget {
  final String username;

  const SendOfferPage({super.key, required this.username});

  @override
  _SendOfferPageState createState() => _SendOfferPageState();
}

class _SendOfferPageState extends State<SendOfferPage> {
  List<InventoryBook> selectedUserBooks = [], selectedTargetBooks = [];

  Future<List<List<InventoryBook>>> fetchInventories() async {
    var url = Uri.parse(
        'http://localhost:8000/exchange/get-inventories-flutter/${UserLoggedIn.user.username}/${widget.username}/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Product
    List<InventoryBook> user_inventory = [], target_inventory = [];
    for (var d in data['user']) {
      if (d != null) {
        user_inventory.add(InventoryBook.fromJson(d));
      }
    }

    for (var d in data['target']) {
      if (d != null) {
        target_inventory.add(InventoryBook.fromJson(d));
      }
    }

    return [user_inventory, target_inventory];
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Offer to ${widget.username}'),
      ),
      body: FutureBuilder(
        future: fetchInventories(),
        builder: (context, AsyncSnapshot<List<List<InventoryBook>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            print('test');
            List<InventoryBook> userInventory = snapshot.data![0];
            List<InventoryBook> targetInventory = snapshot.data![1];

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InventoryColumn(
                  title: "Your Inventory",
                  inventory: userInventory,
                  target: selectedUserBooks,
                ),
                InventoryColumn(
                  title: "${widget.username}'s Inventory",
                  inventory: targetInventory,
                  target: selectedTargetBooks,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Back'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final response = await request.postJson(
                            "http://localhost:8000/exchange/create-offer-flutter/",
                            jsonEncode(<String, dynamic>{
                              'username2': UserLoggedIn.user.username,
                              'username1': widget.username,
                              'book2': selectedUserBooks,
                              'book1': selectedTargetBooks,
                            }));
                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Successfully Created the Offer'),
                          ));
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content:
                                Text('An error has occured. Please try again'),
                          ));
                        }
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ListOffers()),
                        );
                        print(response);
                      },
                      // onPressed: () {
                      //   print(selectedUserBooks);
                      //   print(selectedTargetBooks);
                      // },
                      child: Text('Send Offer'),
                    ),
                  ],
                )
              ],
            );
          }
        },
      ),
    );
  }
}

class InventoryColumn extends StatefulWidget {
  final String title;
  final List<InventoryBook> inventory;
  final List<InventoryBook> target;

  const InventoryColumn({
    required this.title,
    required this.inventory,
    required this.target,
  });

  @override
  _InventoryColumnState createState() => _InventoryColumnState();
}

class _InventoryColumnState extends State<InventoryColumn> {
  void onBookTap(InventoryBook book, List<InventoryBook> source,
      List<InventoryBook> target) {
    setState(() {
      for (InventoryBook b in source) {
        if (b.id == book.id && b.amount <= 1)
          source.remove(b);
        else if (b.id == book.id) b.amount--;
      }
      bool ok = false;
      for (InventoryBook b in target) {
        if (b.id == book.id) {
          b.amount++;
          ok = true;
        }
      }
      if (!ok) {
        InventoryBook copy = InventoryBook(
            id: book.id, title: book.title, image: book.image, amount: 1);
        target.add(copy);
      }
    });
  }

  Widget buildInventoryColumn(
      String title, List<InventoryBook> inventory, List<InventoryBook> target) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Container(
            height: 250, // Set the height of the grid as needed
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Adjust the cross axis count as needed
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => onBookTap(inventory[index], inventory, target),
                  child: Card(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.network(
                            inventory[index].image,
                            height: 50,
                            width: 40,
                            fit: BoxFit.cover,
                          ),
                          Text('Amount: ${inventory[index].amount}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: inventory.length,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildInventoryColumn(widget.title, widget.inventory, widget.target),
        buildInventoryColumn('Selected Books', widget.target, widget.inventory),
      ],
    );
  }
}
