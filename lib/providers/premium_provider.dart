import 'package:flutter/material.dart';
import '../services/premium_service.dart';

class PremiumProvider extends ChangeNotifier {
  final PremiumService _service = PremiumService();

  bool _isPremium = false;
  bool _loading = true;

  bool get isPremium => _isPremium;
  bool get isLoading => _loading;

  /// App açıldığında çağrılır
  Future<void> loadPremiumStatus() async {
    _loading = true;
    notifyListeners();

    try {
      _isPremium = await _service.checkIsPremium();
    } catch (_) {
      _isPremium = false;
    }

    _loading = false;
    notifyListeners();
  }

  /// Firebase'ten premium verildiğinde manuel refresh
  Future<void> refreshPremium() async {
    _isPremium = await _service.checkIsPremium(forceRefresh: true);
    notifyListeners();
  }

  /// Logout olunca
  void reset() {
    _isPremium = false;
    _loading = false;
    notifyListeners();
  }
}
