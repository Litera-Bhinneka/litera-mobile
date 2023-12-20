import 'package:flutter/material.dart';
import 'package:litera_mobile/apps/authentication/models/User.dart';
import 'package:litera_mobile/apps/exchange/models/InventoryBook.dart';
import 'package:http/http.dart' as http;
import 'package:litera_mobile/components/head.dart';
import 'package:litera_mobile/components/status.dart';
import 'package:litera_mobile/main.dart';
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
        'https://litera-b06-tk.pbp.cs.ui.ac.id/exchange/get-inventories-flutter/${UserLoggedIn.user.username}/${widget.username}/');
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
      backgroundColor: const Color.fromRGBO(202, 209, 218, 1),
      body: FutureBuilder(
        future: fetchInventories(),
        builder: (context, AsyncSnapshot<List<List<InventoryBook>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(
                fontFamily: 'Poppins',
              ),
            ));
          } else {
            List<InventoryBook> userInventory = snapshot.data![0];
            List<InventoryBook> targetInventory = snapshot.data![1];

            return Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const MyHeader(height: 86),
                const SizedBox(height: 11),
                InventoryColumn(
                  title: "Your Inventory",
                  inventory: userInventory,
                  target: selectedUserBooks,
                ),
                const SizedBox(height: 11),
                InventoryColumn(
                  title: "${widget.username}'s Inventory",
                  inventory: targetInventory,
                  target: selectedTargetBooks,
                ),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
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
                    ElevatedButton(
                      onPressed: () async {
                        final response = await request.postJson(
                            "https://litera-b06-tk.pbp.cs.ui.ac.id/exchange/create-offer-flutter/",
                            jsonEncode(<String, dynamic>{
                              'username2': UserLoggedIn.user.username,
                              'username1': widget.username,
                              'book2': selectedUserBooks,
                              'book1': selectedTargetBooks,
                            }));
                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                              'Successfully Created the Offer',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ));
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                              'An error has occured. Please try again',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ));
                        }
                        Status.currentPageIndex = 2;
                        Status.pointerPageIndex = 2;

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MyHomePage(title: "LITERA")),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF105857),
                      ),
                      child: const Text('Send Offer',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Poppins')),
                    ),
                  ],
                )),
                const SizedBox(height: 14)
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
      int id = -1;
      for (int i = 0; i < source.length; i++) {
        InventoryBook b = source[i];
        if (b.id == book.id && b.amount <= 1)
          id = i;
        else if (b.id == book.id) b.amount--;
      }
      if (id != -1) source.removeAt(id);
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
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    if (title.length > 14) title = title.substring(1, 14) + "...'s Inventory";
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: screenWidth * 0.025,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins'),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 154, 161, 171),
              border: Border.all(
                color: Colors.black,
              ),
            ),
            height: screenHeight * 0.35,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => onBookTap(inventory[index], inventory, target),
                  child: Card(
                    elevation: 0,
                    color: const Color.fromARGB(255, 154, 161, 171),
                    // shape: RoundedRectangleBorder(
                    //   side: BorderSide(color: Colors.black), // Set border color
                    // ),
                    // color: const Color(0xFF105857),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.network(
                            inventory[index].image,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text(
                          'Amount: ${inventory[index].amount}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.02,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 8),
        buildInventoryColumn(widget.title, widget.inventory, widget.target),
        const SizedBox(width: 4),
        buildInventoryColumn('Selected Books', widget.target, widget.inventory),
        const SizedBox(width: 8),
      ],
    );
  }
}
