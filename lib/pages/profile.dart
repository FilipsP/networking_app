import 'package:flutter/material.dart';
import '/components/settings.dart';

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
          onPressed: () {
            Navigator.of(context).restorablePush(_dialogBuilder); // open fullscreen dialog
          },
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

  TextEditingController _controller = TextEditingController(text: '${person.bio}');

  // Fullscreen dialog for settings
  static Route<Object?> _dialogBuilder(BuildContext context, Object? arguments) { // static doesn't allow changes
  return DialogRoute<void>(
    context: context,
    builder: (BuildContext context) {
      return Dialog.fullscreen(
        child:
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20.0, top: 40),
                child: MaterialButton(
                  onPressed: () {
                    showDialog( // Opens smaller dialog with options
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          title: Text('Select a profile image'),
                          children: <Widget>[ // Dialog has buttons as options that should represent profile images to choose
                            SimpleDialogOption(
                              onPressed: () {
                                // Do something
                              },
                              child: MaterialButton(
                                onPressed: () { // Choosing an image closes the dialog
                                  // save profile image function call should be here
                                  Navigator.pop(context);
                                },
                                color: Colors.blue,
                                padding: EdgeInsets.all(40),
                                shape: CircleBorder(),
                              ),
                            ),
                            SimpleDialogOption(
                              onPressed: () {
                                // Do something
                              },
                              child: MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                color: Colors.blue,
                                padding: EdgeInsets.all(40),
                                shape: CircleBorder(),
                              ),
                            ),
                            SimpleDialogOption(
                              onPressed: () {
                                // Do something
                              },
                              child: MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                color: Colors.blue,
                                padding: EdgeInsets.all(40),
                                shape: CircleBorder(),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  color: Colors.blue,
                  padding: EdgeInsets.all(50),
                  shape: CircleBorder(),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  // controller: _controller, // can't call _controller because of static
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Bio',
                  ),
                  onChanged: (value) {
                    // save bio text
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      style: TextButton.styleFrom(
                        textStyle: Theme.of(context).textTheme.labelLarge,
                      ),
                      child: const Text('Cancel'),
                      onPressed: () { // closes the fullscreen dialog
                        // should have discard changes function call here
                        Navigator.of(context).pop();
                      },
                    ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('Save'),
                    onPressed: () { //closes the fullscreen dialog
                      // save changes function call should be here
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
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
