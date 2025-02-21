import 'dart:developer';
import 'dart:io';
import 'package:authenticationapp/controller/aws_s3service.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadProvider extends ChangeNotifier {
  File? _image;
  bool _isUploading = false;
  String? _uploadedFileUrl;

  File? get image => _image;
  bool get isUploading => _isUploading;
  String? get uploadedFileUrl => _uploadedFileUrl;

  final ImagePicker _picker = ImagePicker();
  final AWSS3Service _s3Service = AWSS3Service();

  // Pick Image from Gallery
  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      notifyListeners();
    }
  }

  // Upload Image using Pre-signed URL
  Future<void> uploadImage() async {
    if (_image == null) return;

    _isUploading = true;
    notifyListeners();

    String fileName = _image!.path.split('/').last;

    // Call the service to get the pre-signed URL and upload the image
    final presignedData = await _s3Service.getPresignedUrl(fileName);

    if (presignedData == null) {
      _isUploading = false;
      notifyListeners();
      return;
    }

    final uploadSuccess = await _s3Service.uploadImageToS3(
      uploadUrl: presignedData["url"],
      imageFile: _image!,
    );

    if (uploadSuccess) {
      _uploadedFileUrl = presignedData["uploadedFilePath"];
      log("File uploaded successfully status code: == 200");
      log("File uploaded successfully: $_uploadedFileUrl");
    } else {
      print("File upload failed.");
    }

    _isUploading = false;
    notifyListeners();
  }
}
