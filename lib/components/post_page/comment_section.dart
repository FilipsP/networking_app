import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:networking_app/auth/auth.dart';
import 'package:networking_app/db/dto/comment_dto.dart';
import 'package:random_avatar/random_avatar.dart';

import '../../pages/person.dart';

class CommentSection extends StatefulWidget {
  final String postId;
  const CommentSection({Key? key, required this.postId}) : super(key: key);

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  late final DatabaseReference _commentsRef;
  List<CommentDTO> _comments = [];

  @override
  void initState() {
    super.initState();
    _commentsRef = _dbRef.child('posts/${widget.postId}/comments');
    _commentsRef.onValue.listen((event) {
      _initComments(event.snapshot.value);
    });
  }

  Future<void> _initComments(eventData) async {
    List<CommentDTO> comments = [];
    if (eventData != null) {
      try {
        Map data = eventData as Map;
        data.forEach((key, value) {
          value['key'] = key;
          comments.add(CommentDTO.fromSnapshot(value));
        });
        await _getCommentsData(comments);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  Future<void> _getCommentsData(List<CommentDTO> comments) async {
    for (var element in comments) {
      await _dbRef
          .child('users/${element.userID}')
          .once()
          .then((DatabaseEvent event) {
        if (event.snapshot.value != null) {
          Map data = event.snapshot.value as Map;
          data['key'] = event.snapshot.key;
          element.addData(data);
        }
      });
    }
    comments.sort((a, b) => b.time.compareTo(a.time));
    if (mounted) {
      setState(() {
        _comments = comments;
      });
    }
  }

  Widget _daysBeforeNow(int time) {
    return Text(
      '${DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(time)).inDays}d ago',
      style: const TextStyle(
        fontSize: 12,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildTitleLine(
      {required String userID,
      required String author,
      required String avatar,
      required int time}) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            if (userID != Auth().currentUser!.uid) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Person(
                    userID: userID,
                  ),
                ),
              );
            }
          },
          child: CircleAvatar(
            backgroundColor: Colors.white30,
            child: RandomAvatar(avatar, trBackground: true),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 200,
          child: Text(
            _getAuthorName(author),
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _daysBeforeNow(time),
      ],
    );
  }

  Widget _buildCommentContainer(
      {required String userID,
      required String key,
      required String author,
      required String commentText,
      required String avatar,
      required int time}) {
    return Container(
      constraints: const BoxConstraints(minHeight: 100),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
            onLongPress: () {
              if (userID == Auth().currentUser!.uid) {
                _deleteComment(key);
              }
            },
            title: _buildTitleLine(
                userID: userID, author: author, avatar: avatar, time: time),
            subtitle: Container(
              width: double.infinity,
              alignment: Alignment.bottomLeft,
              margin: const EdgeInsets.only(top: 15, left: 13.0),
              child: Text(commentText),
            )),
      ),
    );
  }

  void _deleteComment(String key) async {
    bool? isAccept = await _promptForDeleteComment();
    if (isAccept == null || !isAccept) {
      return;
    }
    _commentsRef.child(key).remove();
  }

  Future<bool?> _promptForDeleteComment() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure you want to delete this comment?'),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            icon: const Icon(Icons.delete_forever),
            label: const Text('Delete'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  String _getAuthorName(String author) {
    if (author == '' || author == ' ') {
      return 'Anonymous';
    }
    return author;
  }

  @override
  Widget build(BuildContext context) {
    if (_comments.isEmpty) {
      return const Center(
        child: Text('No comments yet'),
      );
    }
    return Container(
        constraints: const BoxConstraints(maxHeight: 400),
        child: ListView.builder(
          itemCount: _comments.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildCommentContainer(
              userID: _comments[index].userID,
              key: _comments[index].key,
              author: _comments[index].name ?? "Anonymous",
              commentText: _comments[index].body,
              avatar: _comments[index].avatar ?? _comments[index].userID,
              time: _comments[index].time,
            );
          },
        ));
  }
}
