import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

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
