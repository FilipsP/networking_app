import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../auth/auth.dart';
import '../db/dto/person_dto.dart';
import '../db/firebase/controllers/firebase_user_controller.dart';

class Person extends StatefulWidget {
  final String authorId;
  const Person({super.key, required this.authorId});

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
  String? _errorMessage;
  final List<String> colors = [
    "F8B195",
    "F67280",
    "C06C84",
    "6C5B7B",
    "355C7D",
    "99B898",
    "FECEAB",
    "FF847C",
    "E84A5F",
    "2A363B"
  ];

  @override
  void initState() {
    super.initState();
    _dbRef = FirebaseDatabase.instance.ref().child('users/${widget.authorId}');
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
    bool isFriend = await FirebaseUserController().isFriend(widget.authorId);
    setState(() {
      _isFriend = isFriend;
    });
  }

  Widget _contacts() {
    List<dynamic>? contacts = _personData?.contactList;
    if (contacts == null) {
      return const SizedBox.shrink();
    }
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contacts:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            for (Map contact in contacts)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: contact['icon'],
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      onPressed: () => contact['callback'](contact['value']),
                      child: Text(contact['value']),
                    ),
                  ],
                ),
              ),
          ],
        ));
  }

  // * Avatar
  Widget _avatar() {
    String bgColor = colors[_getRandomNumber(0, colors.length)];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
        width: 100,
        height: 100,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: CircleAvatar(
          backgroundColor: bgColor.length == 6
              ? Color(int.parse('0xFF$bgColor'))
              : Colors.grey,
          backgroundImage: NetworkImage(_personData?.avatar ??
              "https://ui-avatars.com/api/?name=${_personData?.name}&background=$bgColor&size=128"),
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
            Navigator.pop(context);
          },
          child: const Text('Back'),
        ),
      ],
    );
  }

  int _getRandomNumber(int from, int to) {
    var random = Random();
    return random.nextInt(to - from) + from;
  }

  void _handleFriendButtonClick() async {
    if (_isFriend) {
      await FirebaseUserController().removeFriend(widget.authorId);
      setState(() {
        _isFriend = false;
      });
    } else {
      await FirebaseUserController().addFriend(widget.authorId);
      setState(() {
        _isFriend = true;
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
                _contacts(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
