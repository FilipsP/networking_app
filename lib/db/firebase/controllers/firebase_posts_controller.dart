import 'package:firebase_database/firebase_database.dart';
import 'package:networking_app/auth/auth.dart';
import 'package:uuid/uuid.dart';

class FirebasePostsController {
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  Future<void> writeNewPost(
      {required String title,
      required String body,
      required int eventTime,
      required List<String> tags}) async {
    var uuid = const Uuid();
    // A post entry.
    final Map<String, dynamic> postData = {
      'author': Auth().currentUser!.displayName ?? Auth().currentUser!.email,
      'authorId': Auth().currentUser!.uid,
      'body': body,
      'title': title,
      'time': DateTime.now().millisecondsSinceEpoch,
      'eventTime': eventTime != 0 ? eventTime : null,
      'likes': 0,
      'tags': tags,
    };

    final Map<String, Map> updates = {};
    updates['/posts/${uuid.v4()}'] = postData;

    return FirebaseDatabase.instance.ref().update(updates);
  }
}
