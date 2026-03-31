import 'dart:convert';
import 'dart:io';

void main() {
  final content = File('analyze.json').readAsStringSync();
  try {
    final Map<String, dynamic> json = jsonDecode(content);
    final diagnostics = json['diagnostics'] as List;
    for (final diag in diagnostics) {
      final loc = diag['location'];
      print('${loc['file']}:${loc['range']['start']['line']} - ${diag['problemMessage']} (${diag['code']})');
    }
  } catch(e) {
    print('Error parsing JSON: $e');
  }
}
