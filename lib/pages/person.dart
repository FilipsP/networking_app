import 'package:flutter/material.dart';
import 'friends.dart';

class Person extends StatefulWidget {
  final Friend data;
  const Person({super.key, required this.data});

  @override
  State<Person> createState() => _PersonState();
}

class _PersonState extends State<Person> {
  // * Friend status
  // TODO: Implement friend status check
  bool _isFriend = true;

  // * Avatar
  Widget _avatar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
        width: 100,
        height: 100,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: CircleAvatar(
          backgroundImage: NetworkImage(widget.data.avatar),
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
        widget.data.name,
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
    return const Padding(
      padding: EdgeInsets.only(top: 10),
      child: Text(
        "Bio template",
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildActionButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: SizedBox(
        width: 170.0,
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              _isFriend = !_isFriend;
            });
          },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Major: ${widget.data.description}'),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
