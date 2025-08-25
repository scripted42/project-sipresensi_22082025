import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

class ImageUtils {
  /// Convert image file to base64 string
  static Future<String> imageToBase64(String imagePath) async {
    try {
      final file = File(imagePath);
      final bytes = await file.readAsBytes();
      final base64String = base64Encode(bytes);
      
      // Get file extension
      final extension = path.extension(imagePath).toLowerCase();
      String mimeType = 'image/jpeg';
      
      if (extension == '.png') {
        mimeType = 'image/png';
      } else if (extension == '.gif') {
        mimeType = 'image/gif';
      } else if (extension == '.webp') {
        mimeType = 'image/webp';
      }
      
      return 'data:$mimeType;base64,$base64String';
    } catch (e) {
      print('Error converting image to base64: $e');
      rethrow;
    }
  }
  
  /// Convert image file to base64 string (from XFile)
  static Future<String> xFileToBase64(String filePath) async {
    return await imageToBase64(filePath);
  }
}