import 'dart:convert';
// import 'package:image_picker/image_picker.dart';
// Note: importing image_picker directly here might require the package to be used.
// However, typically Utils operate on File or XFile.
// Since XFile is from cross_file (exported by image_picker usually), we avoid direct heavy deps if possible
// but strictly speaking, we need it if we accept XFile.
import 'package:image_picker/image_picker.dart';

class ImageUtils {
  /// Reads an [XFile], validates size (optional check), and returns Base64 string.
  /// Intended for preparing images for AI analysis.
  static Future<String?> convertXFileToBase64(XFile? file) async {
    if (file == null) return null;

    try {
      final bytes = await file.readAsBytes();

      // Basic size check (e.g. warn or reject if > 5MB? For now just encode)
      // Real implementation might resize using flutter_image_compress here.

      if (bytes.isEmpty) return null;

      final base64String = base64Encode(bytes);
      return base64String;
    } catch (e) {
      print('Error converting image to Base64: $e');
      return null;
    }
  }
}
