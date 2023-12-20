import 'package:flutter/material.dart';

class MyLogoLitera extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          child: Image.asset(
            'assets/litera_green.png',
            width: 130,
            height: 130,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 70),
        GestureDetector(
          child: const Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              'LITERA',
              style: TextStyle(
                color: Color(0xFF143E3C),
                fontSize: 100,
                fontFamily: 'Jomhuria',
                fontWeight: FontWeight.w400,
                letterSpacing: 2,
              ),
            ),
          ),
        )
      ],
    );
  }
}