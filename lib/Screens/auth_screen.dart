import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

import '/Widgets/auth_wigdets/auth_widget.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isLoading = false;
  final _auth = FirebaseAuth.instance;
  String errmessage(String messages) {
    print("check mess $messages");
    if (messages.endsWith('another account.'))
      return messages =
          'The Email is Already in  used.Please try with another Email.';
    if (messages.contains('Given String is empty or null'))
      return messages = 'Invalid Username/Password';
    if (messages.contains(
        'The password is invalid or the user does not have a password'))
      return messages = 'Invalid Username/Password';
    if (messages.contains(
        'There is no user record corresponding to this identifier. The user may have been deleted.'))
      return messages = 'No user found';
    return 'There is Something worng please try again later';
  }

  void _submitAuthForm(String email, String username, String password,
      bool isLogin, BuildContext ctx,
      [File? Image]) async {
    try {
      setState(() {
        _isLoading = true;
      });
      UserCredential userCredential;
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
            email: email.toString(), password: password.toString());
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
            email: email.toString(), password: password.toString());
        var imagepath = (userCredential.user?.uid) as String;

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(imagepath + '.jpg');
        await ref.putFile(Image as File).whenComplete(() {});
        final url = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user?.uid)
            .set({
          'username': username,
          'email': email,
          'image_url': url,
        });
      }
    } on PlatformException catch (error) {
      var messages = 'An error occured, please check your Credentials';
      if (error != null) {
        messages = error.message as String;
      }
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(messages),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      setState(() {
        _isLoading = false;
      });

      var messages = err.toString();
      // if (messages.endsWith('another account.'))
      //   messages =
      //       'The Email is Already in  used.Please try with another Email.';
      String checkmsg = errmessage(messages);

      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Container(
          height: 18,
          child: FittedBox(
            child: Text(
              checkmsg,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: AuthForm(_submitAuthForm, _isLoading));
  }
}
