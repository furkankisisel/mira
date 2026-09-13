import 'dart:convert';
import 'dart:io';

void main() async {
  // 1. Read the template file (Turkish)
  final trFile = File('lib/l10n/app_tr.arb');
  if (!trFile.existsSync()) {
    print('Error: lib/l10n/app_tr.arb not found');
    exit(1);
  }

  final trContent = await trFile.readAsString();
  final Map<String, dynamic> trMap = json.decode(trContent);

  // Identify actual keys (excluding metadata starting with @)
  final trKeys = trMap.keys.where((k) => !k.startsWith('@')).toSet();
  print('Template (TR) has ${trKeys.length} keys.');

  // Determine if we need to clean up app_tr.arb (write it back sorted/unique)
  // We always write it back to ensure it's sorted and deduped
  final trEncoder = JsonEncoder.withIndent('    ');
  final sortedTrKeys = trMap.keys.toList()..sort();
  final Map<String, dynamic> sortedTrMap = {};
  for (final key in sortedTrKeys) {
    sortedTrMap[key] = trMap[key];
  }
  await trFile.writeAsString(trEncoder.convert(sortedTrMap));
  print('Cleaned and sorted app_tr.arb');

  // 2. Iterate over all ARB files
  final dir = Directory('lib/l10n');
  final files = dir.listSync().whereType<File>().where(
    (f) => f.path.endsWith('.arb'),
  );

  for (final file in files) {
    if (file.path.contains('app_tr.arb')) continue; // Skip template

    try {
      final content = await file.readAsString();
      final Map<String, dynamic> map = json.decode(content);

      bool changed = false;
      int addedCount = 0;

      for (final key in trKeys) {
        if (!map.containsKey(key)) {
          // Add missing key. Use English text if available/known, otherwise fallback or empty.
          // Since we don't have a reliable "source of truth" map for values here,
          // we will use a placeholder or copy the TR value with a prefix to indicate untranslated.
          // BUT, for purpose of just preventing "missing key" errors and allowing compilation,
          // we usually copy the logic of "copy from TR" or "copy from default".
          // Better yet: If check_missing_keys found them in EN, maybe we should sync from EN?
          // For now, let's copy from TR but maybe mark it?
          // Reverting to strategy: Copy from TR map.

          map[key] = trMap[key]; // Copying Turkish value for now as placeholder

          // Copy metadata if exists in TR
          if (trMap.containsKey('@$key')) {
            map['@$key'] = trMap['@$key'];
          }

          changed = true;
          addedCount++;
        }
      }

      if (changed) {
        // Load existing keys (and remove duplicates by using a Map)
        // The 'map' variable already holds the content, and by using a Map,
        // duplicate keys are inherently handled (last one wins).
        // So, we can directly work with 'map' for deduplication and sorting.
        final Map<String, dynamic> dedupedContent = {};
        map.forEach(
          (k, v) => dedupedContent[k] = v,
        ); // This step effectively "deduplicates" if there were any, though JSON decode already handles it.

        // Add missing keys (already done in the loop above, 'addedCount' reflects this)
        // The 'addedCount' variable is already tracking keys added from trKeys.

        // Sort keys
        final sortedKeys = dedupedContent.keys.toList()..sort();
        final Map<String, dynamic> sortedContent = {};
        for (final key in sortedKeys) {
          sortedContent[key] = dedupedContent[key];
        }

        final encoder = JsonEncoder.withIndent('    ');
        await file.writeAsString(
          encoder.convert(sortedContent),
        ); // Use sortedContent here
        print(
          'Updated ${file.path.split(Platform.pathSeparator).last}: Added $addedCount keys.',
        );
      }
    } catch (e) {
      print('Error processing ${file.path}: $e');
    }
  }
  print('Propagation complete.');
}
