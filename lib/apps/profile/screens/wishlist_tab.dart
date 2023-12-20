import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:litera_mobile/apps/authentication/models/User.dart';
import 'package:litera_mobile/apps/catalog/models/Book.dart';
import 'package:litera_mobile/apps/profile/models/WishlistBook.dart';
import 'package:litera_mobile/components/head.dart';
import 'package:litera_mobile/main.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class WishlistService {
  
}

class WishlistTab extends StatefulWidget {
  @override
  _WishlistTabState createState() => _WishlistTabState();
}

class _WishlistTabState extends State<WishlistTab> {
  
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(202, 209, 218, 1),
      body: Center(
        child: Text(
          'This is a blank page.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
