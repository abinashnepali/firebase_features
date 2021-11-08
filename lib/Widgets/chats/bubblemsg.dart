import 'package:flutter/material.dart';

class BubbleMessage extends StatelessWidget {
  final String textMessage;
  final bool isMe;
  final Key key;
  final String username;
  final String userimage;
  BubbleMessage(this.textMessage, this.isMe, this.username, this.userimage,
      {required this.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: isMe
                    ? Colors.green.shade300
                    : Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
                ),
              ),
              width: 140,
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 8,
              ),
              child: Container(
                padding: EdgeInsets.only(top: 2),
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      username,
                      style: TextStyle(
                          color: isMe ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      textMessage,
                      style: TextStyle(
                          color: isMe ? Colors.black : Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: -15,
          right: isMe ? 110 : null,
          left: !isMe ? 110 : null,
          child: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            backgroundImage: NetworkImage(userimage),
          ),
        )
      ],
      clipBehavior: Clip.none,
    );
  }
}
