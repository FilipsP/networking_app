import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PersonDTO {
  final String name;
  final String email;
  final String bio;
  final String? avatar;
  final String major;
  final int registrationTime;
  final String key;
  final Map? contact;
  final List? posts;
  final Map? friends;

  PersonDTO(
      {required this.name,
      this.contact,
      this.posts,
      required this.bio,
      required this.avatar,
      required this.email,
      required this.major,
      required this.registrationTime,
      required this.key,
      this.friends});

  factory PersonDTO.fromSnapshot(data) {
    return PersonDTO(
      name: data['name'],
      bio: data['bio'],
      avatar: data['avatarURL'],
      key: data['key'],
      email: data['email'],
      major: data['major'],
      registrationTime: data['registrationTime'],
      contact: data['contact'] as Map?,
    );
  }

  Icon _getIcon(key) {
    switch (key) {
      case 'email':
        return const Icon(Icons.email);
      case 'phone':
        return const Icon(Icons.phone);
      default:
        return const Icon(Icons.link);
    }
  }

  _getCallback(key) {
    switch (key) {
      case 'email':
        return (String text) => Clipboard.setData(ClipboardData(text: text));
      default:
        return;
    }
  }

  List<dynamic>? get contactList {
    if (contact == null) {
      return null;
    }
    List<dynamic> contacts = [];
    contact!.forEach((key, value) {
      contacts.add({
        'type': key,
        'value': value,
        'icon': _getIcon(key),
        'callback': _getCallback(key)
      });
    });
    return contacts;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'bio': bio,
      'avatar': avatar,
      'email': email,
      'major': major,
      'registrationTime': registrationTime,
      'key': key,
      'contact': contact,
    };
  }
}
