import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart'; // Added for WidgetsBindingObserver
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/habit/domain/habit_repository.dart';
import '../../features/habit/domain/habit_types.dart';
import '../../features/notifications/services/notification_service.dart';
import 'package:vibration/vibration.dart';

/// Zamanlayıcı modları
enum TimerMode { stopwatch, countdown, pomodoro }

class TimerSession {
  TimerSession({
    required this.mode,
    required this.duration,
    required this.startedAt,
    required this.endedAt,
    this.label,
    this.completed = true,
    this.assigned = false,
  });
  final TimerMode mode;
  final Duration duration;
  final DateTime startedAt;
  final DateTime endedAt;
  final String? label;
  final bool completed;
  bool assigned;

  /// JSON'a serialize et
  Map<String, dynamic> toJson() => {
    'mode': mode.index,
    'durationMs': duration.inMilliseconds,
    'startedAt': startedAt.toIso8601String(),
    'endedAt': endedAt.toIso8601String(),
    'label': label,
    'completed': completed,
    'assigned': assigned,
  };

  /// JSON'dan deserialize et
  factory TimerSession.fromJson(Map<String, dynamic> json) {
    return TimerSession(
      mode: TimerMode.values[json['mode'] as int],
      duration: Duration(milliseconds: json['durationMs'] as int),
      startedAt: DateTime.parse(json['startedAt'] as String),
      endedAt: DateTime.parse(json['endedAt'] as String),
      label: json['label'] as String?,
      completed: json['completed'] as bool? ?? true,
      assigned: json['assigned'] as bool? ?? false,
    );
  }
}

/// Paneldeki mini widget ve tam ekran zamanlayıcı arasında paylaşılan denetleyici.
class TimerController extends ChangeNotifier with WidgetsBindingObserver {
  TimerController._() {
    // Set up notification action handler
    NotificationService.instance.setTimerActionHandler(
      _handleNotificationAction,
    );
    // Initialize background service
    _initializeBackgroundService();
    // Setup MethodChannel for native timer actions
    _setupMethodChannel();
    // Session'ları yükle
    _loadSessions();
    // Timer state'ini yükle
    _loadState();

    // Lifecycle observer'ı ekle
    WidgetsBinding.instance.addObserver(this);
  }
  static final TimerController instance = TimerController._();

  static const String _sessionsKey = 'timer_sessions';
  static const String _stateKey = 'timer_state';
  static const int _maxSessionAgeDays = 7; // 1 hafta

  Timer? _timer;
  DateTime? _currentStart; // aktif çalışma başlangıç zamanı
  final FlutterBackgroundService _backgroundService =
      FlutterBackgroundService();
  static const MethodChannel _methodChannel = MethodChannel(
    'com.koralabs.mira/timer_actions',
  );

  // Hard Mode state
  bool _hardMode = false;
  bool get hardMode => _hardMode;

  void toggleHardMode() {
    _hardMode = !_hardMode;
    notifyListeners();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_hardMode &&
        isRunning &&
        (state == AppLifecycleState.paused ||
            state == AppLifecycleState.inactive)) {
      pause();
      // Opsiyonel: Kullanıcıya bildirim gönderilebilir veya loglanabilir
      print('Hard mode aktif: Uygulama terk edildiği için sayaç durduruldu.');
    }
  }

  void _setupMethodChannel() {
    _methodChannel.setMethodCallHandler((call) async {
      if (call.method == 'timerAction') {
        final action = call.arguments as String?;
        if (action != null) {
          print('📱 Received native timer action: $action');
          _handleNotificationAction(action);
        }
      }
    });
  }

  /// Session'ları SharedPreferences'tan yükle ve eski olanları temizle
  Future<void> _loadSessions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionsJson = prefs.getString(_sessionsKey);
      if (sessionsJson != null) {
        final List<dynamic> sessionsList = jsonDecode(sessionsJson);
        final now = DateTime.now();
        final cutoffDate = now.subtract(
          const Duration(days: _maxSessionAgeDays),
        );

        _sessions.clear();
        for (final item in sessionsList) {
          try {
            final session = TimerSession.fromJson(item as Map<String, dynamic>);
            // 1 haftadan eski olmayan session'ları ekle
            if (session.endedAt.isAfter(cutoffDate)) {
              _sessions.add(session);
            }
          } catch (e) {
            print('Error parsing session: $e');
          }
        }

        // Eski session'lar temizlendiyse kaydet
        await _saveSessions();
        notifyListeners();
      }
    } catch (e) {
      print('Error loading timer sessions: $e');
    }
  }

  /// Session'ları SharedPreferences'a kaydet
  Future<void> _saveSessions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionsList = _sessions.map((s) => s.toJson()).toList();
      await prefs.setString(_sessionsKey, jsonEncode(sessionsList));
    } catch (e) {
      print('Error saving timer sessions: $e');
    }
  }

  /// Timer state'ini yükle
  Future<void> _loadState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stateJson = prefs.getString(_stateKey);
      if (stateJson != null) {
        final state = jsonDecode(stateJson) as Map<String, dynamic>;

        // Active mode
        _activeMode = TimerMode.values[state['activeMode'] as int? ?? 0];

        // Stopwatch state
        _elapsed = Duration(milliseconds: state['elapsed'] as int? ?? 0);

        // Countdown state
        _countdownTotal = Duration(
          milliseconds: state['countdownTotal'] as int? ?? 0,
        );
        _countdownRemaining = Duration(
          milliseconds: state['countdownRemaining'] as int? ?? 0,
        );

        // Pomodoro state
        _pomodoroWorkPhase = state['pomodoroWorkPhase'] as bool? ?? true;
        _pomodoroWorkDuration = Duration(
          milliseconds: state['pomodoroWorkDuration'] as int? ?? 25 * 60 * 1000,
        );
        _pomodoroShortBreak = Duration(
          milliseconds: state['pomodoroShortBreak'] as int? ?? 5 * 60 * 1000,
        );
        _pomodoroLongBreak = Duration(
          milliseconds: state['pomodoroLongBreak'] as int? ?? 15 * 60 * 1000,
        );
        _pomodoroRemaining = Duration(
          milliseconds: state['pomodoroRemaining'] as int? ?? 25 * 60 * 1000,
        );
        _pomodoroCompletedWorkSessions =
            state['pomodoroCompletedWorkSessions'] as int? ?? 0;
        _pomodoroLongBreakInterval =
            state['pomodoroLongBreakInterval'] as int? ?? 4;

        // Active timer habit
        _activeTimerHabitId = state['activeTimerHabitId'] as String?;

        // Pending duration
        _pending = Duration(milliseconds: state['pending'] as int? ?? 0);

        // Eğer timer durmuş haldeyse state'i yükle ama otomatik başlatma
        // Kullanıcı manuel olarak tekrar başlatmalı

        notifyListeners();
      }
    } catch (e) {
      print('Error loading timer state: $e');
    }
  }

  /// Timer state'ini kaydet
  Future<void> _saveState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final state = {
        'activeMode': _activeMode.index,
        'elapsed': _elapsed.inMilliseconds,
        'countdownTotal': _countdownTotal.inMilliseconds,
        'countdownRemaining': _countdownRemaining.inMilliseconds,
        'pomodoroWorkPhase': _pomodoroWorkPhase,
        'pomodoroWorkDuration': _pomodoroWorkDuration.inMilliseconds,
        'pomodoroShortBreak': _pomodoroShortBreak.inMilliseconds,
        'pomodoroLongBreak': _pomodoroLongBreak.inMilliseconds,
        'pomodoroRemaining': _pomodoroRemaining.inMilliseconds,
        'pomodoroCompletedWorkSessions': _pomodoroCompletedWorkSessions,
        'pomodoroLongBreakInterval': _pomodoroLongBreakInterval,
        'activeTimerHabitId': _activeTimerHabitId,
        'pending': _pending.inMilliseconds,
      };
      await prefs.setString(_stateKey, jsonEncode(state));
    } catch (e) {
      print('Error saving timer state: $e');
    }
  }

  // Stopwatch (kronometre)
  Duration _elapsed = Duration.zero;
  bool _stopwatchRunning = false;

  // Countdown (geri sayım)
  Duration _countdownTotal = Duration.zero;
  Duration _countdownRemaining = Duration.zero;
  bool _countdownRunning = false;

  // State save counter - save every 5 seconds during running
  int _tickCounter = 0;

  // Pomodoro
  bool _pomodoroRunning = false;
  bool _pomodoroWorkPhase = true; // true = çalışma, false = mola
  Duration _pomodoroWorkDuration = const Duration(minutes: 25);
  Duration _pomodoroShortBreak = const Duration(minutes: 5);
  Duration _pomodoroLongBreak = const Duration(minutes: 15);
  Duration _pomodoroRemaining = const Duration(minutes: 25);
  int _pomodoroCompletedWorkSessions = 0; // biten çalışma sayısı
  int _pomodoroLongBreakInterval = 4; // kaç çalışma sonra uzun mola

  TimerMode _activeMode = TimerMode.stopwatch;
  final List<TimerSession> _sessions = [];
  String? _activeTimerHabitId; // Oturumların yazılacağı timer habit id'si
  Duration _pending = Duration.zero; // Henüz habit'e aktarılmamış süre toplamı

  List<TimerSession> get sessions => List.unmodifiable(_sessions);
  String? get activeTimerHabitId => _activeTimerHabitId;
  Duration get pendingDuration => _pending;
  bool get hasPending => _pending > Duration.zero;

  void setActiveTimerHabit(String? habitId) {
    _activeTimerHabitId = habitId;
    _saveState();
    notifyListeners();
  }

  // Getters
  TimerMode get activeMode => _activeMode;
  Duration get elapsed => _elapsed;
  bool get isRunning => switch (_activeMode) {
    TimerMode.stopwatch => _stopwatchRunning,
    TimerMode.countdown => _countdownRunning,
    TimerMode.pomodoro => _pomodoroRunning,
  };

  Duration get countdownRemaining => _countdownRemaining;
  Duration get countdownTotal => _countdownTotal;

  Duration get pomodoroRemaining => _pomodoroRemaining;
  bool get pomodoroWorkPhase => _pomodoroWorkPhase;
  int get pomodoroCompletedWorkSessions => _pomodoroCompletedWorkSessions;
  Duration get pomodoroWorkDuration => _pomodoroWorkDuration;
  Duration get pomodoroShortBreakDuration => _pomodoroShortBreak;
  Duration get pomodoroLongBreakDuration => _pomodoroLongBreak;
  int get pomodoroLongBreakInterval => _pomodoroLongBreakInterval;

  bool get hasCountdown => _countdownTotal > Duration.zero;

  /// Aktif veya o an çalışan modun ekranda gösterilecek formatlı süresi.
  String get formattedTime {
    if (_pomodoroRunning) return _format(_pomodoroRemaining);
    if (_countdownRunning) return _format(_countdownRemaining);
    return _format(_elapsed);
  }

  String formatDuration(Duration d) => _format(d);

  String _format(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hours = d.inHours.toString().padLeft(2, '0');
    // Her zaman saat:dakika:saniye göster (00:MM:SS)
    return '$hours:$minutes:$seconds';
  }

  // MODE SELECTION
  void setMode(TimerMode mode) {
    if (_activeMode == mode) return;
    _stopAll();
    _activeMode = mode;
    _currentStart = DateTime.now();
    _saveState();
    notifyListeners();
  }

  void _stopAll() {
    _timer?.cancel();
    _stopwatchRunning = false;
    _countdownRunning = false;
    _pomodoroRunning = false;
  }

  // STOPWATCH API (geriye dönük uyumluluk)
  void start() {
    setMode(TimerMode.stopwatch);
    if (_stopwatchRunning) return;
    _stopwatchRunning = true;
    // Eğer daha önce başlamış ve pause edilmişse _currentStart null ise yeniden başlat
    _currentStart ??= DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
    _updateNotification();
    _startBackgroundService();
    _saveState();
    notifyListeners();
  }

  void pause() {
    switch (_activeMode) {
      case TimerMode.stopwatch:
        if (!_stopwatchRunning) return;
        // Kaydetme yok, sadece durdur
        _currentStart = null;
        _stopwatchRunning = false;
        break;
      case TimerMode.countdown:
        if (!_countdownRunning) return;
        _countdownRunning = false;
        break;
      case TimerMode.pomodoro:
        if (!_pomodoroRunning) return;
        _pomodoroRunning = false;
        break;
    }
    _timer?.cancel();
    _updateNotification();
    _stopBackgroundService();
    _saveState();
    notifyListeners();
  }

  void reset() {
    switch (_activeMode) {
      case TimerMode.stopwatch:
        // Kayıt yapmadan sıfırla
        _elapsed = Duration.zero;
        _stopwatchRunning = false;
        _currentStart = null;
        break;
      case TimerMode.countdown:
        _countdownRemaining = _countdownTotal;
        _countdownRunning = false;
        break;
      case TimerMode.pomodoro:
        _pomodoroReset(full: true);
        break;
    }
    _timer?.cancel();
    NotificationService.instance.cancelTimerNotification();
    _stopBackgroundService();
    _saveState();
    notifyListeners();
  }

  // COUNTDOWN API
  void setCountdown(Duration duration) {
    _countdownTotal = duration;
    _countdownRemaining = duration;
    _saveState();
    notifyListeners();
  }

  void startCountdown() {
    if (_countdownTotal == Duration.zero) return; // ayarlanmamış
    setMode(TimerMode.countdown);
    if (_countdownRunning) return;
    _countdownRunning = true;
    _currentStart ??= DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
    _updateNotification();
    _startBackgroundService();
    _saveState();
    notifyListeners();
  }

  // POMODORO API
  void startPomodoro() {
    setMode(TimerMode.pomodoro);
    if (_pomodoroRunning) return;
    _pomodoroRunning = true;
    _currentStart ??= DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
    _updateNotification();
    _startBackgroundService();
    _saveState();
    notifyListeners();
  }

  void skipPomodoroPhase() {
    if (_activeMode != TimerMode.pomodoro) return;
    _advancePomodoroPhase();
    _saveState();
    notifyListeners();
  }

  void setPomodoroConfig({
    required Duration work,
    required Duration shortBreak,
    required Duration longBreak,
    required int longBreakInterval,
  }) {
    // Minimum değerleri garanti altına al
    if (work.inMinutes < 1) work = const Duration(minutes: 1);
    if (shortBreak.inMinutes < 1) shortBreak = const Duration(minutes: 1);
    if (longBreak.inMinutes < 1) longBreak = const Duration(minutes: 1);
    if (longBreakInterval < 1) longBreakInterval = 1;

    _pomodoroWorkDuration = work;
    _pomodoroShortBreak = shortBreak;
    _pomodoroLongBreak = longBreak;
    _pomodoroLongBreakInterval = longBreakInterval;

    // Çalışma fazındaysak kalan süreyi yeni çalışma süresine güncelle
    if (_activeMode == TimerMode.pomodoro) {
      if (_pomodoroWorkPhase) {
        _pomodoroRemaining = _pomodoroWorkDuration;
      } else {
        // Mola fazındaysa uygun mola süresine ayarla
        final isLong =
            _pomodoroCompletedWorkSessions % _pomodoroLongBreakInterval == 0 &&
            _pomodoroCompletedWorkSessions > 0;
        _pomodoroRemaining = isLong ? _pomodoroLongBreak : _pomodoroShortBreak;
      }
    }
    _saveState();
    notifyListeners();
  }

  void _pomodoroReset({bool full = false}) {
    _pomodoroRunning = false;
    if (full) {
      _pomodoroCompletedWorkSessions = 0;
      _pomodoroWorkPhase = true;
    }
    _pomodoroRemaining = _pomodoroWorkDuration;
  }

  void _advancePomodoroPhase() {
    if (_pomodoroWorkPhase) {
      // Çalışma bitti -> mola
      _pomodoroCompletedWorkSessions++;
      // Çalışma oturumunu kaydet
      _recordSession(
        TimerMode.pomodoro,
        _pomodoroWorkDuration,
        label: 'Çalışma',
      );
      _pomodoroWorkPhase = false;
      final isLongBreak =
          _pomodoroCompletedWorkSessions % _pomodoroLongBreakInterval == 0;
      _pomodoroRemaining = isLongBreak
          ? _pomodoroLongBreak
          : _pomodoroShortBreak;
    } else {
      // Mola bitti -> çalışma
      // (İstersen mola oturumlarını ekleyebilirsin)
      _pomodoroWorkPhase = true;
      _pomodoroRemaining = _pomodoroWorkDuration;
      _currentStart = DateTime.now();
    }
  }

  // TICK
  void _onTick(Timer timer) {
    switch (_activeMode) {
      case TimerMode.stopwatch:
        if (_stopwatchRunning) {
          _elapsed += const Duration(seconds: 1);
        }
        break;
      case TimerMode.countdown:
        if (_countdownRunning) {
          if (_countdownRemaining > Duration.zero) {
            _countdownRemaining -= const Duration(seconds: 1);
            if (_countdownRemaining < Duration.zero) {
              _countdownRemaining = Duration.zero;
            }
            if (_countdownRemaining == Duration.zero) {
              _countdownRunning = false;
              _timer?.cancel();
              // Otomatik kayıt yok; kullanıcı Bitir'e basınca kaydedilecek
            }
          }
        }
        break;
      case TimerMode.pomodoro:
        if (_pomodoroRunning) {
          if (_pomodoroRemaining > Duration.zero) {
            _pomodoroRemaining -= const Duration(seconds: 1);
            if (_pomodoroRemaining <= Duration.zero) {
              _pomodoroRemaining = Duration.zero;
              // Vibrate on completion
              Vibration.vibrate();
              // Automatically advance to next phase (auto-continue)
              _advancePomodoroPhase();
            }
          }
        }
        break;
    }
    // _updateNotification(); // REMOVED: Managed by state changes (Start/Pause) using Native Chronometer
    _tickCounter++;
    if (_tickCounter >= 5) {
      _tickCounter = 0;
      _saveState();
    }

    notifyListeners();
  }

  void _handleNotificationAction(String action) {
    print('🔔 Notification action received: $action');
    switch (action) {
      case 'pause':
        print('⏸️ Pausing timer...');
        pause();
        break;
      case 'resume':
        print('▶️ Resuming timer...');
        switch (_activeMode) {
          case TimerMode.stopwatch:
            start();
            break;
          case TimerMode.countdown:
            startCountdown();
            break;
          case TimerMode.pomodoro:
            startPomodoro();
            break;
        }
        break;
      case 'stop':
        print('⏹️ Stopping and saving timer...');
        finish(); // Changed from reset() to finish() to save the session
        break;
      default:
        print('❌ Unknown action: $action');
    }
  }

  void _updateNotification() {
    final String modeLabel = switch (_activeMode) {
      TimerMode.stopwatch => 'Kronometre',
      TimerMode.countdown => 'Geri Sayım',
      TimerMode.pomodoro =>
        _pomodoroWorkPhase ? 'Pomodoro - Çalışma' : 'Pomodoro - Mola',
    };

    // If waiting/paused, just show static time
    if (!isRunning) {
      NotificationService.instance.showTimerNotification(
        title: modeLabel,
        body: formattedTime, // Static time
        isRunning: false,
        usesChronometer: false,
      );
      return;
    }

    // Calculating 'when' for Chronometer
    int? when;
    bool usesChronometer = true;
    bool chronometerCountDown = false;

    final now = DateTime.now().millisecondsSinceEpoch;

    if (_activeMode == TimerMode.stopwatch) {
      // Stopwatch: counts UP from start.
      // when = now - elapsed
      when = now - _elapsed.inMilliseconds;
      chronometerCountDown = false;
    } else if (_activeMode == TimerMode.countdown) {
      // Countdown: counts DOWN to end.
      // when = now + remaining
      when = now + _countdownRemaining.inMilliseconds;
      chronometerCountDown = true;
    } else if (_activeMode == TimerMode.pomodoro) {
      // Pomodoro: counts DOWN to end.
      when = now + _pomodoroRemaining.inMilliseconds;
      chronometerCountDown = true;
    }

    NotificationService.instance.showTimerNotification(
      title: modeLabel,
      body: _activeMode == TimerMode.stopwatch
          ? 'Zaman geçiyor...'
          : 'Kalan süre',
      isRunning: true,
      when: when,
      usesChronometer: usesChronometer,
      chronometerCountDown: chronometerCountDown,
    );
  }

  /// Bitir: O anki süreyi oturum olarak kaydet (pending'e eklemeyen)
  void finish() {
    switch (_activeMode) {
      case TimerMode.stopwatch:
        if (_elapsed > Duration.zero) {
          _recordSession(
            TimerMode.stopwatch,
            _elapsed,
            completed: true,
            addToPending: false,
          );
        }
        _elapsed = Duration.zero;
        _stopwatchRunning = false;
        _currentStart = null;
        break;
      case TimerMode.countdown:
        final done = _countdownTotal - _countdownRemaining;
        if (done > Duration.zero) {
          _recordSession(
            TimerMode.countdown,
            done,
            completed: true,
            addToPending: false,
          );
        }
        _countdownRunning = false;
        _countdownRemaining = _countdownTotal;
        break;
      case TimerMode.pomodoro:
        if (_pomodoroWorkPhase) {
          final done = _pomodoroWorkDuration - _pomodoroRemaining;
          if (done > Duration.zero) {
            _recordSession(
              TimerMode.pomodoro,
              done,
              label: 'Çalışma',
              completed: true,
              addToPending: false,
            );
          }
        }
        _pomodoroRunning = false;
        _pomodoroReset(full: false);
        break;
    }
    _timer?.cancel();
    NotificationService.instance.cancelTimerNotification();
    _stopBackgroundService();
    _saveState();
    notifyListeners();
  }

  void _recordSession(
    TimerMode mode,
    Duration duration, {
    String? label,
    bool completed = true,
    bool addToPending = true,
  }) {
    if (duration <= Duration.zero) return;
    final end = DateTime.now();
    final start = _currentStart ?? end.subtract(duration);
    _sessions.insert(
      0,
      TimerSession(
        mode: mode,
        duration: duration,
        startedAt: start,
        endedAt: end,
        label: label,
        completed: completed,
      ),
    );
    // trim optional (keep last 200)
    if (_sessions.length > 200) {
      _sessions.removeRange(200, _sessions.length);
    }
    _currentStart = null;
    // Opsiyonel: pending'e ekle (finish için false gönderilir)
    if (addToPending) {
      _pending += duration;
    }
    // Session'ları kalıcı olarak kaydet
    _saveSessions();
    notifyListeners();
  }

  void clearHistory() {
    _sessions.clear();
    _saveSessions();
    notifyListeners();
  }

  /// Remove a session at [index] from history. Safe no-op if index is out of
  /// range.
  void removeSessionAt(int index) {
    if (index < 0 || index >= _sessions.length) return;
    _sessions.removeAt(index);
    _saveSessions();
    notifyListeners();
  }

  Future<bool> assignSessionToHabit(int index, String habitId) async {
    if (index < 0 || index >= _sessions.length) return false;
    final session = _sessions[index];
    if (session.assigned) return false; // zaten kaydedildi
    final repo = HabitRepository.instance;
    final habit = repo.findById(habitId);
    if (habit == null || habit.habitType != HabitType.timer) return false;
    // Habit'e süre ekle
    repo.addTimerProgress(habitId, session.duration);
    session.assigned = true;
    // Pendingten düş
    if (_pending >= session.duration) {
      _pending -= session.duration;
    } else {
      _pending = Duration.zero;
    }
    // Session güncellemesini kaydet
    _saveSessions();
    _saveState();
    notifyListeners();
    return true;
  }

  Future<void> savePendingToHabit(String habitId) async {
    final repo = HabitRepository.instance;
    final habit = repo.findById(habitId);
    if (habit == null || habit.habitType != HabitType.timer) return;

    // Include any elapsed time from current stopwatch session that hasn't been finished yet
    Duration totalToSave = _pending;
    if (_activeMode == TimerMode.stopwatch && _elapsed > Duration.zero) {
      totalToSave += _elapsed;
      // Reset elapsed since we're saving it
      _elapsed = Duration.zero;
      _stopwatchRunning = false;
      _currentStart = null;
      _timer?.cancel();
      NotificationService.instance.cancelTimerNotification();
      _stopBackgroundService();
    } else if (_activeMode == TimerMode.countdown) {
      // For countdown, save the time that has passed
      final done = _countdownTotal - _countdownRemaining;
      if (done > Duration.zero) {
        totalToSave += done;
        _countdownRemaining = _countdownTotal;
        _countdownRunning = false;
        _timer?.cancel();
        NotificationService.instance.cancelTimerNotification();
        _stopBackgroundService();
      }
    }

    if (totalToSave <= Duration.zero) return;

    repo.addTimerProgress(habitId, totalToSave);
    _pending = Duration.zero;
    _saveState();
    notifyListeners();
  }

  void discardPending() {
    if (_pending <= Duration.zero) return;
    _pending = Duration.zero;
    _saveState();
    notifyListeners();
  }

  // Background Service Methods
  Future<void> _initializeBackgroundService() async {
    try {
      await _backgroundService.configure(
        iosConfiguration: IosConfiguration(
          autoStart: false,
          onForeground: onStart,
          onBackground: onIosBackground,
        ),
        androidConfiguration: AndroidConfiguration(
          onStart: onStart,
          isForegroundMode: true,
          autoStart: false,
          autoStartOnBoot: false,
        ),
      );
    } catch (e) {
      print('Background service initialization error: $e');
    }
  }

  Future<void> _startBackgroundService() async {
    try {
      final isRunning = await _backgroundService.isRunning();
      if (!isRunning) {
        await _backgroundService.startService();
      }
    } catch (e) {
      print('Failed to start background service: $e');
    }
  }

  Future<void> _stopBackgroundService() async {
    try {
      final isRunning = await _backgroundService.isRunning();
      if (isRunning) {
        _backgroundService.invoke('stop');
      }
    } catch (e) {
      print('Failed to stop background service: $e');
    }
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) {
    // This will be executed when the service starts
    if (service is AndroidServiceInstance) {
      service.on('stop').listen((event) {
        service.stopSelf();
      });
    }

    // Keep the service alive
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (service is AndroidServiceInstance) {
        if (!await service.isForegroundService()) {
          timer.cancel();
          return;
        }
      }
      // Service is running, timer controller handles the actual timer logic
    });
  }

  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    return true;
  }
}
