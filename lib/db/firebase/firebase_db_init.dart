import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

class FirebaseDB {
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  Future<DataSnapshot> readPostsData() async {
    return await ref.child('posts').get();
  }

  Future<void> writeNewPost(String title, String body) async {
    var uuid = const Uuid();
    // A post entry.
    final postData = {
      'author': "Anonymous", //currentUser!.uid
      'postId': uuid.v4(),
      'body': body,
      'title': title,
      'time': DateTime.now().millisecondsSinceEpoch,
      'likes': 0,
      'tags': ['flutter', 'firestore'],
    };

    // Get a key for a new Post.
    final newPostKey =
        FirebaseDatabase.instance.ref().child('notes').push().key;

    final Map<String, Map> updates = {};
    updates['/posts/$newPostKey'] = postData;

    return FirebaseDatabase.instance.ref().update(updates);
  }
}
