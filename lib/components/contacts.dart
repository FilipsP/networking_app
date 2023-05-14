import 'package:flutter/material.dart';

class Contacts extends StatefulWidget {
  final List<dynamic> contacts;
  const Contacts({Key? key, required this.contacts}) : super(key: key);

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  List<dynamic> get contacts => widget.contacts;
  @override
  Widget build(BuildContext context) {
    if (contacts.isEmpty) {
      return Container();
    }
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contacts:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            for (Map contact in contacts)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: contact['icon'],
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      onPressed: () => contact['callback'](contact['value']),
                      child: Text(contact['value']),
                    ),
                  ],
                ),
              ),
          ],
        ));
  }
}
