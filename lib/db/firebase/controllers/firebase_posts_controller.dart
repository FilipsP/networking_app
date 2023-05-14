import 'package:firebase_database/firebase_database.dart';
import 'package:networking_app/auth/auth.dart';
import 'package:uuid/uuid.dart';

class FirebasePostsController {
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  Future<void> likePost(String key) async {
    final Map<String, dynamic> updates = {};
    updates['/posts/$key/likes'] = ServerValue.increment(1);
    updates['/posts/$key/likedBy/${Auth().currentUser!.uid}'] = true;
    return FirebaseDatabase.instance.ref().update(updates);
  }

  Future<void> unlikePost(String key) async {
    final Map<String, dynamic> updates = {};
    updates['/posts/$key/likes'] = ServerValue.increment(-1);
    updates['/posts/$key/likedBy/${Auth().currentUser!.uid}'] = null;
    return FirebaseDatabase.instance.ref().update(updates);
  }

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

  Future<void> deletePost(String key) async {
    //TODO: Add an extra check to make sure the user is the author of the post
    return FirebaseDatabase.instance.ref().child('posts').child(key).remove();
  }

  Future<void> addComment(String postKey, String body) async {
    final Map<String, dynamic> commentData = {
      'userID': Auth().currentUser!.uid,
      'body': body,
      'time': DateTime.now().millisecondsSinceEpoch,
    };
    newKey() {
      return ref.child('posts/$postKey/comments').push().key;
    }

    final Map<String, Map> updates = {};
    updates['/posts/$postKey/comments/${newKey()}'] = commentData;
    return FirebaseDatabase.instance.ref().update(updates);
  }

  Future<void> deleteComment(String postKey, String commentKey) async {
    return FirebaseDatabase.instance
        .ref()
        .child('posts')
        .child(postKey)
        .child('comments')
        .child(commentKey)
        .remove();
  }
}
