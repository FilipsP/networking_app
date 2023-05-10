// main.dart

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:networking_app/components/multi_select_from_db.dart';
import 'package:networking_app/db/firebase/controllers/firebase_posts_controller.dart';

// Implement a multi select on the Home screen
class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  List<String> _selectedItems = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  DateTime _dateTime = DateTime.fromMicrosecondsSinceEpoch(0);
  bool _dateAndTimeSelected = false;
  String _errorMessage = '';

  void _showMultiSelect() async {
    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const MultiSelectFromDB(dbKey: 'tags');
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        _selectedItems = results;
      });
    }
  }

  PlatformFile? pickedFile;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future<TimeOfDay?> _showTimePicker() => showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        helpText: 'AM - before noon\nPM - after noon',
      );

  Future<DateTime?> _showDatePicker() => showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2025),
      );

  Future dateAndTime() async {
    DateTime? date = await _showDatePicker();
    if (date == null) return;

    TimeOfDay? time = await _showTimePicker();
    if (time == null) return;
    _dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    setState(() {
      _dateAndTimeSelected = true;
    });
  }

  void _writePost() async {
    if (_titleController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please select a title';
      });
      return;
    }
    if (_contentController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please be sure to write something and be nice ;)';
      });
      return;
    }
    await FirebasePostsController()
        .writeNewPost(
          title: _titleController.text,
          body: _contentController.text,
          tags: _selectedItems,
          eventTime: _dateTime.millisecondsSinceEpoch,
        )
        .then((value) => Navigator.of(context).pop());
  }

  Widget _buildCreatePostContainer() {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 30),
        alignment: Alignment.center,
        child: Column(children: [
          if (_errorMessage.isNotEmpty)
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          ElevatedButton.icon(
            onPressed: _writePost,
            icon: const Icon(Icons.check),
            label: const Text('Create Post'),
          ),
        ]));
  }

  String _formatTime(int time) {
    return DateFormat('EEEE, dd MMMM, yyyy HH:mm')
        .format(DateTime.fromMillisecondsSinceEpoch(time));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Create Post'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Title",
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide:
                            const BorderSide(color: Colors.green, width: 2)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 2)),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: const BorderSide(
                            color: Colors.blueAccent, width: 2)),
                  ),
                ),
                Container(
                  height: 14,
                ),
                TextField(
                  controller: _contentController,
                  minLines: 2,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: 'Content',
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide:
                            const BorderSide(color: Colors.green, width: 2)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 2)),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: const BorderSide(
                            color: Colors.blueAccent, width: 2)),
                  ),
                ),
                Container(
                  height: 14,
                ),
                ElevatedButton(
                  onPressed: _showMultiSelect,
                  child: const Text('+ Add tags'),
                ),
                // display selected items
                Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: _selectedItems
                      .map((e) => Chip(
                            label: Text(e),
                          ))
                      .toList(),
                ),
                Container(
                  height: 14,
                ),

                // * Saved for better times
                // ElevatedButton(
                //   onPressed: selectFile,
                //   child: const Text('+ Add File'),
                // ),

                Container(
                  height: 14,
                ),
                ElevatedButton(
                    onPressed: dateAndTime,
                    child: const Text('+ Add Date&Time')),
                _dateAndTimeSelected == true
                    ? Text(_formatTime(_dateTime.millisecondsSinceEpoch))
                    : const Text(''),
                _buildCreatePostContainer(),
              ],
            ),
          ),
        ));
  }
}
