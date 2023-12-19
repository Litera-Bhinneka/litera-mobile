// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:litera_mobile/apps/authentication/models/User.dart';
// import 'package:pbp_django_auth/pbp_django_auth.dart';
// import 'package:provider/provider.dart';

// class AddBook extends StatefulWidget {
//   const AddBook({Key? key});

//   @override
//   State<AddBook> createState() => _AddBookState();
// }

// class _AddBookState extends State<AddBook> {
//   final _formKey = GlobalKey<FormState>();
//   String _title = "";
//   String _imagelink = "";
//   String _description = "";
//   String _author = "";
//   String _category = "";
//   int _yearOfPublished = 0;

//   @override
//   Widget build(BuildContext context) {
//     final request = context.watch<CookieRequest>();
//     return Scaffold(
//       //drawer: const LeftDrawer(), // Tambahkan drawer yang sudah dibuat di sini
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                     hintText: "Judul Buku",
//                     labelText: "Judul buku",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(5.0),
//                     ),
//                   ),
//                   onChanged: (String? value) {
//                     setState(() {
//                       _title = value!;
//                     });
//                   },
//                   validator: (String? value) {
//                     if (value == null || value.isEmpty) {
//                       return "Judul tidak boleh kosong!";
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                     hintText: "Deskripsi Buku",
//                     labelText: "Deskripsi Buku",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(5.0),
//                     ),
//                   ),
//                   onChanged: (String? value) {
//                     setState(() {
//                       _description = value!;
//                     });
//                   },
//                   validator: (String? value) {
//                     if (value == null || value.isEmpty) {
//                       return "Deskripsi tidak boleh kosong!";
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                     hintText: "Penulis Buku",
//                     labelText: "Penulis Buku",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(5.0),
//                     ),
//                   ),
//                   onChanged: (String? value) {
//                     setState(() {
//                       _author = value!;
//                     });
//                   },
//                   validator: (String? value) {
//                     if (value == null || value.isEmpty) {
//                       return "Nama Penulis tidak boleh kosong!";
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                     hintText: "Kategori Buku",
//                     labelText: "Kategori Buku",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(5.0),
//                     ),
//                   ),
//                   onChanged: (String? value) {
//                     setState(() {
//                       _category = value!;
//                     });
//                   },
//                   validator: (String? value) {
//                     if (value == null || value.isEmpty) {
//                       return "Kategori buku tidak boleh kosong!";
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: ElevatedButton(
//                     style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all(Colors.indigo),
//                     ),
//                     // onPressed: () {
//                     //   if (_formKey.currentState!.validate()) {
//                     //     showDialog(
//                     //       context: context,
//                     //       builder: (context) {
//                     //         return AlertDialog(
//                     //           title: const Text('Produk berhasil tersimpan'),
//                     //           content: SingleChildScrollView(
//                     //             child: Column(
//                     //               crossAxisAlignment: CrossAxisAlignment.start,
//                     //               children: [
//                     //                 Text('Nama: $_name'),
//                     //                 Text('Harga: $_price'),
//                     //                 Text('Deskripsi: $_description'),
//                     //                 // Tambahkan value lainnya jika ada
//                     //               ],
//                     //             ),
//                     //           ),
//                     //           actions: [
//                     //             TextButton(
//                     //               child: const Text('OK'),
//                     //               onPressed: () {
//                     //                 Navigator.pop(context);
//                     //               },
//                     //             ),
//                     //           ],
//                     //         );
//                     //       },
//                     //     );
//                     //     _formKey.currentState!.reset();
//                     //   }
//                     // },
//                     onPressed: () async {
//                       if (_formKey.currentState!.validate()) {
//                         // Kirim ke Django dan tunggu respons
//                         // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
//                         final response = await request.postJson(
//                             "http://localhost:8000/catalog/create-flutter/",
//                             jsonEncode(<String, String>{
//                               'name': _name,
//                               'ammount': _ammount.toString(),
//                               'price': _price.toString(),
//                               'description': _description,
//                               // TODO: Sesuaikan field data sesuai dengan aplikasimu
//                             }));
//                         if (response['status'] == 'success') {
//                           ScaffoldMessenger.of(context)
//                               .showSnackBar(const SnackBar(
//                             content: Text("Item baru berhasil disimpan!"),
//                           ));
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => MyHomePage()),
//                           );
//                         } else {
//                           ScaffoldMessenger.of(context)
//                               .showSnackBar(const SnackBar(
//                             content:
//                                 Text("Terdapat kesalahan, silakan coba lagi."),
//                           ));
//                         }
//                       }
//                     },
//                     child: const Text(
//                       "Save",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:litera_mobile/apps/catalog/screens/catalog.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class AddBook extends StatefulWidget {
  const AddBook({Key? key});

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _imageLink = "";
  String _description = "";
  String _author = "";
  String _category = "";
  int _yearOfPublished = 0;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: Color.fromRGBO(202, 209, 218, 1),
      appBar: AppBar(
        title: Text('Add Book'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Judul",
                    labelText: "Judul",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _title = value ?? "";
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Judul tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Link gambar buku",
                      labelText: "Link gambar buku",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _imageLink = value!;
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Link gambar buku tidak boleh kosong!";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Deskripsi Buku",
                      labelText: "Deskripsi Buku",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _description = value!;
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Deskripsi tidak boleh kosong!";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Penulis Buku",
                      labelText: "Penulis Buku",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _author = value!;
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Nama Penulis tidak boleh kosong!";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Kategori Buku",
                      labelText: "Kategori Buku",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _category = value!;
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Kategori buku tidak boleh kosong!";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Tahun Terbit Buku",
                      labelText: "Tahun Terbit Buku",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _yearOfPublished = int.parse(value!);
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Tahun terbit buku tidak boleh kosong!";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.indigo),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final response = await request.postJson(
                          "https://litera-b06-tk.pbp.cs.ui.ac.id/catalog/create-flutter/",
                          jsonEncode(<String, dynamic>{
                            'title': _title,
                            'imageLink': _imageLink,
                            'description': _description,
                            'author': _author,
                            'category': _category,
                            'yearOfPublished': _yearOfPublished.toString(),
                          }),
                        );
                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("New item successfully saved!"),
                            ),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => BookPage()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text("There was an error, please try again."),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
