import 'package:flutter/material.dart';
import 'package:litera_mobile/components/Drawer.dart';

class Authentication extends StatelessWidget {
  const Authentication({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text('Authentication'),
        // MULAI KERJAIN DARI SINI YA
      ),
    );
  }
}
