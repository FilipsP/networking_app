import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:networking_app/auth/auth.dart';
import 'package:networking_app/pages/create_post.dart';
import 'package:networking_app/pages/post_page.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final Query _postsRef = FirebaseDatabase.instance
      .ref()
      .child('posts')
      .limitToLast(100)
      .orderByChild('time');

  // * UI Components(Widgets):

  // * Floating Action Button to create a new post
  Widget _createPostButton() {
    if (Auth().currentUser?.isAnonymous ?? false) {
      return Container();
    }
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

  Widget _buildImage(String? imageUrl) {
    if (imageUrl == null) {
      return Container();
    }
    //TODO: Add settings to change image preferences
    return Image.network('$imageUrl/400/200?grayscale');
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
        maxLines: 3,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 16,
        ));
  }

  Widget _buildListTile(snapshot, post) {
    return ListTile(
      onTap: () => _navigateToPostPage(post, snapshot.key.toString()),
      minVerticalPadding: 10,
      title: _postTitle(post['title']),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTags(post['tags']),
          _postSubtitle(post['body'].replaceAll('\\n', '\n')),
          _buildImage(post['imageUrl']),
          SizedBox(height: post['eventTime'] == null ? 0 : 10.0),
          _eventTime(post['eventTime']),
        ],
      ),
    );
  }

  Widget _eventTime(int? time) {
    if (time == null) {
      return Container();
    }
    int timeUntilEvent = time - DateTime.now().millisecondsSinceEpoch;
    if (timeUntilEvent < 0) {
      return const Text(
        'Event has already passed',
        style: TextStyle(
          color: Colors.grey,
        ),
      );
    }
    return Text(
      'Event in ${DateFormat('d').format(DateTime.fromMillisecondsSinceEpoch(timeUntilEvent))} days',
      style: const TextStyle(
        color: Colors.grey,
      ),
    );
  }

  Widget _buildList() {
    return FirebaseAnimatedList(
      query: _postsRef,
      // * \uf8ff is a unicode character that is used to sort strings after all other characters
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
            child: _buildListTile(snapshot, post),
          ),
        );
      },
    );
  }

  void _navigateToPostPage(post, key) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostPage(
          key: Key(key),
          post: post,
          postKey: key,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildList(),
      floatingActionButton: _createPostButton(),
    );
  }
}
