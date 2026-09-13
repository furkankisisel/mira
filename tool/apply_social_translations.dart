import 'dart:convert';
import 'dart:io';

void main() async {
  final translationsFile = File('lib/l10n/social_translations.json');
  if (!translationsFile.existsSync()) {
    print('Error: social_translations.json not found');
    return;
  }

  final String translationsContent = await translationsFile.readAsString();
  final Map<String, dynamic> translationsData = json.decode(translationsContent);

  final List<String> placeholderKeys = [
    'memberCountText',
    'addedToRoomSnackbar',
    'taskAddedSnackbar',
    'membersCountText',
    'membersCompletedStatus',
    'joinRoomSuccessSnackbar'
  ];

  final Map<String, dynamic> metadata = {
    'memberCountText': {'placeholders': {'count': {}}},
    'addedToRoomSnackbar': {'placeholders': {'title': {}}},
    'taskAddedSnackbar': {'placeholders': {'title': {}}},
    'membersCountText': {'placeholders': {'count': {}}},
    'membersCompletedStatus': {'placeholders': {'completed': {}, 'total': {}}},
    'joinRoomSuccessSnackbar': {'placeholders': {'roomName': {}}}
  };

  final dir = Directory('lib/l10n');
  final List<FileSystemEntity> files = dir.listSync();

  for (var lang in translationsData.keys) {
    final fileName = 'app_$lang.arb';
    final file = File('lib/l10n/$fileName');

    if (file.existsSync()) {
      print('Updating $fileName...');
      final String currentContent = await file.readAsString();
      final Map<String, dynamic> currentMap = json.decode(currentContent);

      final Map<String, dynamic> newTranslations = translationsData[lang];
      
      newTranslations.forEach((key, value) {
        currentMap[key] = value;
        if (placeholderKeys.contains(key)) {
          currentMap['@$key'] = metadata[key];
        }
      });

      // Sort keys
      final sortedKeys = currentMap.keys.toList()..sort();
      final Map<String, dynamic> sortedMap = {};
      for (var key in sortedKeys) {
        sortedMap[key] = currentMap[key];
      }

      final encoder = JsonEncoder.withIndent('    ');
      await file.writeAsString(encoder.convert(sortedMap));
      print('Successfully updated $fileName');
    } else {
      print('Warning: $fileName not found, skipping.');
    }
  }
}
