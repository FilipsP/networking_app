import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:networking_app/components/search_bar.dart';
import 'package:networking_app/pages/person.dart';
import '../auth/auth.dart';
import '../auth/components/sign_in_register.dart';
import '../db/dto/person_dto.dart';

class Friends extends StatefulWidget {
  const Friends({Key? key}) : super(key: key);

  @override
  State<Friends> createState() => _FriendsState();
}

//.endAt('$query\uf8ff')

class _FriendsState extends State<Friends> {
  //TODO: Hold the list of friends in the users database, compare them to all users by name, and display them in a list
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  late final DatabaseReference _friendsRef =
      _dbRef.child('users/${Auth().currentUser!.uid}/friends');
  final List<PersonDTO> _friends = [];
  List<PersonDTO> _filteredFriends = [];
  bool _isLookingForNewFriends = false;

  @override
  void initState() {
    super.initState();
    _friendsRef.once().then((DatabaseEvent event) {
      if (event.snapshot.value == null) {
        return;
      }
      Map<dynamic, dynamic> data = event.snapshot.value as Map;
      List<String> keys = data.keys.cast<String>().toList();
      _getFriends(keys);
    });
  }

  Future<void> _getFriends(keys) async {
    for (String key in keys) {
      _dbRef.child('users/$key').once().then((DatabaseEvent event) {
        if (event.snapshot.value == null) {
          return;
        }
        Map data = event.snapshot.value as Map;
        data['key'] = event.snapshot.key;
        _friends.add(PersonDTO.fromSnapshot(data));
        setState(() {
          _filteredFriends = _friends;
        });
      });
    }
  }

  Widget _buildListTile(index) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[300],
        backgroundImage: NetworkImage(_getURL(
            _filteredFriends[index].avatar, _filteredFriends[index].name)),
      ),
      title: Text(_filteredFriends[index].name),
      subtitle: Text(_filteredFriends[index].bio),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Person(
              authorId: _filteredFriends[index].key.toString(),
            ),
          ),
        );
      },
    );
  }

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
          child: _buildListTile(index),
        ));
  }

  String _getURL(String? avatar, String name) {
    if (avatar == null || avatar.isEmpty || avatar == ' ') {
      return "https://ui-avatars.com/api/?name=$name";
    }
    return avatar;
  }

  Widget _noFriendsFound() {
    return Column(children: const [
      SizedBox(height: 20),
      Text('No friends found', style: TextStyle(fontSize: 23.0)),
      SizedBox(height: 20),
    ]);
  }

  Widget _anonymous() {
    return Column(children: [
      const SizedBox(height: 40),
      const Text('You are not signed in',
          style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold)),
      const SizedBox(height: 30),
      TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SignInRegister(),
              ),
            );
          },
          child: const Text('Join to find friends together!',
              style: TextStyle(fontSize: 20.0))),
    ]);
  }

  Widget _buildTextButton() {
    if (_isLookingForNewFriends) {
      return TextButton(
          onPressed: () {
            setState(() {
              _isLookingForNewFriends = false;
              _filteredFriends = _friends;
            });
          },
          child:
              const Text('Find old friends', style: TextStyle(fontSize: 20.0)));
    }
    return TextButton(
        onPressed: () {
          setState(() {
            _isLookingForNewFriends = true;
            _filteredFriends = [];
          });
        },
        child:
            const Text('Find new friends', style: TextStyle(fontSize: 20.0)));
  }

  Widget _searchButton() {
    return ElevatedButton(
        onPressed: _handleNewFriendsSearchButtonClick,
        child: const Text('Search'));
  }

  void _handleSearch(String query) {
    if (_isLookingForNewFriends) {
      _handleNewFriendsSearch(query);
    } else {
      _handleOldFriendsSearch(query);
    }
  }

  void _handleOldFriendsSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredFriends = _friends;
      });
    } else {
      setState(() {
        _filteredFriends =
            _friends.where((friend) => friend.name.contains(query)).toList();
      });
    }
  }

  void _handleNewFriendsSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredFriends = [];
      });
    }
    query = query;
  }

  void _handleNewFriendsSearchButtonClick() {}

  @override
  Widget build(BuildContext context) {
    if (Auth().currentUser?.isAnonymous ?? false) {
      return _anonymous();
    }
    return SafeArea(
        child: Column(
      children: [
        AppBar(
          toolbarHeight: 70,
          title: SearchBar(callback: _handleSearch),
        ),
        Expanded(
          child: Center(
            child: Column(
              children: <Widget>[
                if (_filteredFriends.isEmpty && !_isLookingForNewFriends)
                  _noFriendsFound(),
                //_buildTextButton(),
                if (_isLookingForNewFriends) _searchButton(),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredFriends.length,
                    itemBuilder: (context, index) {
                      return _friendsList(index);
                    },
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ));
  }
}
