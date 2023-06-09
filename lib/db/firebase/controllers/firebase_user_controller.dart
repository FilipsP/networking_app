import 'package:firebase_database/firebase_database.dart';

import '../../../auth/auth.dart';
import '../../dto/person_dto.dart';

class FirebaseUserController {
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  Future<PersonDTO?> getPersonData(String userID) async {
    return await ref.child('users/$userID').once().then((DatabaseEvent event) {
      if (event.snapshot.value == null) {
        return null;
      }
      Map data = event.snapshot.value as Map;
      data['key'] = event.snapshot.key;
      return PersonDTO.fromSnapshot(data);
    });
  }

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
      "avatarURL": email + DateTime.now().millisecondsSinceEpoch.toString(),
    };

    final Map<String, Map> updates = {};
    updates['/users/$uid'] = userData;

    return FirebaseDatabase.instance.ref().update(updates);
  }

  Future<void> updatePersonData(Map data) async {
    for (String key in data.keys) {
      ref.child('users/${Auth().currentUser!.uid}/$key').set(data[key]);
    }
  }
}
