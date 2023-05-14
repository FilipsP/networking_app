import 'package:flutter/material.dart';
import 'package:networking_app/components/contacts.dart';
import 'package:networking_app/db/dto/person_dto.dart';
import 'package:networking_app/db/firebase/controllers/firebase_user_controller.dart';

class SettingsInputs extends StatefulWidget {
  final PersonDTO personalData;
  final String seed;
  const SettingsInputs(
      {super.key, required this.personalData, required this.seed});

  @override
  State<SettingsInputs> createState() => _SettingsInputsState();
}

class _SettingsInputsState extends State<SettingsInputs> {
  String _name = ' ';
  String _aboutMe = ' ';
  String _major = ' ';
  String _contactType = '';
  String _contactInfo = '';
  List<dynamic> _contactList = [];

  @override
  void initState() {
    super.initState();
    _name = widget.personalData.name;
    _aboutMe = widget.personalData.bio;
    _major = widget.personalData.major ?? ' ';
    _contactList = widget.personalData.contactList ?? [];
  }

  void _updateName(String newName) {
    setState(() {
      _name = newName;
    });
  }

  void _updateAboutMe(String newAboutMe) {
    setState(() {
      _aboutMe = newAboutMe;
    });
  }

  void _updateContactInfo(String newContactInfo) {
    setState(() {
      _contactInfo = newContactInfo;
    });
  }

  void _updateContactType(String newContactType) {
    setState(() {
      _contactType = newContactType;
    });
  }

  void _handleAddContact() {
    if (_contactType.isEmpty || _contactInfo.isEmpty) {
      return;
    }
    if (_contactList.any((element) => element['type'] == _contactType)) {
      return;
    }
    setState(() {
      _contactList.add({
        'type': _contactType,
        'value': _contactInfo,
        'icon': const Icon(Icons.fiber_new_rounded),
        'callback': (String text) => _handleRemoveContact(
            _contactList.indexWhere((element) => element['value'] == text))
      });
      _contactType = '';
      _contactInfo = '';
    });
  }

  void _handleRemoveContact(int index) {
    setState(() {
      _contactList.removeAt(index);
    });
  }

  void _saveChanges() {
    try {
      Map contacts = {};
      for (var element in _contactList) {
        contacts[element['type']] = element['value'];
      }
      FirebaseUserController().updatePersonData({
        "name": _name,
        "bio": _aboutMe,
        "major": _major,
        "contact": contacts,
        "avatarURL": widget.seed
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Changes saved'),
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error saving changes'),
        ),
      );
    }
  }

  //TODO: Add a way to remove contacts
  //TODO: Refactor this
  Widget _buildContactInfoInput() {
    return ListTile(
      title: const Text('Contact Information'),
      subtitle: Row(
        children: [
          Expanded(
            child: TextFormField(
              initialValue: _contactType,
              onChanged: _updateContactType,
              decoration: const InputDecoration(
                hintText: 'Type(fe. email, phone, etc.))',
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              initialValue: _contactInfo,
              onChanged: _updateContactInfo,
              decoration: const InputDecoration(
                hintText: 'Contact',
              ),
            ),
          ),
          IconButton(
              onPressed: _handleAddContact,
              icon: const Icon(
                Icons.add,
                size: 30,
                color: Colors.deepPurple,
              ))
        ],
      ),
    );
  }

  Widget _buildNameInput() {
    return ListTile(
      title: const Text('Name'),
      subtitle: TextFormField(
        initialValue: _name,
        onChanged: _updateName,
        decoration: const InputDecoration(
          hintText: 'Name',
        ),
      ),
    );
  }

  Widget _buildAboutMeInput() {
    return ListTile(
      title: const Text('About Me'),
      subtitle: TextFormField(
        initialValue: _aboutMe,
        onChanged: _updateAboutMe,
        decoration: const InputDecoration(
          hintText: 'About Me',
        ),
      ),
    );
  }

  Widget _buildMajorInput() {
    return ListTile(
      title: const Text('Major'),
      subtitle: TextFormField(
        initialValue: _major,
        onChanged: _updateAboutMe,
        decoration: const InputDecoration(
          hintText: 'Major',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildNameInput(),
        _buildAboutMeInput(),
        _buildMajorInput(),
        _buildContactInfoInput(),
        const SizedBox(height: 40.0),
        ElevatedButton(onPressed: _saveChanges, child: const Text('Save')),
        Contacts(contacts: _contactList),
      ],
    );
  }
}
