import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/habit/domain/habit_model.dart';
import '../features/habit/domain/habit_repository.dart';
import '../features/mood/data/mood_entry.dart';
import '../features/mood/data/mood_repository.dart';
import '../features/finance/data/transaction_model.dart';
import '../features/finance/data/transaction_repository.dart';
import '../features/rhythm/domain/live_rhythm_model.dart';
import '../features/rhythm/domain/live_rhythm_repository.dart';
import '../design_system/theme/theme_variations.dart';

/// Service for managing home screen widgets data
/// Communicates with native iOS (WidgetKit) and Android (Glance) widgets
class HomeWidgetService {
  HomeWidgetService._();
  static final HomeWidgetService instance = HomeWidgetService._();

  // App Group identifier for iOS
  static const String _iOSAppGroupId = 'group.com.mira.widgets';
  // Android widget provider class name
  // ignore: unused_field
  static const String _androidWidgetProvider = 'MiraWidgetReceiver';

  // Storage keys for theme
  static const String _themeVariantKey = 'selected_theme_variant';

  // ============ WIDGET DATA KEYS ============

  // Theme data keys
  static const String keyThemeIsDark = 'theme_is_dark';
  static const String keyThemePrimaryColor = 'theme_primary_color';
  static const String keyThemeLightBg = 'theme_light_bg';
  static const String keyThemeLightSurface = 'theme_light_surface';
  static const String keyThemeDarkBg = 'theme_dark_bg';
  static const String keyThemeDarkSurface = 'theme_dark_surface';

  // Live Rhythm widget keys
  static const String keyRhythmWindow = 'rhythm_window';
  static const String keyRhythmEmoji = 'rhythm_emoji';
  static const String keyRhythmWindowName = 'rhythm_window_name';
  static const String keyRhythmNextTransition = 'rhythm_next_transition';
  static const String keyFocusHabitName = 'focus_habit_name';
  static const String keyFocusHabitEmoji = 'focus_habit_emoji';
  static const String keyFocusHabitProgress = 'focus_habit_progress';
  static const String keyFocusHabitTarget = 'focus_habit_target';
  static const String keyFocusHabitAiMessage = 'focus_habit_ai_message';

  // Finance widget keys
  static const String keyFinanceIncome = 'finance_income';
  static const String keyFinanceExpense = 'finance_expense';
  static const String keyFinanceBalance = 'finance_balance';
  static const String keyFinanceCurrency = 'finance_currency';

  // Mood widget keys
  static const String keyMoodValue = 'mood_value';
  static const String keyMoodEmoji = 'mood_emoji';
  static const String keyMoodLabel = 'mood_label';
  static const String keyMoodNote = 'mood_note';
  static const String keyMoodHasEntry = 'mood_has_entry';

  // Streak widget keys
  static const String keyHabitStreaks = 'habit_streaks'; // JSON array
  static const String keySingleHabitId = 'single_habit_id';
  static const String keySingleHabitName = 'single_habit_name';
  static const String keySingleHabitEmoji = 'single_habit_emoji';
  static const String keySingleHabitStreak = 'single_habit_streak';

  // ============ INITIALIZATION ============

  /// Initialize the home widget service
  Future<void> initialize() async {
    try {
      // Set up iOS App Group
      await HomeWidget.setAppGroupId(_iOSAppGroupId);

      // Register for widget click callbacks
      HomeWidget.widgetClicked.listen(_onWidgetClicked);

      debugPrint('[HomeWidget] Service initialized');
      // Force update all widgets to ensure data is populated
      await updateAllWidgets();
    } catch (e) {
      debugPrint('[HomeWidget] Error initializing: $e');
    }
  }

  void _onWidgetClicked(Uri? uri) {
    if (uri == null) return;
    debugPrint('[HomeWidget] Widget clicked: $uri');
    // Handle navigation based on URI
    // e.g., mira://habit, mira://finance, mira://mood
  }

  /// Helper to save data to both SharedPreferences (for Android/Flutter) and HomeWidget (for iOS)
  /// Note: For Android native widget compatibility, we store numeric values as strings
  /// because Flutter's shared_preferences encodes doubles in a way incompatible with native getFloat()
  Future<void> _saveData(String key, dynamic value) async {
    try {
      // 1. Save to SharedPreferences (standard Flutter storage, used by Android Native)
      final prefs = await SharedPreferences.getInstance();

      // Convert all types to String for Android native compatibility
      String stringValue;
      if (value is String) {
        stringValue = value;
      } else if (value is bool) {
        stringValue = value.toString();
      } else if (value is int) {
        stringValue = value.toString();
      } else if (value is double) {
        stringValue = value.toString();
      } else {
        stringValue = value.toString();
      }

      await prefs.setString(key, stringValue);

      // 2. Save to HomeWidget (for iOS App Groups)
      await HomeWidget.saveWidgetData(key, value);
    } catch (e) {
      debugPrint('[HomeWidget] Error saving data for key $key: $e');
    }
  }

  // ============ THEME DATA ============

  /// Update theme data for all widgets
  Future<void> updateThemeData({bool? isDark}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final variantName = prefs.getString(_themeVariantKey);

      ThemeVariant variant = ThemeVariant.cotton;
      if (variantName != null) {
        try {
          variant = ThemeVariant.values.firstWhere(
            (v) => v.name == variantName,
            orElse: () => ThemeVariant.cotton,
          );
        } catch (_) {}
      }

      final config = variant.config;

      // Store theme colors as hex strings for native side
      await _saveData(keyThemeIsDark, isDark ?? false);
      await _saveData(
        keyThemePrimaryColor,
        _colorToHex(config.primary),
      );
      await _saveData(
        keyThemeLightBg,
        _colorToHex(config.lightBackground),
      );
      await _saveData(
        keyThemeLightSurface,
        _colorToHex(config.lightSurface),
      );
      await _saveData(
        keyThemeDarkBg,
        _colorToHex(config.darkBackground),
      );
      await _saveData(
        keyThemeDarkSurface,
        _colorToHex(config.darkSurface),
      );

      debugPrint('[HomeWidget] Theme data updated: ${variant.name}');
    } catch (e) {
      debugPrint('[HomeWidget] Error updating theme: $e');
    }
  }

  String _colorToHex(dynamic color) {
    // Handle Color object - extract RGB values
    if (color is int) {
      return '#${color.toRadixString(16).padLeft(8, '0').substring(2)}';
    }
    // Assume it's a Color object
    try {
      final r = ((color.r ?? color.red) * 255).round();
      final g = ((color.g ?? color.green) * 255).round();
      final b = ((color.b ?? color.blue) * 255).round();
      return '#${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}';
    } catch (e) {
      return '#5B6B4F'; // Default seed color
    }
  }

  // ============ LIVE RHYTHM WIDGET ============

  /// Update Live Rhythm widget data
  Future<void> updateRhythmWidget() async {
    try {
      final repo = LiveRhythmRepository.instance;
      await repo.initialize();

      final profile = repo.profile;
      final currentWindow = profile?.getCurrentWindow();
      final nextTransition = profile?.getNextTransition();

      // Get focus habit
      final habitRepo = HabitRepository.instance;
      await habitRepo.initialize();
      final focusHabit = habitRepo.habits.cast<Habit?>().firstWhere(
            (h) => h?.isFocus == true,
            orElse: () => null,
          );

      // Save rhythm data
      await _saveData(
        keyRhythmWindow,
        currentWindow?.name ?? 'reflection',
      );
      await _saveData(
        keyRhythmEmoji,
        _getWindowEmoji(currentWindow),
      );
      await _saveData(
        keyRhythmWindowName,
        _getWindowNameTr(currentWindow),
      );
      await _saveData(
        keyRhythmNextTransition,
        nextTransition?.toIso8601String() ?? '',
      );

      // Save focus habit data
      if (focusHabit != null) {
        await _saveData(keyFocusHabitName, focusHabit.title);
        await _saveData(
          keyFocusHabitEmoji,
          focusHabit.emoji ?? '📌',
        );
        await _saveData(
          keyFocusHabitProgress,
          focusHabit.currentStreak,
        );
        await _saveData(
          keyFocusHabitTarget,
          focusHabit.targetCount,
        );
        await _saveData(
          keyFocusHabitAiMessage,
          focusHabit.focusMessage ?? '',
        );
      } else {
        await _saveData(keyFocusHabitName, '');
        await _saveData(keyFocusHabitEmoji, '');
        await _saveData(keyFocusHabitProgress, 0);
        await _saveData(keyFocusHabitTarget, 1);
        await _saveData(keyFocusHabitAiMessage, '');
      }

      await _updateAndroidWidget('LiveRhythmWidgetReceiver');
      await _updateIOSWidget('LiveRhythmWidget');

      debugPrint('[HomeWidget] Rhythm widget updated');
    } catch (e) {
      debugPrint('[HomeWidget] Error updating rhythm widget: $e');
    }
  }

  String _getWindowEmoji(RhythmWindow? window) {
    return switch (window) {
      RhythmWindow.focus => '🧠',
      RhythmWindow.energy => '⚡',
      RhythmWindow.light => '🌤️',
      RhythmWindow.reflection => '🌙',
      null => '🌙',
    };
  }

  String _getWindowNameTr(RhythmWindow? window) {
    return switch (window) {
      RhythmWindow.focus => 'Odak Zamanı',
      RhythmWindow.energy => 'Enerji Zamanı',
      RhythmWindow.light => 'Hafif Zaman',
      RhythmWindow.reflection => 'Yansıma Zamanı',
      null => 'Yansıma Zamanı',
    };
  }

  // ============ FINANCE WIDGET ============

  /// Update Finance widget data
  Future<void> updateFinanceWidget() async {
    try {
      final repo = TransactionRepository();
      await repo.initialize();

      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final todayEnd = todayStart.add(const Duration(days: 1));

      final transactions = repo.forMonth(now);

      // Filter for today's transactions
      double income = 0;
      double expense = 0;

      for (final tx in transactions) {
        if (tx.date.isAfter(todayStart.subtract(const Duration(seconds: 1))) &&
            tx.date.isBefore(todayEnd)) {
          if (tx.type == TransactionType.income) {
            income += tx.amount;
          } else {
            expense += tx.amount;
          }
        }
      }

      await _saveData(keyFinanceIncome, income);
      await _saveData(keyFinanceExpense, expense);
      await _saveData(keyFinanceBalance, income - expense);
      await _saveData(keyFinanceCurrency, '₺');

      await _updateAndroidWidget('FinanceWidgetReceiver');
      await _updateIOSWidget('FinanceWidget');

      debugPrint('[HomeWidget] Finance widget updated: +$income -$expense');
    } catch (e) {
      debugPrint('[HomeWidget] Error updating finance widget: $e');
    }
  }

  // ============ MOOD WIDGET ============

  /// Update Mood widget data
  Future<void> updateMoodWidget() async {
    try {
      final repo = MoodRepository();
      await repo.initialize();

      final today = DateTime.now();
      final entry = repo.getForDate(today);

      if (entry != null) {
        await _saveData(keyMoodHasEntry, true);
        await _saveData(keyMoodValue, entry.mood.score);
        await _saveData(keyMoodEmoji, _getMoodEmoji(entry.mood));
        await _saveData(keyMoodLabel, _getMoodLabel(entry.mood));
        await _saveData(keyMoodNote, entry.note ?? '');
      } else {
        await _saveData(keyMoodHasEntry, false);
        await _saveData(keyMoodValue, 0);
        await _saveData(keyMoodEmoji, '❓');
        await _saveData(keyMoodLabel, 'Henüz kayıt yok');
        await _saveData(keyMoodNote, '');
      }

      await _updateAndroidWidget('MoodWidgetReceiver');
      await _updateIOSWidget('MoodWidget');

      debugPrint('[HomeWidget] Mood widget updated');
    } catch (e) {
      debugPrint('[HomeWidget] Error updating mood widget: $e');
    }
  }

  String _getMoodEmoji(MoodValue mood) {
    return switch (mood) {
      MoodValue.terrible => '😢',
      MoodValue.bad => '😞',
      MoodValue.ok => '😐',
      MoodValue.good => '😊',
      MoodValue.great => '🤩',
    };
  }

  String _getMoodLabel(MoodValue mood) {
    return switch (mood) {
      MoodValue.terrible => 'Berbat',
      MoodValue.bad => 'Kötü',
      MoodValue.ok => 'İdare Eder',
      MoodValue.good => 'İyi',
      MoodValue.great => 'Harika',
    };
  }

  // ============ STREAK WIDGETS ============

  /// Update all streak widgets data
  Future<void> updateStreakWidgets() async {
    try {
      final repo = HabitRepository.instance;
      await repo.initialize();

      // Build streak data for all habits
      final streakList = <Map<String, dynamic>>[];
      for (final habit in repo.habits) {
        final streak = repo.consecutiveStreakFor(habit);
        if (streak > 0) {
          streakList.add({
            'id': habit.id,
            'name': habit.title,
            'emoji': habit.emoji ?? '📌',
            'streak': streak,
          });
        }
      }

      // Sort by streak descending
      streakList
          .sort((a, b) => (b['streak'] as int).compareTo(a['streak'] as int));

      await _saveData(keyHabitStreaks, jsonEncode(streakList));

      // Update single habit widget if configured
      final prefs = await SharedPreferences.getInstance();
      final singleHabitId = prefs.getString('widget_single_habit_id');

      if (singleHabitId != null) {
        final habit = repo.findById(singleHabitId);
        if (habit != null) {
          final streak = repo.consecutiveStreakFor(habit);
          await _saveData(keySingleHabitId, habit.id);
          await _saveData(keySingleHabitName, habit.title);
          await _saveData(keySingleHabitEmoji, habit.emoji ?? '📌');
          await _saveData(keySingleHabitStreak, streak);
        }
      }

      await _updateAndroidWidget('SingleStreakWidgetReceiver');
      await _updateAndroidWidget('AllStreaksWidgetReceiver');
      await _updateIOSWidget('SingleStreakWidget');
      await _updateIOSWidget('AllStreaksWidget');

      debugPrint(
          '[HomeWidget] Streak widgets updated: ${streakList.length} habits');
    } catch (e) {
      debugPrint('[HomeWidget] Error updating streak widgets: $e');
    }
  }

  /// Set the habit to display in single streak widget
  Future<void> setSingleStreakHabit(String habitId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('widget_single_habit_id', habitId);
    await updateStreakWidgets();
  }

  // ============ UPDATE ALL WIDGETS ============

  /// Update all widgets with latest data
  Future<void> updateAllWidgets({bool? isDark}) async {
    await updateThemeData(isDark: isDark);
    await updateRhythmWidget();
    await updateFinanceWidget();
    await updateMoodWidget();
    await updateStreakWidgets();
    debugPrint('[HomeWidget] All widgets updated');
  }

  // ============ PLATFORM-SPECIFIC UPDATES ============

  Future<void> _updateAndroidWidget(String widgetName) async {
    try {
      await HomeWidget.updateWidget(
        androidName: widgetName,
        qualifiedAndroidName: 'com.koralabs.mira.widgets.$widgetName',
      );
    } catch (e) {
      debugPrint('[HomeWidget] Android widget update error: $e');
    }
  }

  Future<void> _updateIOSWidget(String widgetName) async {
    try {
      await HomeWidget.updateWidget(
        iOSName: widgetName,
      );
    } catch (e) {
      debugPrint('[HomeWidget] iOS widget update error: $e');
    }
  }
}
