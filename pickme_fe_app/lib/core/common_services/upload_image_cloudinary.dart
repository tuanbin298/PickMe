import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UploadImageCloudinary {
  static const String cloudName = 'tuanbin';
  static const String uploadPreset = 'PickMe_application';

  Future<String?> uploadImage(File imageFile) async {
    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    // Send request upload img into cloudinary
    final request = http.MultipartRequest("POST", url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    // Respone from cloudinary
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);

      return data['secure_url'];
    } else {
      // ignore: avoid_print
      print("Upload thất bại: ${response.statusCode}");

      return null;
    }
  }
}
