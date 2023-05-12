import 'package:flutter/material.dart';
import 'package:networking_app/db/firebase/controllers/firebase_posts_controller.dart';

class CommentInput extends StatelessWidget {
  final TextEditingController textEditingController = TextEditingController();
  final String postKey;
  CommentInput({super.key, required this.postKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                hintText: 'Write a comment...',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide:
                        BorderSide(color: Colors.grey.shade600, width: 1.0)),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                fillColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          FloatingActionButton(
            onPressed: () {
              FirebasePostsController()
                  .addComment(postKey, textEditingController.text);
              // Perform the necessary action with the comment (e.g., submit to Firebase)
              textEditingController.clear();
            },
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            elevation: 1.0,
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
