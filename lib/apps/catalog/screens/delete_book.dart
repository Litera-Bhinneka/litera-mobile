import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeleteBookPage extends StatefulWidget {
  final int bookId;

  const DeleteBookPage({Key? key, required this.bookId}) : super(key: key);

  @override
  _DeleteBookPageState createState() => _DeleteBookPageState();
}

class _DeleteBookPageState extends State<DeleteBookPage> {
  Future<void> deleteBook() async {
    try {
      var url = Uri.parse(
          'https://litera-b06-tk.pbp.cs.ui.ac.id/catalog/delete_product_flutter/${widget.bookId}/');
      var response = await http.delete(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        // Delete successful
        Navigator.pop(context);
      } else {
        // Delete not successful
        print('Delete failed with status: ${response.statusCode}.');
        print('Response content: ${response.body}');
      }
    } catch (e) {
      print('Error deleting book: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Book'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: deleteBook,
          child: Text('Delete Book'),
        ),
      ),
    );
  }
}
