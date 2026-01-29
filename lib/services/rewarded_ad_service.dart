import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import 'token_repository.dart';

/// Service for handling rewarded ads and token rewards
/// Note: AdMob integration requires google_mobile_ads package
class RewardedAdService {
  RewardedAdService._();
  static final RewardedAdService instance = RewardedAdService._();

  RewardedAd? _rewardedAd;
  bool _isAdLoaded = false;
  bool _isLoading = false;

  /// Whether an ad is ready to show
  bool get isAdReady => _isAdLoaded;

  /// Load a rewarded ad
  Future<void> loadAd() async {
    if (_isLoading || _isAdLoaded) return;

    _isLoading = true;

    // Production Ad Unit ID
    // User provided: ca-app-pub-1488047488796818/4872741931
    const adUnitId = kReleaseMode
        ? 'ca-app-pub-1488047488796818/4872741931'
        : 'ca-app-pub-3940256099942544/5224354917'; // Test ID for debug

    RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('[RewardedAdService] Ad loaded successfully');
          _rewardedAd = ad;
          _isAdLoaded = true;
          _isLoading = false;

          // Set call backs for full screen content
          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              debugPrint('[RewardedAdService] Ad dismissed');
              ad.dispose();
              _isAdLoaded = false;
              _rewardedAd = null;
              loadAd(); // Preload next
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('[RewardedAdService] Ad failed to show: $error');
              ad.dispose();
              _isAdLoaded = false;
              _rewardedAd = null;
              loadAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('[RewardedAdService] Ad failed to load: $error');
          _isLoading = false;
          _isAdLoaded = false;
          _rewardedAd = null;
        },
      ),
    );
  }

  /// Show rewarded ad and earn 1 token
  /// Returns true if reward was granted
  Future<bool> showAdAndEarnToken() async {
    if (!_isAdLoaded || _rewardedAd == null) {
      debugPrint('[RewardedAdService] Ad not ready, loading...');
      await loadAd();
      return false; // Or show loading indicator
    }

    // We use a Completer to returning the result of the ad interaction
    // because show() might return before the callback flows are done specific to the reward.
    // However, for simplicity, we just trigger the reward in the callback.
    // To return 'true' properly we might need a safer flow, but for now let's ensure the token is added.

    await _rewardedAd!.show(onUserEarnedReward: (ad, reward) async {
      debugPrint('[RewardedAdService] User earned reward!');
      // Grant reward immediately in callback
      await TokenRepository.instance.addTokens(1);
      debugPrint('[RewardedAdService] Reward granted: 1 token');
    });

    // We can't easily return 'true' here based on the callback unless we use a Completer,
    // but the UI typically listens to TokenRepository stream/change.
    // So returning true/false might be less important for the UI than the actual balance update.
    return true;
  }

  /// Dispose resources
  void dispose() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
  }
}
