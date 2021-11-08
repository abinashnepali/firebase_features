import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../chats/bubblemsg.dart';

class MessageChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
        // FutureBuilder(future:FirebaseAuth.instance.currentUser as Future<Object> ,
        //  builder: (ctx,futureSnapshot)=> if (futuresnapshot.)
        // )
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('chat')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (ctx, AsyncSnapshot<QuerySnapshot> chatsnapshot) {
              if (chatsnapshot.connectionState == ConnectionState.waiting) {
                Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatdata = chatsnapshot.data?.docs;
              if (chatdata == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final userid = FirebaseAuth.instance.currentUser?.uid;
                return ListView.builder(
                  reverse: true,
                  itemCount: chatdata.length,
                  itemBuilder: (ctx, index) => BubbleMessage(
                    chatdata[index]['text'],
                    chatdata[index]['userId'] == userid ? true : false,
                    chatdata[index]['username'],
                    chatdata[index]['user_image'],
                    key: ValueKey(chatdata[index].id),
                  ),
                );
              }
            });
  }
}
