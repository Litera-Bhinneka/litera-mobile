import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:litera_mobile/apps/profile/screens/inventory_tab.dart';
import 'package:litera_mobile/apps/profile/screens/wishlist_tab.dart';
import 'package:litera_mobile/components/head.dart';
import 'package:litera_mobile/apps/authentication/pages/LoginPage.dart';
import 'package:litera_mobile/apps/authentication/models/User.dart';

class ProfileWidget extends StatefulWidget {
  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(202, 209, 218, 1),
      body: Column(
        children: [
          // Your header widget
          MyHeader(height: 86),

          // Rest of the content
          if (UserLoggedIn.user.role == "guest")
            Expanded(
              child: Container(
                color: const Color.fromRGBO(202, 209, 218, 1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Color(0xFF105857),
                          fontSize: 20,
                          fontFamily: 'Poppins',
                        ),
                        children: [
                          const TextSpan(
                            text: "You must ",
                          ),
                          TextSpan(
                            text: "login",
                            style: const TextStyle(
                              decoration: TextDecoration
                                  .underline, // Add an underline decoration
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Navigate to the login page when tapped
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(
                                      title: "Login",
                                    ),
                                  ),
                                );
                              },
                          ),
                          const TextSpan(
                            text: " to use this feature.",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: Container(
                color: const Color.fromRGBO(202, 209, 218, 1),
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      labelColor: const Color(0xFF105857),
                      indicatorColor: const Color(0xFF105857),
                      unselectedLabelColor: Colors.black,
                      tabs: const [
                        Tab(
                          child: Text(
                            'Inventory',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Wishlist',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Inventory tab
                          InventoryTab(),

                          // Wishlist tab
                          WishlistTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}