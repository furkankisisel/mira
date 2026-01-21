import 'package:flutter/foundation.dart';
import 'token_repository.dart';

/// Service for handling rewarded ads and token rewards
/// Note: AdMob integration requires google_mobile_ads package
class RewardedAdService {
  RewardedAdService._();
  static final RewardedAdService instance = RewardedAdService._();

  bool _isAdLoaded = false;
  bool _isLoading = false;

  /// Whether an ad is ready to show
  bool get isAdReady => _isAdLoaded;

  /// Load a rewarded ad
  Future<void> loadAd() async {
    if (_isLoading || _isAdLoaded) return;

    _isLoading = true;

    // TODO: Implement actual AdMob loading
    // RewardedAd.load(
    //   adUnitId: 'ca-app-pub-xxxxx/yyyyy',
    //   request: const AdRequest(),
    //   rewardedAdLoadCallback: RewardedAdLoadCallback(
    //     onAdLoaded: (ad) { _rewardedAd = ad; _isAdLoaded = true; },
    //     onAdFailedToLoad: (error) { _isLoading = false; },
    //   ),
    // );

    // Simulated load for now
    await Future.delayed(const Duration(milliseconds: 500));
    _isAdLoaded = true;
    _isLoading = false;

    debugPrint('[RewardedAdService] Ad loaded (simulated)');
  }

  /// Show rewarded ad and earn 1 token
  /// Returns true if reward was granted
  Future<bool> showAdAndEarnToken() async {
    if (!_isAdLoaded) {
      await loadAd();
    }

    // TODO: Implement actual AdMob show
    // _rewardedAd?.show(onUserEarnedReward: (ad, reward) {
    //   TokenRepository.instance.addTokens(1);
    // });

    // Simulated ad watching
    debugPrint('[RewardedAdService] Showing ad (simulated)...');
    await Future.delayed(const Duration(seconds: 2)); // Simulate ad duration

    // Grant reward
    await TokenRepository.instance.addTokens(1);
    _isAdLoaded = false;

    // Preload next ad
    loadAd();

    debugPrint('[RewardedAdService] Reward granted: 1 token');
    return true;
  }

  /// Dispose resources
  void dispose() {
    // TODO: Dispose actual ad
    // _rewardedAd?.dispose();
  }
}
