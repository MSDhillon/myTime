// Importing necessary packages and files
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  final commentData;

  const CommentCard({super.key, required this.commentData});

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Displaying the user's profile picture in a circle avatar
          CircleAvatar(
            backgroundImage: NetworkImage(widget.commentData['profilePicture']),
            radius: 30.0,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Displaying the username of the commenter in bold
                  RichText(
                    text: TextSpan(
                        text: widget.commentData['username'],
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.bold)),
                  ),
                  // Displaying the comment text
                  RichText(
                    text: TextSpan(
                        text: widget.commentData['comment'],
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                  // Displaying the publication date of the comment
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      DateFormat.yMMMd().format(
                          widget.commentData['publicationDate'].toDate()),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
