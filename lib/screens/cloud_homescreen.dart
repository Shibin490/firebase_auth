// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:authenticationapp/controller/cloud_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UploadScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImageUploadProvider>(context);

    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Image Uploader",
        style: TextStyle(color: Colors.white),
      )),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imageProvider.image != null
                ? Image.file(imageProvider.image!,
                    height: 200, width: 200, fit: BoxFit.cover)
                : Text("No image selected"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: imageProvider.pickImage,
              child: Text("Pick Image"),
            ),
            SizedBox(height: 20),
            imageProvider.isUploading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: imageProvider.uploadImage,
                    child: Text("Upload Image"),
                  ),
            if (imageProvider.uploadedFileUrl != null) ...[
              SizedBox(height: 20),
              Text("Uploaded Image:"),
              SelectableText(imageProvider.uploadedFileUrl!),
            ],
          ],
        ),
      ),
    );
  }
}
