import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:networking_app/components/search_bar.dart';
import 'package:networking_app/db/firebase/controllers/firebase_posts_controller.dart';
import 'package:networking_app/pages/create_post.dart';
import 'package:networking_app/pages/post_page.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

// class Post {
//   final String title;
//   final String body;
//   final List<String> tags;
//
//   Post({required this.title, required this.body, this.tags = const []});
// }

class _FeedState extends State<Feed> {
  final Query _postsRef = FirebaseDatabase.instance.ref().child('posts');
  //Post format ↓¦↓
  // List<Post> posts = [
  //   Post(
  //       title: 'Post 1',
  //       body: 'This is the body of post 1',
  //       tags: ['tag1', 'tag2', 'tag3']),
  //   Post(title: 'Post 2', body: 'This is the body of post 2', tags: ['tag1']),
  //   Post(
  //       title: 'Post 3',
  //       body: 'This is the body of post 3',
  //       tags: ['tag1', 'tag2']),
  //   Post(title: 'Post 4', body: 'This is the body of post 4'),
  //   Post(
  //       title: 'Post 5',
  //       body:
  //           'This is the body of post 5, with a long body text to test the overflow of the text widget and see if it works properly or not.'),
  //   Post(title: 'Post 6', body: 'This is the body of post 6'),
  //   Post(title: 'Post 7', body: 'This is the body of post 7'),
  //   Post(
  //       title: 'Post 8',
  //       body:
  //           'This is the body of post 8. It has a long body text to test the overflow of the text widget and see if it works properly or not. It has a long body text to test the overflow of the text widget and see if it works properly or not.',
  //       tags: [
  //         'longerTag1',
  //         'longerTag2',
  //         'longerTag3',
  //         'longerTag4',
  //         'longerTag5',
  //       ]),
  //   Post(title: 'Post 9', body: 'This is the body of post 9'),
  //   Post(title: 'Post 10', body: 'This is the body of post 10'),
  // ];

  // * UI Components(Widgets):

  // * Floating Action Button to create a new post
  Widget _createPostButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CreatePost(),
          ),
        );
      },
      child: const Icon(Icons.edit),
    );
  }

  // * Tags of a post
  Widget _buildTags(tags) {
    // * If there are no tags, return an empty container due to the fact that firebase doesn't save empty lists and returns null instead
    // * This could be altered to storing some placeholder value in firebase instead of null in the future
    if (tags == null) {
      return Container();
    }
    List<String> tagsToDisplay = tags.cast<String>();
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 10, left: 0),
      child: Wrap(
          spacing: 5,
          runSpacing: 5,
          children: tagsToDisplay.map((tag) {
            return Chip(
              label: Text(tag),
              padding: EdgeInsets.zero,
            );
          }).toList()),
    );
  }

  // * Title of a post
  Widget _postTitle(title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

// * Subtitle of a post
  Widget _postSubtitle(body) {
    return Text(body,
        maxLines: 4,
        style: const TextStyle(
          fontSize: 16,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: const SearchBar(),
      ),
      body: FirebaseAnimatedList(
        query: _postsRef,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          Map<dynamic, dynamic> post = snapshot.value as Map;
          post['key'] = snapshot;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostPage(
                        post: post,
                      ),
                    ),
                  );
                },
                minVerticalPadding: 10,
                title: _postTitle(post['title']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTags(post['tags']),
                    _postSubtitle(post['body']),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: _createPostButton(),
    );
  }
}
