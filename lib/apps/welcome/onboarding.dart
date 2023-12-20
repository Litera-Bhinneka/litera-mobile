import 'package:flutter/material.dart';
import 'package:litera_mobile/apps/authentication/models/User.dart';
import 'package:litera_mobile/apps/authentication/pages/LoginPage.dart';
import 'package:litera_mobile/apps/authentication/pages/RegisterPage.dart';
import 'package:litera_mobile/components/logo_litera.dart';
import 'package:litera_mobile/main.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  
  @override
  Widget build (BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color:  Color.fromRGBO(202, 209, 218, 1),
        ),
        child: Column(
        children: [
          SizedBox(height: 30),
          MyLogoLitera(),
          Container(
            child: Image.asset(
            'assets/onboarding.png',
            width: 300,
            height: 250,
            // fit: BoxFit.contain,
          ),
          ),
          SizedBox(height: 50),
          Text(
            'Unlock Your Literacy Universe!',
            style: TextStyle(
            color: Color(0xFF143E3C),
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            height: 0,
            letterSpacing: 2,
            ),
          ),
          SizedBox(height: 40),
          Container(
            height: size.height * 0.07,
            width: size.width * 0.7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xFF105857),
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(0.2), // Shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 5, // Blur radius
                  offset: Offset(
                      0, 2), // Offset in the x, y direction
                ),
              ],
            ),
            child: TextButton(
              onPressed: () {
                // Route menu ke counter
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginPage(title: "Login",)),
                );
              },
              child: const Text(
                'Login',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    color: Colors.white,
                    height: 1.5,
                    fontWeight: FontWeight.bold
                    ),
              ),
            ),
          ),
          SizedBox(height: 30),
          Container(
            height: size.height * 0.07,
            width: size.width * 0.7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xFF105857),
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(0.2), // Shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 5, // Blur radius
                  offset: Offset(
                      0, 2), // Offset in the x, y direction
                ),
              ],
            ),
            child: TextButton(
              onPressed: () {
                // Route menu ke counter
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegisterPage()),
                );
              },
              child: const Text(
                'Register',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    color: Colors.white,
                    height: 1.5,
                    fontWeight: FontWeight.bold
                    ),
              ),
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              // Route menu ke counter
              UserLoggedIn.user.role = "guest";
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const MyHomePage(title: "LITERA")),
              );
            },
            child: Container(
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 1,
                          color:
                              Color.fromARGB(255, 152, 111, 248)))),
              child: const Text(
                'or sign in as a guest',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF105857),
                ),
              ),
            ),
          ),
          
        ],
      ),
        )
    );
  }
}