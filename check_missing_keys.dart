import 'dart:convert';
import 'dart:io';

void main() {
  final l10nDir = Directory('lib/l10n');
  if (!l10nDir.existsSync()) {
    print('l10n directory not found');
    return;
  }

  // Load template (Turkish)
  final trFile = File('lib/l10n/app_tr.arb');
  final trMap = json.decode(trFile.readAsStringSync()) as Map<String, dynamic>;
  final trKeys = trMap.keys.where((k) => !k.startsWith('@')).toSet();

  print('Total keys in TR: ${trKeys.length}');

  final files = l10nDir.listSync().whereType<File>().where(
    (f) => f.path.endsWith('.arb'),
  );

  for (final file in files) {
    if (file.path.contains('app_tr.arb')) continue;

    final map = json.decode(file.readAsStringSync()) as Map<String, dynamic>;
    final keys = map.keys.where((k) => !k.startsWith('@')).toSet();

    final missing = trKeys.difference(keys);
    if (missing.isNotEmpty) {
      print(
        '\nMissing keys in ${file.path.split(Platform.pathSeparator).last}: ${missing.length}',
      );
      // print(missing.join(', '));
      // Print first 5 missing
      print('Examples: ${missing.take(5).join(', ')}...');
    } else {
      // print('${file.path} is complete.');
    }
  }
}
