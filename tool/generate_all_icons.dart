import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  print('🚀 Starting Mira Icon & Notification Generation with Refined Sizing...');

  final darkPath = r'C:\Users\Furkan Çalık\.gemini\antigravity-ide\brain\6d807678-26f7-4ff1-ae28-90832c946c6f\.user_uploaded\media_1790845065489.png';
  final lightPath = r'C:\Users\Furkan Çalık\.gemini\antigravity-ide\brain\6d807678-26f7-4ff1-ae28-90832c946c6f\.user_uploaded\media_1790845065562.png';

  final rawDark = img.decodeImage(File(darkPath).readAsBytesSync())!;
  final rawLight = img.decodeImage(File(lightPath).readAsBytesSync())!;

  print('Loaded raw dark (${rawDark.width}x${rawDark.height}) and light (${rawLight.width}x${rawLight.height})');

  // 1. Extract clean transparent foregrounds (only the 3 pillars)
  final fgLightFull = _extractForeground(rawLight, isDark: false);
  final fgDarkFull = _extractForeground(rawDark, isDark: true);

  // Crop tight bounding box around the pillars
  final pillarsLight = _cropTight(fgLightFull);
  final pillarsDark = _cropTight(fgDarkFull);
  print('Tightly cropped pillars: Light ${pillarsLight.width}x${pillarsLight.height}, Dark ${pillarsDark.width}x${pillarsDark.height}');

  // 2. Transparent Logos (Only front pillars, NO background!)
  // In 1024x1024 canvas, pillars centered with width 520px
  final logoLight1024 = _createCenteredPillars(pillars: pillarsLight, canvasSize: 1024, pillarsTargetWidth: 540);
  final logoDark1024 = _createCenteredPillars(pillars: pillarsDark, canvasSize: 1024, pillarsTargetWidth: 540);

  _savePng(logoLight1024, 'assets/icons/mira_logo_light.png');
  _savePng(logoDark1024, 'assets/icons/mira_logo_dark.png');
  _savePng(logoLight1024, 'assets/icons/mira_icon_foreground_light.png');
  _savePng(logoDark1024, 'assets/icons/mira_icon_foreground_dark.png');
  _savePng(logoLight1024, 'assets/icons/miralogo.png');
  _savePng(logoLight1024, 'assets/icons/app_icon.png');
  print('✅ Saved transparent logo assets (NO background, only pillars)');

  // 3. Full App Icons for iOS & Mipmaps (solid background, with smaller centered pillars)
  // Target width 460px inside 1024x1024 (approx 45% of canvas, elegant breathing room)
  final lightBgColor = img.ColorRgba8(240, 240, 240, 255); // #F0F0F0
  final darkBgColor = img.ColorRgba8(44, 57, 37, 255);     // #2C3925

  final appIconLight = _createFullIcon(
    pillars: pillarsLight,
    bgColor: lightBgColor,
    canvasSize: 1024,
    pillarsTargetWidth: 460,
  );
  final appIconDark = _createFullIcon(
    pillars: pillarsDark,
    bgColor: darkBgColor,
    canvasSize: 1024,
    pillarsTargetWidth: 460,
  );

  _savePng(appIconLight, 'assets/icons/mira_app_icon_light.png');
  _saveJpg(appIconLight, 'assets/icons/mira_app_icon_light.jpg', quality: 95);
  _savePng(appIconDark, 'assets/icons/mira_app_icon_dark.png');
  print('✅ Saved 1024x1024 full app icons with reduced pillars');

  // 4. Android Adaptive Foregrounds (canvas 108dp, pillars ~40% of canvas)
  final adaptiveSizes = {
    'mdpi': {'size': 108, 'targetW': 44},
    'hdpi': {'size': 162, 'targetW': 66},
    'xhdpi': {'size': 216, 'targetW': 88},
    'xxhdpi': {'size': 324, 'targetW': 132},
    'xxxhdpi': {'size': 432, 'targetW': 176},
  };

  for (final entry in adaptiveSizes.entries) {
    final density = entry.key;
    final size = entry.value['size']!;
    final targetW = entry.value['targetW']!;

    final lightAdaptive = _createCenteredPillars(pillars: pillarsLight, canvasSize: size, pillarsTargetWidth: targetW);
    final darkAdaptive = _createCenteredPillars(pillars: pillarsDark, canvasSize: size, pillarsTargetWidth: targetW);

    _savePng(lightAdaptive, 'android/app/src/main/res/drawable-$density/ic_launcher_foreground.png');
    _savePng(darkAdaptive, 'android/app/src/main/res/drawable-night-$density/ic_launcher_foreground.png');
  }
  print('✅ Saved Android Adaptive Foregrounds with smaller pillars');

  // 5. Android Legacy Mipmaps (from the new refined full icons)
  final mipmapSizes = {
    'mdpi': 48,
    'hdpi': 72,
    'xhdpi': 96,
    'xxhdpi': 144,
    'xxxhdpi': 192,
  };

  for (final entry in mipmapSizes.entries) {
    final density = entry.key;
    final size = entry.value;

    final lightMipmap = img.copyResize(appIconLight, width: size, height: size, interpolation: img.Interpolation.cubic);
    final darkMipmap = img.copyResize(appIconDark, width: size, height: size, interpolation: img.Interpolation.cubic);

    _savePng(lightMipmap, 'android/app/src/main/res/mipmap-$density/ic_launcher.png');
    _savePng(lightMipmap, 'android/app/src/main/res/mipmap-$density/ic_mira_launcher.png');

    _savePng(darkMipmap, 'android/app/src/main/res/mipmap-night-$density/ic_launcher.png');
    _savePng(darkMipmap, 'android/app/src/main/res/mipmap-night-$density/ic_mira_launcher.png');
  }
  print('✅ Saved Android Legacy Mipmaps');

  // 6. Large Notification Icons (256x256 with pillars scaled to 120px inside squircle)
  final notifLight = _createNotificationLargeIcon(
    pillars: pillarsLight,
    bgColor: lightBgColor,
    canvasSize: 256,
    pillarsTargetWidth: 120,
  );
  final notifDark = _createNotificationLargeIcon(
    pillars: pillarsDark,
    bgColor: darkBgColor,
    canvasSize: 256,
    pillarsTargetWidth: 120,
  );

  _savePng(notifLight, 'android/app/src/main/res/drawable/ic_notification_large_v2.png');
  _savePng(notifDark, 'android/app/src/main/res/drawable-night/ic_notification_large_v2.png');
  try {
    _savePng(notifLight, 'android/app/src/main/res/drawable/ic_notification_large.png');
    _savePng(notifDark, 'android/app/src/main/res/drawable-night/ic_notification_large.png');
  } catch (e) {
    // If locked by running daemon
  }
  print('✅ Saved Android Large Notification Icons with smaller pillars');

  // 7. Raster Status Bar Icons (high-fidelity origami silhouette)
  final monoMaster = _createOrigamiSilhouette(pillarsLight);
  final statSizes = {
    'mdpi': {'canvas': 24, 'targetW': 20},
    'hdpi': {'canvas': 36, 'targetW': 30},
    'xhdpi': {'canvas': 48, 'targetW': 40},
    'xxhdpi': {'canvas': 72, 'targetW': 60},
    'xxxhdpi': {'canvas': 96, 'targetW': 80},
  };

  for (final entry in statSizes.entries) {
    final density = entry.key;
    final canvasSize = entry.value['canvas']!;
    final targetW = entry.value['targetW']!;
    final statIcon = _createCenteredPillars(pillars: monoMaster, canvasSize: canvasSize, pillarsTargetWidth: targetW);

    _savePng(statIcon, 'android/app/src/main/res/drawable-$density/ic_stat_mira.png');
    _savePng(statIcon, 'android/app/src/main/res/drawable-$density/ic_stat_mira_v2.png');
    _savePng(statIcon, 'android/app/src/main/res/drawable-$density/ic_stat_miralogo.png');
  }
  final defaultSmallIcon = _createCenteredPillars(pillars: monoMaster, canvasSize: 96, pillarsTargetWidth: 80);
  _savePng(defaultSmallIcon, 'android/app/src/main/res/drawable/ic_stat_mira.png');
  _savePng(defaultSmallIcon, 'android/app/src/main/res/drawable/ic_stat_mira_v2.png');
  _savePng(defaultSmallIcon, 'android/app/src/main/res/drawable/ic_stat_miralogo.png');
  print('✅ Saved Status Bar Raster Icons (Refined Origami Silhouette)');

  // 8. Splash Screen Icons for Android 12+ and Native LaunchScreen
  final splashSizes = {
    'mdpi': {'size': 288, 'targetW': 145},
    'hdpi': {'size': 432, 'targetW': 218},
    'xhdpi': {'size': 576, 'targetW': 290},
    'xxhdpi': {'size': 864, 'targetW': 435},
    'xxxhdpi': {'size': 1152, 'targetW': 580},
  };

  for (final entry in splashSizes.entries) {
    final density = entry.key;
    final size = entry.value['size']!;
    final targetW = entry.value['targetW']!;

    final lightSplash = _createCenteredPillars(pillars: pillarsLight, canvasSize: size, pillarsTargetWidth: targetW);
    final darkSplash = _createCenteredPillars(pillars: pillarsDark, canvasSize: size, pillarsTargetWidth: targetW);

    _savePng(lightSplash, 'android/app/src/main/res/drawable-$density/splash_icon_light.png');
    _savePng(darkSplash, 'android/app/src/main/res/drawable-$density/splash_icon_dark.png');
  }

  // Also default in drawable/
  final lightSplashDefault = _createCenteredPillars(pillars: pillarsLight, canvasSize: 288, pillarsTargetWidth: 145);
  final darkSplashDefault = _createCenteredPillars(pillars: pillarsDark, canvasSize: 288, pillarsTargetWidth: 145);
  _savePng(lightSplashDefault, 'android/app/src/main/res/drawable/splash_icon_light.png');
  _savePng(darkSplashDefault, 'android/app/src/main/res/drawable/splash_icon_dark.png');
  print('✅ Saved Native Splash Icons for Light & Dark Themes');

  print('🎉 All assets updated and generated successfully!');
}

img.Image _cropTight(img.Image src) {
  int minX = src.width, maxX = 0, minY = src.height, maxY = 0;
  for (int y = 0; y < src.height; y++) {
    for (int x = 0; x < src.width; x++) {
      if (src.getPixel(x, y).a > 20) {
        if (x < minX) minX = x;
        if (x > maxX) maxX = x;
        if (y < minY) minY = y;
        if (y > maxY) maxY = y;
      }
    }
  }
  return img.copyCrop(src, x: minX, y: minY, width: maxX - minX + 1, height: maxY - minY + 1);
}

img.Image _extractForeground(img.Image src, {required bool isDark}) {
  final out = img.Image(width: 1024, height: 1024, numChannels: 4);

  for (int y = 0; y < 1024; y++) {
    for (int x = 0; x < 1024; x++) {
      final inPillar1 = (x >= 125 && x <= 360 && y >= 155 && y <= 890);
      final inPillar2 = (x >= 395 && x <= 640 && y >= 340 && y <= 890);
      final inPillar3 = (x >= 670 && x <= 910 && y >= 155 && y <= 890);

      if (!inPillar1 && !inPillar2 && !inPillar3) {
        out.setPixelRgba(x, y, 0, 0, 0, 0);
        continue;
      }

      final p = src.getPixel(x, y);

      if (isDark) {
        final isWhiteTop = (p.r > 190 && p.g > 185 && p.b > 175);
        if (isWhiteTop) {
          out.setPixelRgba(x, y, p.r, p.g, p.b, 255);
        } else {
          final gVal = p.g.toDouble();
          if (gVal <= 68) {
            out.setPixelRgba(x, y, 0, 0, 0, 0);
          } else if (gVal >= 88) {
            out.setPixelRgba(x, y, p.r, p.g, p.b, 255);
          } else {
            final alpha = ((gVal - 68) / (88 - 68) * 255).round().clamp(0, 255);
            out.setPixelRgba(x, y, p.r, p.g, p.b, alpha);
          }
        }
      } else {
        final maxVal = p.r > p.g ? p.r : p.g;
        if (maxVal >= 236) {
          out.setPixelRgba(x, y, 0, 0, 0, 0);
        } else if (maxVal <= 210) {
          out.setPixelRgba(x, y, p.r, p.g, p.b, 255);
        } else {
          final alpha = ((236 - maxVal) / (236 - 210) * 255).round().clamp(0, 255);
          out.setPixelRgba(x, y, p.r, p.g, p.b, alpha);
        }
      }
    }
  }
  return out;
}

img.Image _createCenteredPillars({
  required img.Image pillars,
  required int canvasSize,
  required int pillarsTargetWidth,
}) {
  final out = img.Image(width: canvasSize, height: canvasSize, numChannels: 4);
  for (int y = 0; y < canvasSize; y++) {
    for (int x = 0; x < canvasSize; x++) {
      out.setPixelRgba(x, y, 0, 0, 0, 0);
    }
  }

  final aspect = pillars.height / pillars.width;
  final targetH = (pillarsTargetWidth * aspect).round();
  final resized = img.copyResize(pillars, width: pillarsTargetWidth, height: targetH, interpolation: img.Interpolation.cubic);

  final ox = (canvasSize - pillarsTargetWidth) ~/ 2;
  final oy = (canvasSize - targetH) ~/ 2;
  img.compositeImage(out, resized, dstX: ox, dstY: oy);
  return out;
}

img.Image _createFullIcon({
  required img.Image pillars,
  required img.Color bgColor,
  required int canvasSize,
  required int pillarsTargetWidth,
}) {
  final out = img.Image(width: canvasSize, height: canvasSize, numChannels: 4);
  img.fill(out, color: bgColor);

  final aspect = pillars.height / pillars.width;
  final targetH = (pillarsTargetWidth * aspect).round();
  final resized = img.copyResize(pillars, width: pillarsTargetWidth, height: targetH, interpolation: img.Interpolation.cubic);

  final ox = (canvasSize - pillarsTargetWidth) ~/ 2;
  final oy = (canvasSize - targetH) ~/ 2;
  img.compositeImage(out, resized, dstX: ox, dstY: oy);
  return out;
}

img.Image _createNotificationLargeIcon({
  required img.Image pillars,
  required img.Color bgColor,
  required int canvasSize,
  required int pillarsTargetWidth,
}) {
  final out = img.Image(width: canvasSize, height: canvasSize, numChannels: 4);
  final radius = canvasSize * 0.22;
  final center = canvasSize / 2.0;

  // Fill squircle background
  for (int y = 0; y < canvasSize; y++) {
    for (int x = 0; x < canvasSize; x++) {
      final dx = (x < center) ? (radius - x).clamp(0.0, radius) : (x - (canvasSize - 1 - radius)).clamp(0.0, radius);
      final dy = (y < center) ? (radius - y).clamp(0.0, radius) : (y - (canvasSize - 1 - radius)).clamp(0.0, radius);

      if (dx > 0 && dy > 0) {
        final dist = dx * dx + dy * dy;
        if (dist > (radius + 0.5) * (radius + 0.5)) {
          out.setPixelRgba(x, y, 0, 0, 0, 0);
        } else if (dist < (radius - 0.5) * (radius - 0.5)) {
          out.setPixel(x, y, bgColor);
        } else {
          final t = (radius + 0.5 - (dx * dx + dy * dy)) / 1.0;
          final a = (255 * t).round().clamp(0, 255);
          out.setPixelRgba(x, y, bgColor.r.toInt(), bgColor.g.toInt(), bgColor.b.toInt(), a);
        }
      } else {
        out.setPixel(x, y, bgColor);
      }
    }
  }

  // Draw centered pillars
  final aspect = pillars.height / pillars.width;
  final targetH = (pillarsTargetWidth * aspect).round();
  final resized = img.copyResize(pillars, width: pillarsTargetWidth, height: targetH, interpolation: img.Interpolation.cubic);

  final ox = (canvasSize - pillarsTargetWidth) ~/ 2;
  final oy = (canvasSize - targetH) ~/ 2;
  img.compositeImage(out, resized, dstX: ox, dstY: oy);

  return out;
}

img.Image _createOrigamiSilhouette(img.Image cropped) {
  final isFoldMap = List.generate(
    cropped.height,
    (y) => List.generate(cropped.width, (x) {
      final p = cropped.getPixel(x, y);
      if (p.a <= 25) return null;
      return (p.r > 100 && p.g > 120);
    }),
  );

  final out = img.Image(width: cropped.width, height: cropped.height, numChannels: 4);
  const r = 2;

  for (int y = 0; y < cropped.height; y++) {
    for (int x = 0; x < cropped.width; x++) {
      final myFold = isFoldMap[y][x];
      if (myFold == null) {
        out.setPixelRgba(x, y, 0, 0, 0, 0);
        continue;
      }

      bool nearSeam = false;
      for (int dy = -r; dy <= r && !nearSeam; dy++) {
        for (int dx = -r; dx <= r && !nearSeam; dx++) {
          final ny = y + dy;
          final nx = x + dx;
          if (ny >= 0 && ny < cropped.height && nx >= 0 && nx < cropped.width) {
            final other = isFoldMap[ny][nx];
            if (other != null && other != myFold) {
              nearSeam = true;
            }
          }
        }
      }

      if (nearSeam) {
        out.setPixelRgba(x, y, 0, 0, 0, 0);
      } else {
        final srcA = cropped.getPixel(x, y).a.toInt();
        out.setPixelRgba(x, y, 255, 255, 255, srcA);
      }
    }
  }

  return out;
}

void _savePng(img.Image image, String path) {
  final file = File(path);
  file.parent.createSync(recursive: true);
  file.writeAsBytesSync(img.encodePng(image));
}

void _saveJpg(img.Image image, String path, {int quality = 90}) {
  final file = File(path);
  file.parent.createSync(recursive: true);
  file.writeAsBytesSync(img.encodeJpg(image, quality: quality));
}
