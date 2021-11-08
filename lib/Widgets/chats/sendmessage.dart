import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SendMessage extends StatefulWidget {
  @override
  _SendMessageState createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  final _messageController = new TextEditingController();
  var _entermessage = '';
  void _sendMessage(String text) async {
    final user = FirebaseAuth.instance.currentUser;
    final userdata = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();

    _messageController.clear();
    FocusScope.of(context).unfocus();
    FirebaseFirestore.instance.collection('chat').add({
      'text': text,
      'createdAt': Timestamp.now(),
      'userId': user?.uid,
      'username': userdata['username'],
      'user_image': userdata['image_url'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              decoration: InputDecoration(labelText: 'Send a message....'),
              controller: _messageController,
              onChanged: (value) {
                setState(() {
                  _entermessage = value;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              _entermessage.trim().isEmpty ? null : _sendMessage(_entermessage);
            },
          ),
        ],
      ),
    );
  }
}
