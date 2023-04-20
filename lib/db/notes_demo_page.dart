import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:networking_app/db/firebase/firebase_posts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase/firebase_db_init.dart';

class NotesDemoPage extends StatefulWidget {
  const NotesDemoPage({super.key});
  @override
  State<NotesDemoPage> createState() => _NotesDemoPageState();
}

class _NotesDemoPageState extends State<NotesDemoPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<List<String>?> _notes;
  bool _firebaseNotes = false;

  Future<void> _addNote() async {
    final SharedPreferences prefs = await _prefs;
    final List<String> notes = prefs.getStringList('notes') ?? [];
    notes.add(DateTime.now().toString());

    setState(() {
      _notes = prefs.setStringList('notes', notes).then((bool success) {
        return notes;
      });
    });
  }

  Future<void> _writeNewPostToDB() async {
    final body = await _promptForNewNote();
    if (body != null) {
      await FirebaseDB().writeNewPost("Test", body);
    } else {
      if (kDebugMode) {
        print("body is null");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _notes = _prefs.then((SharedPreferences prefs) {
      return prefs.getStringList('notes');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _buildPageContent()),
      floatingActionButton:
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton(
          onPressed: _firebaseNotes ? _writeNewPostToDB : _addNote,
          tooltip: 'Add note',
          child: const Icon(Icons.edit),
        ),
        const SizedBox(height: 10),
        FloatingActionButton(
          onPressed: _clearNotes,
          tooltip: 'Clear notes',
          child: const Icon(Icons.delete),
        ),
        const SizedBox(height: 10),
        FloatingActionButton(
          onPressed: _switchFirebaseNotes,
          tooltip: 'Sync notes',
          child: const Icon(Icons.sync),
        ),
      ]),
    );
  }

  Widget _buildPageContent() {
    return _firebaseNotes ? const FirebasePosts() : _getNotesFutureBuilder();
  }

  Widget _getNotesFutureBuilder() {
    return FutureBuilder<List<String>?>(
        future: _notes,
        builder: (BuildContext context, AsyncSnapshot<List<String>?> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const CircularProgressIndicator();
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                if (snapshot.data == null) {
                  return _emptyNotes();
                } else {
                  return _buildNotesList(snapshot.data);
                }
              }
          }
        });
  }

  Widget _buildNotesList(notes) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return _notesContainer(notes![index], index);
      },
    );
  }

  Widget _emptyNotes() {
    return const Center(
      child: Text('No local notes'),
    );
  }

  Widget _notesContainer(String note, int index) {
    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: GestureDetector(
            onTap: () {},
            onLongPress: () {},
            child: Container(
              padding: const EdgeInsets.all(10),
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black54),
                borderRadius: BorderRadius.circular(10),
              ),
              height: 100,
              child: ListTile(
                //title: Text(note.name),
                subtitle: Text(note),
                leading: const Icon(Icons.event_note),
              ),
            )));
  }

  void _clearNotes() async {
    final SharedPreferences prefs = await _prefs;
    prefs.remove('notes');
    setState(() {
      _notes = Future.value(null);
    });
  }

  void _switchFirebaseNotes() {
    setState(() {
      _firebaseNotes = !_firebaseNotes;
    });
  }

  Future<String?> _promptForNewNote() async {
    //only asks for body of the post atm
    final controller = TextEditingController();
    return await showDialog<String?>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(children: const [
          Text('Add note', style: TextStyle(fontSize: 20)),
          Icon(Icons.note_alt_outlined)
        ]),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(controller.text);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
