import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:networking_app/components/contacts.dart';
import 'package:random_avatar/random_avatar.dart';
import '../db/dto/person_dto.dart';
import '../db/firebase/controllers/firebase_user_controller.dart';

class Person extends StatefulWidget {
  final String userID;
  const Person({super.key, required this.userID});

  @override
  State<Person> createState() => _PersonState();
}

class _PersonState extends State<Person> {
  // * Friend status
  // TODO: Implement friend status check
  late final Query _dbRef;
  late final PersonDTO? _personData;
  bool _isFriend = false;
  bool _hasData = false;
  bool _userNotFound = false;
  bool _transparentBg = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _dbRef = FirebaseDatabase.instance.ref().child('users/${widget.userID}');
    _dbRef.once().then((DatabaseEvent event) {
      // * a bit lazy way to get single user data
      if (event.snapshot.value != null) {
        Map data = event.snapshot.value as Map;
        data['key'] = event.snapshot.key;
        _getIsFriend();
        setState(() {
          try {
            _personData = PersonDTO.fromSnapshot(data);
            _hasData = true;
          } catch (e) {
            setState(() {
              _userNotFound = true;
              _errorMessage = e.toString();
            });
          }
        });
      } else {
        setState(() {
          _userNotFound = true;
        });
      }
    });
  }

  void _getIsFriend() async {
    bool isFriend = await FirebaseUserController().isFriend(widget.userID);
    setState(() {
      _isFriend = isFriend;
      if (isFriend) {
        _transparentBg = false;
      }
    });
  }

  // * Avatar
  Widget _avatar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
        width: 100,
        height: 100,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: CircleAvatar(
          backgroundColor: Colors.grey[700],
          child: RandomAvatar(
            _getAvatarSeed(_personData?.avatar, _personData?.email),
            trBackground: _transparentBg,
          ),
        ),
      ),
    );
  }

// * User Name
  Widget _userName() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      child: Text(
        _personData?.name ?? 'Name',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 26,
        ),
      ),
    );
  }

// * Settings Button

  // * About Me title
  Widget _aboutMeTitle() {
    return const Text(
      'About me:',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }

// * Bio
  Widget _bio() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        _personData?.bio ?? 'Bio',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildActionButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: SizedBox(
        width: 170.0,
        child: ElevatedButton(
          onPressed: _handleFriendButtonClick,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_isFriend ? 'Remove Friend' : 'Add Friend'),
              const SizedBox(width: 10),
              Icon(_isFriend ? Icons.remove_circle : Icons.add_circle),
            ],
          ),
        ),
      ),
    );
  }

// * Card with bio
  Widget _bioCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        child: SizedBox(
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _aboutMeTitle(),
                  _bio(),
                ],
              ),
            )),
      ),
    );
  }

  Widget _buildUserNotFound() {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height / 3),
        _errorMessage != null
            ? Text(_errorMessage!)
            : const Text("User not found"),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Back'),
        ),
      ],
    );
  }

  String _getAvatarSeed(avatar, email) {
    if (avatar == null || avatar.isEmpty || avatar == ' ') {
      return email ?? 'Should not be empty or null by now';
    }
    return avatar;
  }

  void _handleFriendButtonClick() async {
    if (_isFriend) {
      await FirebaseUserController().removeFriend(widget.userID);
      setState(() {
        _isFriend = false;
        _transparentBg = true;
      });
    } else {
      await FirebaseUserController().addFriend(widget.userID);
      setState(() {
        _isFriend = true;
        _transparentBg = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasData) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: _userNotFound
              ? _buildUserNotFound()
              : const CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Major: ${_personData?.major ?? 'Unknown'}'),
      ),
      body: ListView(
        children: [
          Center(
            child: Column(
              children: [
                _avatar(),
                _userName(),
                _buildActionButton(),
                _bioCard(),
                Contacts(contacts: _personData?.contactList ?? []),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
