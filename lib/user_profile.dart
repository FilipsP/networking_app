import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class Person { // for testing without firebase
  late String name;
  late int profileImg; // selection from db
  //late String bio;

  Person(this.name, this.profileImg);
}

var person = Person('Mary Many', 3);

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.black,
                  // backgroundImage: 2, // profile image here
                ),
              ),
            ),
            Text(
              '${person.name}',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {}, // add to friends
                  child: Text('Add'), // remove when already friends
                ),
              ],
            ),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              child: SizedBox(
                width: 350,
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                      child: Text(
                        'About me:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
                      child: Text('This is your bio'), // Text('person.bio')
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
