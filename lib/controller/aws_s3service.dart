import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AWSS3Service {
  // Get Pre-signed URL from the API
  Future<Map<String, dynamic>?> getPresignedUrl(String fileName) async {
    final url = Uri.parse("https://filesapisample.stackmod.info/api/presigned-url");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "noteId": "noteId",
          "fileName": fileName,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Error getting pre-signed URL: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error getting pre-signed URL: $e");
      return null;
    }
  }

  // Upload Image to S3 using the pre-signed URL
  Future<bool> uploadImageToS3({required String uploadUrl, required File imageFile}) async {
    try {
      final request = http.Request("PUT", Uri.parse(uploadUrl))
        ..headers["Content-Type"] = "image/jpeg"
        ..bodyBytes = await imageFile.readAsBytes();

      final response = await request.send();

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Upload failed with status code: ${response.statusCode}");

        return false;
      }
    } catch (e) {
      print("Error uploading image to S3: $e");
      return false;
    }
  }
}
