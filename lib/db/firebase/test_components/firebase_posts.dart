import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FirebasePosts extends StatefulWidget {
  const FirebasePosts({super.key});

  @override
  State<FirebasePosts> createState() => _FirebasePostsState();
}

class _FirebasePostsState extends State<FirebasePosts> {
  final Query _postsRef =
      FirebaseDatabase.instance.ref().child('posts').orderByChild('time');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FirebaseAnimatedList(
          query: _postsRef,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map post = snapshot.value as Map;
            post['key'] = snapshot;
            return _postsContainer(post, index);
          },
        ),
      ),
    );
  }

  String _formatTime(int time) {
    return DateFormat('yMMMEd')
        .format(DateTime.fromMillisecondsSinceEpoch(time));
  }

  String _getLikes(int likes) {
    return '$likes ${likes > 1 || likes < 1 ? 'likes' : 'like'}';
  }

  Widget _postsContainer(Map post, int index) {
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
                title: Text(post['title'],
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.center),
                subtitle: Column(
                  children: [
                    Text(post['body']),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_getLikes(post['likes']),
                            style: const TextStyle(fontSize: 15)),
                        Text(_formatTime(post['time']),
                            style: const TextStyle(fontSize: 12),
                            textAlign: TextAlign.right),
                      ],
                    ),
                  ],
                ),
                leading: const Icon(Icons.note_alt_outlined, size: 40),
              ),
            )));
  }
}
