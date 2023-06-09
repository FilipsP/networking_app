import 'package:flutter/material.dart';
import 'package:networking_app/components/settings_page/settings_inputs.dart';
import 'package:networking_app/db/dto/person_dto.dart';
import 'package:random_avatar/random_avatar.dart';

import '../auth/auth.dart';

class ProfileSettings extends StatefulWidget {
  final PersonDTO personalData;
  const ProfileSettings({Key? key, required this.personalData})
      : super(key: key);

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  String? _image;
  @override
  void initState() {
    super.initState();
    _handleAvatarInit();
  }

  void _handleAvatarInit() {
    if (widget.personalData.avatar != '' &&
        widget.personalData.avatar != null &&
        widget.personalData.avatar != ' ') {
      _image = widget.personalData.avatar!;
    } else {
      _image = Auth().currentUser!.uid;
    }
  }

  Widget _avatar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: MaterialButton(
        padding: const EdgeInsets.all(0),
        shape: const CircleBorder(),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => _selectAvatarDialog(),
        ),
        child: CircleAvatar(
          radius: 50,
          child: RandomAvatar(_image!),
        ),
      ),
    );
  }

  Widget _selectAvatarDialog() {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Avatar',
                style: TextStyle(fontSize: 25),
              ),
              const SizedBox(height: 40),
              _avatarGrid(),
            ]),
      ),
    );
  }

  Widget _avatarGrid() {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 250,
      child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            //String seed = DateTime.now().toIso8601String();
            String seed = RandomAvatarString(DateTime.now().toIso8601String());
            return GridTile(
              child: MaterialButton(
                onPressed: () {
                  _handleAvatarPick(seed);
                },
                padding: EdgeInsets.zero,
                shape: const CircleBorder(),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.transparent.withOpacity(0.1),
                  child: RandomAvatar(
                    seed,
                  ),
                ),
              ),
            );
          }),
    );
  }

  void _handleAvatarPick(seed) {
    setState(() {
      _image = seed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _avatar(),
            SettingsInputs(
              personalData: widget.personalData,
              seed: _image!,
            ),
          ],
        ),
      ),
    );
  }
}
