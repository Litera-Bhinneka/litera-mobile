import 'package:flutter/material.dart';
import 'package:litera_mobile/apps/authentication/pages/RegisterPage.dart';
import 'package:litera_mobile/components/head.dart';
import 'package:litera_mobile/main.dart';
import 'package:provider/provider.dart';
import 'package:litera_mobile/components/Drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:litera_mobile/apps/authentication/models/User.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});
  final String title;
// @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text(title),
  //     ),
  //     drawer: buildDrawer(context),
  //     body: Center(
  //       child: Text('Login Page'),
  //       // MULAI KERJAIN DARI SINI YA
  //     ),
  //   );
  // }
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  void togglePasswordView() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  String username = "";
  String password1 = "";

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    // The rest of your widgets are down below
    Size size = MediaQuery.of(context).size;
    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.greenAccent, Colors.blueGrey])),
        child: Form(
            key: _loginFormKey,
            child: Stack(
              children: [
                Scaffold(
                  backgroundColor: Color.fromRGBO(202, 209, 218, 1),
                  body: SingleChildScrollView(
                      child: Column(
                    children: [
                      MyHeader(
                        height: 130,
                      ),
                      const Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 36.0, vertical: 24.0),
                        child: Center(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Login',
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 36.0, vertical: 0.0),
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
                                  color: Color.fromARGB(255, 190, 174, 161)),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromARGB(195, 246, 243,
                                    243), // Set the background color here
                                hintText: " Masukkan Username",
                                labelText: " Username",
                                labelStyle: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 190, 174, 161)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(221, 210, 210, 209),
                                      width: 4.0),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(221, 210, 210, 209),
                                      width: 4.0),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),

                                hintStyle: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 190, 174, 161)),
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
                            padding: const EdgeInsets.only(
                                left: 36.0,
                                right: 36.0,
                                top: 22.0,
                                bottom: 5.0),
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
                                  color: Color.fromARGB(255, 190, 174, 161)),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromARGB(195, 246, 243,
                                    243), // Set the background color here
                                hintText: " ● ● ● ● ●",
                                labelText: " Password",
                                labelStyle: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 190, 174, 161)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(221, 210, 210, 209),
                                      width: 4.0),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(221, 210, 210, 209),
                                      width: 4.0),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),

                                hintStyle: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 190, 174, 161)),
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
                              onPressed: () async {
                                final response = await request.login(
                                    "https://litera-b06-tk.pbp.cs.ui.ac.id/auth/login/",
                                    {
                                      'username': username,
                                      'password': password1,
                                    });
                                if (response['status']) {
                                  UserLoggedIn.user = (User(username));
                                  UserLoggedIn.user.role = response['role'];
                                  print(response['role']);

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Successfully logged in!"),
                                  ));
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MyHomePage(title: "LITERA")),
                                  );
                                  print(UserLoggedIn.user
                                      .username); // GET USERNAME OF LOGGED IN USER
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                        "An error occured, please try again."),
                                  ));
                                }
                              },
                              child: const Text(
                                'Login to Your Account',
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
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          // Route menu ke counter
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterPage()),
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
                            'Not registered? Create account',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF105857),
                            ),
                          ),
                        ),
                      ),
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
                      const SizedBox(
                        height: 35,
                      ),
                    ],
                  )),
                )
              ],
            )));
  }
}
