import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 600,
        imageQuality: 80,
      );

      if (image != null) {
        print('Image picked successfully from: ${image.path}');
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('Error taking picture: $e');
      rethrow;
    }
  }
}