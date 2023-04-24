import 'package:flutter/material.dart';

class Friends extends StatefulWidget {
  const Friends({Key? key}) : super(key: key);

  @override
  State<Friends> createState() => _FriendsState();
}

Widget _friendList() {
  return Card(
    clipBehavior: Clip.hardEdge,
    child: InkWell(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const <Widget>[
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Name'),
            subtitle: Text('Speciality'),
          )
        ],
      ),
    ),
  );
}

class _FriendsState extends State<Friends> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            _friendList(),
          ],
        ),
      ),
    );
  }
}
