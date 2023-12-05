import 'package:flutter/material.dart';
import 'package:litera_mobile/apps/recommendation/screens/show_recommend.dart';
import 'package:litera_mobile/main.dart';

class MyHeader extends StatelessWidget {
  const MyHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
          width: double.infinity,
          height: 86,
          decoration: const ShapeDecoration(
              color: Color(0xFF105857),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                  ),
              ),
          ),
          padding: EdgeInsets.only(top: 20),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage(title: "LITERA",)),
                    );
                  },
                  child: Image.asset(
                    'assets/litera_white.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage(title: "LITERA",)),
                    );
                  },
                  child: const Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      'LITERA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 45,
                        fontFamily: 'Jomhuria',
                        fontWeight: FontWeight.w400,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
      )
    );
  }
}