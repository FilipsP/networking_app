import 'package:flutter/material.dart';
import 'package:networking_app/components/search_bar.dart';

class Friends extends StatefulWidget {
  const Friends({Key? key}) : super(key: key);

  @override
  State<Friends> createState() => _FriendsState();
}

class Friend {
  final String name;
  final String description;
  final String avatar;

  Friend({required this.name, required this.description, required this.avatar});
}

class _FriendsState extends State<Friends> {
  List<Friend> friends = [
    Friend(
        name: 'Longer Name',
        description: 'Mathematics',
        avatar: 'https://api.multiavatar.com/Binx Bond.png'),
    Friend(
        name: 'Name',
        description: 'Biology',
        avatar: 'https://api.multiavatar.com/Cardano.png'),
    Friend(
        name: 'LongerName andEvenLongerName',
        description: 'Computer Science',
        avatar: 'https://api.multiavatar.com/Charles Darwin.png'),
    Friend(
        name: 'Longer Name',
        description: 'Mathematics',
        avatar: 'https://api.multiavatar.com/Binx Bond.png'),
    Friend(
        name: 'Name',
        description: 'Biology',
        avatar: 'https://api.multiavatar.com/Cardano.png'),
    Friend(
        name: 'LongerName andEvenLongerName',
        description: 'Computer Science',
        avatar: 'https://api.multiavatar.com/Charles Darwin.png'),
    Friend(
        name: 'Longer Name',
        description: 'Mathematics',
        avatar: 'https://api.multiavatar.com/Binx Bond.png'),
    Friend(
        name: 'Name',
        description: 'Biology',
        avatar: 'https://api.multiavatar.com/Cardano.png'),
    Friend(
        name: 'LongerName andEvenLongerName',
        description: 'Computer Science',
        avatar: 'https://api.multiavatar.com/Charles Darwin.png'),
  ];

  Widget _friendsList(index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: Card(
          clipBehavior: Clip.hardEdge,
          elevation: 1,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.grey, width: 0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(friends[index].avatar),
            ),
            title: Text(friends[index].name),
            subtitle: Text(friends[index].description),
            onTap: () {},
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: const SearchBar(),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  return _friendsList(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
