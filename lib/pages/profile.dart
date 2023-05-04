import 'package:flutter/material.dart';

import '../auth/components/auth_home.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class Person {
  final String name;
  final String avatar;
  final String bio;

  Person(this.name, this.avatar, this.bio);
}

final person = Person(
    'John Doe',
    'https://api.multiavatar.com/Charles Darwin.png',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec auc tor, odio eget ultricies aliquam, diam diam mattis nisl, eget ultricies diam diam nec nisl. Donec auctor, odio eget ultricies aliquam, diam diam mattis nisl, eget ultricies diam diam nec nisl.');

class _ProfileState extends State<Profile> {
  // * Avatar
  Widget _avatar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
        width: 100,
        height: 100,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: CircleAvatar(
          backgroundImage: NetworkImage(person.avatar),
        ),
      ),
    );
  }

// * User Name
  Widget _userName() {
    return Text(
      person.name,
      style: const TextStyle(
        fontSize: 26,
      ),
    );
  }

// * Settings Button
  Widget _settingsButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.settings),
          color: Colors.black,
          iconSize: 30,
          onPressed:
              () {}, // edit profile img and bio (open window on top to change?)
        ),
      ],
    );
  }

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
        person.bio,
        style: const TextStyle(fontSize: 16),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _avatar(),
                _userName(),
                _settingsButton(),
                _bioCard(),
                const AuthHome(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
