import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class Person {
  // for testing without firebase
  late String name;
  late int profileImg; // selection from db
  //late String bio;

  Person(this.name, this.profileImg);
}

// 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque sit amet ante sem. Proin venenatis sodales erat non faucibus. Nullam eleifend diam nec ipsum venenatis, ut porttitor quam faucibus. In hac habitasse platea dictumst.'
var person = Person('John Doe', 2);

class _ProfileState extends State<Profile> {


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
                IconButton(
                  icon: const Icon(Icons.settings),
                  color: Colors.black,
                  onPressed: () {}, // edit profile img and bio (open window on top to change?)
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
                      child: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque sit amet ante sem. Proin venenatis sodales erat non faucibus. Nullam eleifend diam nec ipsum venenatis, ut porttitor quam faucibus. In hac habitasse platea dictumst.'), // Text('person.bio')
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
