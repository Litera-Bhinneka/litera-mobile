import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:litera_mobile/apps/authentication/models/User.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class AddInventoryDialog extends StatefulWidget {
  final int bookId;

  const AddInventoryDialog({Key? key, required this.bookId}) : super(key: key);

  @override
  _AddInventoryDialogState createState() => _AddInventoryDialogState();
}

class _AddInventoryDialogState extends State<AddInventoryDialog> {
  String _inventoryName = ''; // Initialize with an empty string

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return AlertDialog(
      title: const Text('Add to Inventory'),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Do you want to add this book to your inventory?',
              style: TextStyle(
                fontSize: 13.0,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _inventoryName.isNotEmpty ? _inventoryName : null,
              items: ['Inventory 1', 'Inventory 2'] // Replace with your inventory names
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _inventoryName = value ?? '';
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select an inventory';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Select Inventory',
              ),
              isExpanded: true,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.2),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.indigo),
                  ),
                  onPressed: _inventoryName.isNotEmpty
                      ? () async {
                          final http.Response response = await http.post(
                            Uri.parse(
                                'https://litera-b06-tk.pbp.cs.ui.ac.id/manage-user/add-to-inventory-flutter/${widget.bookId}/'),
                            headers: <String, String>{
                              'Content-Type': 'application/json',
                            },
                            body: jsonEncode(<String, String>{
                              'inventory_name': _inventoryName,
                            }),
                          );

                          if (response.statusCode == 201) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Book added to inventory successfully'),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Failed to add book to inventory'),
                              ),
                            );
                          }

                          Navigator.pop(context);
                        }
                      : null,
                  child: const Text(
                    'Add to Inventory',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
