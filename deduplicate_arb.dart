import 'dart:convert';
import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: dart deduplicate_arb.dart <file1> <file2> ...');
    return;
  }
  for (var path in args) {
    final f = File(path);
    if (!f.existsSync()) {
      print('File not found: $path');
      continue;
    }
    final content = f.readAsStringSync();
    final map = json.decode(content);
    
    // Sort keys alphabetically
    final sortedKeys = map.keys.toList()..sort();
    final Map<String, dynamic> sortedMap = {};
    for (var key in sortedKeys) {
      sortedMap[key] = map[key];
    }
    
    final encoder = JsonEncoder.withIndent('    ');
    f.writeAsStringSync(encoder.convert(sortedMap));
    print('Deduplicated and sorted $path');
  }
}
