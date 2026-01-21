import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Repository for managing user token balance
class TokenRepository extends ChangeNotifier {
  TokenRepository._();
  static final TokenRepository instance = TokenRepository._();

  static const String _balanceKey = 'user_token_balance';
  static const int reportCost = 5; // 5 tokens per report

  int _balance = 0;
  bool _initialized = false;

  /// Current token balance
  int get balance => _balance;

  /// Whether user has enough tokens for a report
  bool get canAffordReport => _balance >= reportCost;

  /// Initialize repository
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      _balance = prefs.getInt(_balanceKey) ?? 0;
      _initialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('[TokenRepository] Error loading balance: $e');
    }
  }

  /// Add tokens (from rewarded ad)
  Future<void> addTokens(int amount) async {
    if (amount <= 0) return;

    _balance += amount;
    await _persist();
    notifyListeners();
    debugPrint('[TokenRepository] Added $amount tokens. Balance: $_balance');
  }

  /// Spend tokens for report
  Future<bool> spendTokens(int amount) async {
    if (_balance < amount) {
      debugPrint(
          '[TokenRepository] Not enough tokens. Have: $_balance, Need: $amount');
      return false;
    }

    _balance -= amount;
    await _persist();
    notifyListeners();
    debugPrint('[TokenRepository] Spent $amount tokens. Balance: $_balance');
    return true;
  }

  /// Spend tokens for a report (convenience method)
  Future<bool> spendForReport() async {
    return spendTokens(reportCost);
  }

  /// Persist balance to storage
  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_balanceKey, _balance);
    } catch (e) {
      debugPrint('[TokenRepository] Error persisting balance: $e');
    }
  }

  /// Reset balance (for testing/logout)
  Future<void> reset() async {
    _balance = 0;
    await _persist();
    notifyListeners();
  }
}
