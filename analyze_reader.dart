import 'dart:io';

void main() async {
  final file = File('analyze.log');
  if (await file.exists()) {
    try {
      print(await file.readAsString());
    } catch (e) {
      // Try different encoding if default fails?
      // print('Error reading: $e');
      // bytes
      final bytes = await file.readAsBytes();
      print(String.fromCharCodes(bytes));
    }
  } else {
    print('File not found');
  }
}
