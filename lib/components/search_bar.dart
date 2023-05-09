import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final Function callback;
  const SearchBar({Key? key, required this.callback}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        onChanged: (value) => widget.callback(value),
        decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 15),
            hintText: 'Search',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(28)),
            )),
      ),
    );
  }
}
