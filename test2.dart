import 'dart:convert';
import 'dart:io';

void main() {
  final result = Process.runSync('dart', ['analyze', '--format=json']);
  final content = result.stdout.toString();
  final buf = StringBuffer();
  try {
    final Map<String, dynamic> json = jsonDecode(content);
    final diagnostics = json['diagnostics'] as List;
    for (final diag in diagnostics) {
      final loc = diag['location'];
      buf.writeln('${loc['file']}:${loc['range']['start']['line']} - ${diag['problemMessage']} (${diag['code']})');
    }
  } catch(e) {
    buf.writeln('Failed to parse: $e');
  }
  File('test2_output.txt').writeAsStringSync(buf.toString());
}
