import 'package:flutter/material.dart';
import '../../finance/finance_screen.dart';
import '../../../design_system/theme/theme_variations.dart';

/// Hosts the Finance screen inside the main navigation tab.
/// Goals/Vision tab was removed as requested — vision is accessed directly from Today's Vision Card.
class FutureScreen extends StatefulWidget {
  const FutureScreen({
    super.key,
    required this.variant,
    this.initialSubTab = 0,
    this.onSubTabChanged,
    this.onMonthChanged,
    this.visionFreeformNotifier,
    this.visionRoundCornersNotifier,
    this.visionShowTextNotifier,
    this.visionShowProgressNotifier,
    this.visionBoardBoundaryKey,
    this.financeKey,
  });

  final ThemeVariant variant;
  final int initialSubTab;
  final ValueChanged<int>? onSubTabChanged;
  final ValueChanged<DateTime>? onMonthChanged;
  final ValueNotifier<bool>? visionFreeformNotifier;
  final ValueNotifier<bool>? visionRoundCornersNotifier;
  final ValueNotifier<bool>? visionShowTextNotifier;
  final ValueNotifier<bool>? visionShowProgressNotifier;
  final GlobalKey? visionBoardBoundaryKey;
  final GlobalKey<FinanceScreenState>? financeKey;

  @override
  State<FutureScreen> createState() => FutureScreenState();
}

class FutureScreenState extends State<FutureScreen> {
  int get currentSubTab => 0;

  void switchToTab(int index) {
    // Kept for backwards-compatibility
  }

  @override
  Widget build(BuildContext context) {
    return FinanceScreen(
      key: widget.financeKey,
      variant: widget.variant,
      onMonthChanged: widget.onMonthChanged,
    );
  }
}
