import 'package:flutter/material.dart';

class MultiSelect extends StatefulWidget {
  final List<String> items;
  final List<String> selectedItems;
  const MultiSelect({Key? key, required this.items, required this.selectedItems}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState(selectedItems: selectedItems);
}

class _MultiSelectState extends State<MultiSelect> {
  // this variable holds the selected items
  final List<String> selectedItems;

_MultiSelectState({required this.selectedItems});
// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedItems.add(itemValue);
      } else {
        selectedItems.remove(itemValue);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rating'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
                    value: selectedItems.contains(item),
                    title: Text(item),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) => _itemChange(item, isChecked!),
                  ))
              .toList(),
        ),
      ),
      actions: [
        ElevatedButton(
          style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Color(0xFF0F5756)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Adjust the radius as needed
                  ),
                )
              ),
          onPressed: _submit,
          child: Container(
                width: double.infinity, // Make the button span from left to right
                child: const Text(
                  "Apply",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
        ),
      ],
    );
  }
}