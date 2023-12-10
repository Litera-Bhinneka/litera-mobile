// ignore_for_file: constant_identifier_names, use_build_context_synchronously
import 'dart:convert';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:litera_mobile/apps/authentication/pages/LoginPage.dart';
import 'package:litera_mobile/components/head.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  static const ROUTE_NAME = '/register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  String username = "";
  String password1 = "";
  String password2 = "";

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    Size size = MediaQuery.of(context).size;
    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.greenAccent, Colors.blueGrey])),
        child: Form(
          key: _formKey,
          child: Stack(
            children: [
              Scaffold(
                backgroundColor: Color.fromRGBO(202, 209, 218, 1),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      MyHeader(height: 130,),
                      const Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 24.0),
                        child: Center(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Register',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFF105857),
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          const Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 0.0),
                            child: Center(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Your Username',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Color(0xFF105857),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 34.0, vertical: 10.0),
                            child: TextFormField(
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                color: Color.fromARGB(255, 190, 174, 161)
                                ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromARGB(195, 246, 243, 243), // Set the background color here
                                hintText: " Masukkan Username",
                                labelText: " Username",
                                labelStyle:
                                    const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                      color:Color.fromARGB(255, 190, 174, 161)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Color.fromARGB(221, 210, 210, 209), width: 4.0),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Color.fromARGB(221, 210, 210, 209), width: 4.0),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    
                                hintStyle: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                      color:Color.fromARGB(255, 190, 174, 161)),
                              ),
                              onChanged: (String? value) {
                                setState(() {
                                  username = value!;
                                });
                              },
                              onSaved: (String? value) {
                                setState(() {
                                  username = value!;
                                });
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Username tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                          ),
                          const Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 0.0),
                            child: Center(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Your Password',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Color(0xFF105857),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 36.0, vertical: 10.0),
                            child: TextFormField(
                              obscureText: true,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                color: Color.fromARGB(255, 190, 174, 161)
                                ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromARGB(195, 246, 243, 243), // Set the background color here
                                hintText: " ● ● ● ● ●",
                                labelText: " Password",
                                labelStyle:
                                    const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                      color:Color.fromARGB(255, 190, 174, 161)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Color.fromARGB(221, 210, 210, 209), width: 4.0),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Color.fromARGB(221, 210, 210, 209), width: 4.0),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    
                                hintStyle: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                      color:Color.fromARGB(255, 190, 174, 161)),
                              ),
                              onChanged: (String? value) {
                                setState(() {
                                  password1 = value!;
                                });
                              },
                              onSaved: (String? value) {
                                setState(() {
                                  password1 = value!;
                                });
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Password tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                          ),
                          const Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 0.0),
                            child: Center(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Confirm Password',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Color(0xFF105857),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 36.0, vertical: 10.0),
                            child: TextFormField(
                              obscureText: true,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                color: Color.fromARGB(255, 190, 174, 161)
                                ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromARGB(195, 246, 243, 243), // Set the background color here
                                hintText: " ● ● ● ● ●",
                                labelText: " Konfirmasi Password",
                                labelStyle:
                                    const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                      color:Color.fromARGB(255, 190, 174, 161)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Color.fromARGB(221, 210, 210, 209), width: 4.0),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Color.fromARGB(221, 210, 210, 209), width: 4.0),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    
                                hintStyle: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                      color:Color.fromARGB(255, 190, 174, 161)),
                              ),
                              onChanged: (String? value) {
                                setState(() {
                                  password2 = value!;
                                });
                              },
                              onSaved: (String? value) {
                                setState(() {
                                  password2 = value!;
                                });
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Password tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Container(
                            height: size.height * 0.07,
                            width: size.width * 0.7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xFF105857),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2), // Shadow color
                                  spreadRadius: 2, // Spread radius
                                  blurRadius: 5, // Blur radius
                                  offset: Offset(0, 2), // Offset in the x, y direction
                                ),
                              ],
                            ),
                            child: TextButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  // Submit to Django server and wait for response
                                  final http.Response response = await http.post(
                                    Uri.parse("https://litera-b06-tk.pbp.cs.ui.ac.id/auth/register/"),
                                    headers: <String, String>{
                                      'Content-Type': 'application/json',
                                    },
                                    body: jsonEncode(<String, String>{
                                      'username': username,
                                      'password1': password1,
                                      'password2': password2,
                                    }),
                                  );

                                  if (response.statusCode == 200) {
                                    // Successful response
                                    final Map<String, dynamic> responseBody = jsonDecode(response.body);

                                    if (responseBody['status'] == 'success') {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Account has been successfully registered!"),
                                        ),
                                      );

                                      // Show a TextButton to navigate to the login page
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Registration Successful'),
                                          content: const Text('Account has been successfully registered!'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                // Navigate to the LoginPage when the "Login here" button is pressed
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => LoginPage(title: "Login",)),
                                                );
                                              },
                                              child: const Text('Login here'),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("An error occurred. Please try again."),
                                        ),
                                      );
                                    }
                                  } else {
                                    // Handle errors
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("HTTP ${response.statusCode}: There was an error on the server."),
                                      ),
                                    );
                                  }
                                }
                              },
                              child: const Text(
                                'Create an Account',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    color: Colors.white,
                                    height: 1.5,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          GestureDetector(
                            onTap: () {
                              // Route menu ke counter
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage(title: "Login")),
                              );
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1, color: Color.fromARGB(255, 152, 111, 248)))),
                              child: const Text(
                                'Already had an account? Login here',
                                style: TextStyle(
                                    fontSize: 18, color: Color(0xFF105857),),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}