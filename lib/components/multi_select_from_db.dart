// Multi Select widget
// This widget is reusable(hardly)
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class MultiSelectFromDB extends StatefulWidget {
  final String dbKey;
  const MultiSelectFromDB({Key? key, required this.dbKey}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectFromDBState();
}

class _MultiSelectFromDBState extends State<MultiSelectFromDB> {
  // this variable holds the selected items
  final List<String> _selectedItems = [];
  late final DatabaseReference _tagsRef;

  @override
  void initState() {
    super.initState();
    _tagsRef = FirebaseDatabase.instance.ref().child(widget.dbKey);
  }

  Widget _buildFirebaseList() {
    return SizedBox(
        height: 300,
        width: 300,
        child: FirebaseAnimatedList(
          query: _tagsRef,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            String tag = snapshot.value as String;
            return CheckboxListTile(
              value: _selectedItems.contains(tag),
              title: Text(tag),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (isChecked) => _itemChange(tag, isChecked!),
            );
          },
        ));
  }

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Top tags'),
      content: _buildFirebaseList(),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
