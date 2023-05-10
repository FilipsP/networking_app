import 'package:firebase_database/firebase_database.dart';

import '../../../auth/auth.dart';

class FirebaseUserController {
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  Future<bool> isFriend(String userID) async {
    return await ref
        .child('users/${Auth().currentUser!.uid}/friends')
        .once()
        .then((DatabaseEvent event) {
      if (event.snapshot.value == null) {
        return false;
      }
      Map<dynamic, dynamic> data = event.snapshot.value as Map;
      List<String> keys = data.keys.cast<String>().toList();
      for (String key in keys) {
        if (key == userID) {
          return true;
        }
      }
      return false;
    });
  }

  Future<void> addFriend(String userID) async {
    final Map<String, bool> updates = {};
    //TODO: when adding a friend, add value false that represents a pending friend request
    //TODO: change on true when the friend accepts the request
    updates['/users/${Auth().currentUser!.uid}/friends/$userID'] = true;
    return FirebaseDatabase.instance.ref().update(updates);
  }

  Future<void> removeFriend(String userID) async {
    final Map<String, dynamic> updates = {};

    updates['/users/${Auth().currentUser!.uid}/friends/$userID'] = null;
    return FirebaseDatabase.instance.ref().update(updates);
  }

  Future<void> writeNewUser({
    required String uid,
    required String email,
  }) async {
    // A user entry.
    final Map<String, dynamic> userData = {
      "name": "",
      "email": email,
      "registrationTime": DateTime.now().millisecondsSinceEpoch,
      "posts": [],
      "major": "",
      "bio": "",
      "avatarURL": ""
    };

    final Map<String, Map> updates = {};
    updates['/users/$uid'] = userData;

    return FirebaseDatabase.instance.ref().update(updates);
  }
}
