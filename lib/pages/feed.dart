import 'package:flutter/material.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class Post {
  final String title;
  final String body;
  final List<String> tags;

  Post({required this.title, required this.body, this.tags = const []});
}

class _FeedState extends State<Feed> {
  List<Post> posts = [
    Post(
        title: 'Post 1',
        body: 'This is the body of post 1',
        tags: ['tag1', 'tag2', 'tag3']),
    Post(title: 'Post 2', body: 'This is the body of post 2', tags: ['tag1']),
    Post(
        title: 'Post 3',
        body: 'This is the body of post 3',
        tags: ['tag1', 'tag2']),
    Post(title: 'Post 4', body: 'This is the body of post 4'),
    Post(
        title: 'Post 5',
        body:
            'This is the body of post 5, with a long body text to test the overflow of the text widget and see if it works properly or not.'),
    Post(title: 'Post 6', body: 'This is the body of post 6'),
    Post(title: 'Post 7', body: 'This is the body of post 7'),
    Post(
        title: 'Post 8',
        body:
            'This is the body of post 8. It has a long body text to test the overflow of the text widget and see if it works properly or not. It has a long body text to test the overflow of the text widget and see if it works properly or not.',
        tags: [
          'longerTag1',
          'longerTag2',
          'longerTag3',
          'longerTag4',
          'longerTag5',
        ]),
    Post(title: 'Post 9', body: 'This is the body of post 9'),
    Post(title: 'Post 10', body: 'This is the body of post 10'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: const TextField(
            decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(28)),
                )),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                minVerticalPadding: 10,
                title: Text(
                  posts[index].title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(top: 5, bottom: 15, left: 0),
                      child: Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: posts[index].tags.map((tag) {
                            return Chip(
                              label: Text(tag),
                              padding: EdgeInsets.zero,
                            );
                          }).toList()),
                    ),
                    Text(posts[index].body,
                        maxLines: 3,
                        style: const TextStyle(
                          fontSize: 16,
                        )),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.edit),
      ),
    );
  }
}
