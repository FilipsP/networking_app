import 'package:firebase_database/firebase_database.dart';

class FirebaseUserController {
  DatabaseReference ref = FirebaseDatabase.instance.ref();
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
