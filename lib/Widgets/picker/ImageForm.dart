import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageForm extends StatefulWidget {
  final void Function(File pickedImage) imagePickFn;
  ImageForm(this.imagePickFn);

  @override
  _ImageFormState createState() => _ImageFormState();
}

class _ImageFormState extends State<ImageForm> {
  File? _pickedImageFile;

  void _pickImage() async {
    final imagePicker = ImagePicker();
    final imageFile = await imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxWidth: 150,
        maxHeight: 150);
    if (imageFile == null) return;

    setState(() {
      _pickedImageFile = File(imageFile.path);
    });
    widget.imagePickFn(_pickedImageFile as File);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: _pickedImageFile != null
              ? FileImage(_pickedImageFile as File)
              : null,
        ),
        TextButton.icon(
          icon: Icon(Icons.image),
          label: Text(
            'Add Image',
          ),
          onPressed: _pickImage,
        ),
      ],
    );
  }
}
