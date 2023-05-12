import 'package:flutter/material.dart';
import 'package:networking_app/auth/auth.dart';
import 'package:networking_app/db/dto/person_dto.dart';
import 'package:networking_app/db/firebase/controllers/firebase_user_controller.dart';

import '../auth/components/auth_home.dart';
import 'profile_settings.dart';
import 'package:random_avatar/random_avatar.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  PersonDTO? _personalData;

  @override
  void initState() {
    super.initState();
    _getPersonalData();
  }

  void _getPersonalData() async {
    PersonDTO? personalData =
        await FirebaseUserController().getPersonData(Auth().currentUser!.uid);
    setState(() {
      _personalData = personalData;
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
          child: _buildAvatarImage()),
    );
  }

  Widget _buildAvatarImage() {
    if (_personalData?.avatar != '') {
      return CircleAvatar(
          radius: 50, child: RandomAvatar(_personalData!.avatar!));
    }
    return CircleAvatar(
      radius: 50,
      backgroundImage: NetworkImage(_imageString()),
    );
  }

// * User Name
  Widget _userName() {
    return Text(
      _personalData?.name ?? Auth().currentUser!.email!.split('@')[0],
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProfileSettings(personalData: _personalData),
              ),
            );
          }, // edit profile img and bio (open window on top to change?)
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
        _personalData?.bio ?? 'Nothing to see here',
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

  String _imageString() {
    if (_personalData?.avatar == '') {
      if (_personalData?.name != '') {
        return "https://ui-avatars.com/api/?name=${_personalData?.name}&size=256";
      }
    }
    return "https://static.thenounproject.com/png/2643408-200.png";
  }

  @override
  Widget build(BuildContext context) {
    if (Auth().currentUser?.isAnonymous ?? false) return const AuthHome();
    if (_personalData == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView(
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
    );
  }
}
