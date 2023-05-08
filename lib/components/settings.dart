import 'package:flutter/material.dart';
import '/pages/profile.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

@override
  Widget build(BuildContext context) {
    return Scaffold( // blank page with cancel and save button
      body: ListView(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      style: TextButton.styleFrom(
                        textStyle: Theme.of(context).textTheme.labelLarge,
                      ),
                      child: const Text('Cancel'),
                      onPressed: () { // closes back to where the page was opened
                        Navigator.of(context).pop();
                      },
                    ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('Save'),
                    onPressed: () {  // closes back to where the page was opened
                      // save changes function call
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}