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
                  body: Column(
                    children: [
                      MyHeader(),
                      const Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
                        child: Center(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Login',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFF105857),
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                              'Your Username',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Color(0xFF105857),
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 10.0),
                            child: TextFormField(
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: "Masukkan Username",
                                labelText: "Username",
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                icon: const Icon(Icons.attach_email),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                                hintStyle: const TextStyle(color: Colors.white),
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
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 10.0),
                            child: TextFormField(
                              obscureText: true,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: "Masukkan Password",
                                labelText: "Password",
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                icon: const Icon(
                                  Icons.lock_outline,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                hintStyle: const TextStyle(color: Colors.white),
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
                            height: size.height * 0.08,
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: const Color(0xFF24262A),
                            ),
                            child: TextButton(
                              onPressed: () async {
                                final response = await request.login(
                                    "http://localhost:8000/auth/login/",
                                    {
                                      'username': username,
                                      'password': password1,
                                    });
                                if (response['status']) {
                                  UserLoggedIn.user = (User(username));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Successfully logged in!"),
                                  ));
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyHomePage(title: "LITERA")),
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
                                'Submit',
                                style: TextStyle(
                                    fontSize: 22,
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
                                      width: 1, color: Colors.white))),
                          child: const Text(
                            'Create New Account',
                            style: TextStyle(
                                fontSize: 22, color: Colors.white, height: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                    ],
                  ),
                )
              ],
            )));
  }
}