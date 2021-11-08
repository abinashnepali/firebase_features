import 'package:flutter/material.dart';
import 'dart:io';

import '../picker/ImageForm.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String username, String password,
      bool isLogin, BuildContext ctx,
      [File image]) submitForm;
  final bool isLoading;
  AuthForm(this.submitForm, this.isLoading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _Email = '';
  var _userName = '';
  var _password = '';
  var _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  _submitFrom() {
    final isvalid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();
    if (_userImageFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Please pick an image.'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }

    if (isvalid as bool) {
      !_isLogin
          ? widget.submitForm(_Email.trim(), _userName.trim(), _password.trim(),
              _isLogin, context, _userImageFile)
          : widget.submitForm(_Email.trim(), _userName.trim(), _password.trim(),
              _isLogin, context);

      _formKey.currentState?.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 10,
        // color: Colors.amber,
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!_isLogin) ImageForm(_pickedImage),
                  TextFormField(
                    key: ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    decoration: InputDecoration(labelText: 'Email address'),
                    validator: (value) {
                      if (value!.isEmpty ||
                          !value.contains('@') ||
                          !value.contains('.com') ||
                          value.contains('yapmail')) {
                        return 'Invalid Email Address. Please Enter a valid Email Address.';
                      }
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _Email = value as String;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      decoration: InputDecoration(labelText: 'Username'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This field is required';
                        }
                        if (value.length < 4) {
                          return 'Username must be at least 4 characters in length';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _userName = val as String;
                      },
                    ),
                  TextFormField(
                      key: ValueKey('password'),
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This field is required';
                        }
                        if (value.length <= 5) {
                          return 'Password must be at least 5 characters in length';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _password = val as String;
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                        child: Text(_isLogin ? 'Login' : 'Sigin Up'),
                        onPressed: _submitFrom),
                  if (!widget.isLoading)
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.pink),
                      ),
                      child: Text(_isLogin
                          ? 'Create an new Account?'
                          : 'I have already Account.'),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
