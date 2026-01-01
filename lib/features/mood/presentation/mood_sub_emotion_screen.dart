import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../data/mood_models.dart';
import 'mood_reason_screen.dart';

class MoodSubEmotionScreen extends StatefulWidget {
  const MoodSubEmotionScreen({super.key});

  @override
  State<MoodSubEmotionScreen> createState() => _MoodSubEmotionScreenState();
}

class _MoodSubEmotionScreenState extends State<MoodSubEmotionScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _didSchedulePop = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final moodState = context.watch<MoodFlowState>();

    if (moodState.selectedMood == null) {
      if (!_didSchedulePop) {
        _didSchedulePop = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          Navigator.of(context).maybePop();
        });
      }
      return const SizedBox.shrink();
    }

    final subEmotions = moodState.getSubEmotionsForMood(
      moodState.selectedMood!,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.selectSubEmotion), centerTitle: true),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Text(
                  l10n.feelingMoreSpecific,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.selectSubEmotionDesc,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.2,
                        ),
                    itemCount: subEmotions.length,
                    itemBuilder: (context, index) {
                      final subEmotion = subEmotions[index];
                      final isSelected = moodState.selectedSubEmotions.contains(
                        subEmotion,
                      );
                      return _SubEmotionCard(
                        subEmotion: subEmotion,
                        moodLevel: moodState.selectedMood!,
                        isSelected: isSelected,
                        onTap: () => _onSubEmotionSelected(subEmotion),
                        animationDelay: Duration(milliseconds: 100 * index),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: moodState.selectedSubEmotions.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _onContinue,
              label: Text(l10n.continueText),
              icon: const Icon(Icons.arrow_forward),
            )
          : null,
    );
  }

  void _onSubEmotionSelected(SubEmotion subEmotion) {
    context.read<MoodFlowState>().toggleSubEmotion(subEmotion);
  }

  void _onContinue() {
    final moodState = context.read<MoodFlowState>();
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ChangeNotifierProvider.value(
              value: moodState,
              child: const MoodReasonScreen(),
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}

class _SubEmotionCard extends StatefulWidget {
  final SubEmotion subEmotion;
  final MoodLevel moodLevel;
  final bool isSelected;
  final VoidCallback onTap;
  final Duration animationDelay;

  const _SubEmotionCard({
    required this.subEmotion,
    required this.moodLevel,
    required this.isSelected,
    required this.onTap,
    required this.animationDelay,
  });

  @override
  State<_SubEmotionCard> createState() => _SubEmotionCardState();
}

class _SubEmotionCardState extends State<_SubEmotionCard>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
    );

    Future.delayed(widget.animationDelay, () {
      if (mounted) _slideController.forward();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: GestureDetector(
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              transform: Matrix4.identity()..scale(_isPressed ? 0.95 : 1.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: _getSubEmotionGradient(widget.moodLevel),
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _getSubEmotionGradient(
                        widget.moodLevel,
                      )[0].withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onTap,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _getSubEmotionIcon(widget.subEmotion),
                            size: 32,
                            color: widget.isSelected
                                ? Colors.white
                                : theme.colorScheme.onSurface,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _getSubEmotionTitle(widget.subEmotion, l10n),
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: widget.isSelected
                                  ? Colors.white
                                  : theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Color> _getSubEmotionGradient(MoodLevel moodLevel) {
    switch (moodLevel) {
      case MoodLevel.terrible:
        return [Colors.red.shade400, Colors.red.shade600];
      case MoodLevel.bad:
        return [Colors.orange.shade400, Colors.orange.shade600];
      case MoodLevel.neutral:
        return [Colors.blue.shade300, Colors.blue.shade500];
      case MoodLevel.good:
        return [Colors.green.shade400, Colors.green.shade600];
      case MoodLevel.excellent:
        return [Colors.purple.shade400, Colors.purple.shade600];
    }
  }

  IconData _getSubEmotionIcon(SubEmotion subEmotion) {
    switch (subEmotion) {
      // Terrible
      case SubEmotion.exhausted:
        return Icons.battery_0_bar;
      case SubEmotion.helpless:
        return Icons.help_outline;
      case SubEmotion.hopeless:
        return Icons.cloud_off;
      case SubEmotion.hurt:
        return Icons.favorite_border;
      case SubEmotion.drained:
        return Icons.water_drop_outlined;

      // Bad
      case SubEmotion.angry:
        return Icons.flash_on;
      case SubEmotion.sad:
        return Icons.sentiment_dissatisfied;
      case SubEmotion.anxious:
        return Icons.psychology;
      case SubEmotion.stressed:
        return Icons.speed;
      case SubEmotion.demoralized:
        return Icons.trending_down;

      // Neutral
      case SubEmotion.indecisive:
        return Icons.shuffle;
      case SubEmotion.tired:
        return Icons.bedtime;
      case SubEmotion.ordinary:
        return Icons.remove;
      case SubEmotion.calm:
        return Icons.spa;
      case SubEmotion.empty:
        return Icons.crop_free;

      // Good
      case SubEmotion.happy:
        return Icons.sentiment_satisfied;
      case SubEmotion.cheerful:
        return Icons.emoji_emotions;
      case SubEmotion.excited:
        return Icons.celebration;
      case SubEmotion.enthusiastic:
        return Icons.local_fire_department;
      case SubEmotion.determined:
        return Icons.flag;
      case SubEmotion.motivated:
        return Icons.trending_up;

      // Excellent
      case SubEmotion.amazing:
        return Icons.auto_awesome;
      case SubEmotion.energetic:
        return Icons.bolt;
      case SubEmotion.peaceful:
        return Icons.self_improvement;
      case SubEmotion.grateful:
        return Icons.favorite;
      case SubEmotion.loving:
        return Icons.volunteer_activism;
      case SubEmotion.overwhelmed:
        return Icons.waves;
      case SubEmotion.lonely:
        return Icons.person_off;
      case SubEmotion.regretful:
        return Icons.undo;
      case SubEmotion.insecure:
        return Icons.lock_open;
      case SubEmotion.guilty:
        return Icons.gavel;
      case SubEmotion.bored:
        return Icons.hourglass_empty;
      case SubEmotion.numb:
        return Icons.ac_unit;
      case SubEmotion.confused:
        return Icons.psychology_alt;
      case SubEmotion.distracted:
        return Icons.notifications_off;
      case SubEmotion.proud:
        return Icons.verified;
      case SubEmotion.confident:
        return Icons.shield;
      case SubEmotion.hopeful:
        return Icons.wb_sunny;
      case SubEmotion.euphoric:
        return Icons.rocket_launch;
      case SubEmotion.blessed:
        return Icons.auto_awesome;
      case SubEmotion.unstoppable:
        return Icons.bolt;
    }
  }

  String _getSubEmotionTitle(SubEmotion subEmotion, AppLocalizations l10n) {
    switch (subEmotion) {
      // Terrible
      case SubEmotion.exhausted:
        return l10n.subEmotionExhausted;
      case SubEmotion.helpless:
        return l10n.subEmotionHelpless;
      case SubEmotion.hopeless:
        return l10n.subEmotionHopeless;
      case SubEmotion.hurt:
        return l10n.subEmotionHurt;
      case SubEmotion.drained:
        return l10n.subEmotionDrained;

      // Bad
      case SubEmotion.angry:
        return l10n.subEmotionAngry;
      case SubEmotion.sad:
        return l10n.subEmotionSad;
      case SubEmotion.anxious:
        return l10n.subEmotionAnxious;
      case SubEmotion.stressed:
        return l10n.subEmotionStressed;
      case SubEmotion.demoralized:
        return l10n.subEmotionDemoralized;

      // Neutral
      case SubEmotion.indecisive:
        return l10n.subEmotionIndecisive;
      case SubEmotion.tired:
        return l10n.subEmotionTired;
      case SubEmotion.ordinary:
        return l10n.subEmotionOrdinary;
      case SubEmotion.calm:
        return l10n.subEmotionCalm;
      case SubEmotion.empty:
        return l10n.subEmotionEmpty;

      // Good
      case SubEmotion.happy:
        return l10n.subEmotionHappy;
      case SubEmotion.cheerful:
        return l10n.subEmotionCheerful;
      case SubEmotion.excited:
        return l10n.subEmotionExcited;
      case SubEmotion.enthusiastic:
        return l10n.subEmotionEnthusiastic;
      case SubEmotion.determined:
        return l10n.subEmotionDetermined;
      case SubEmotion.motivated:
        return l10n.subEmotionMotivated;

      // Excellent
      case SubEmotion.amazing:
        return l10n.subEmotionAmazing;
      case SubEmotion.energetic:
        return l10n.subEmotionEnergetic;
      case SubEmotion.peaceful:
        return l10n.subEmotionPeaceful;
      case SubEmotion.grateful:
        return l10n.subEmotionGrateful;
      case SubEmotion.loving:
        return l10n.subEmotionLoving;
      case SubEmotion.overwhelmed:
        return l10n.subEmotionOverwhelmed;
      case SubEmotion.lonely:
        return l10n.subEmotionLonely;
      case SubEmotion.regretful:
        return l10n.subEmotionRegretful;
      case SubEmotion.insecure:
        return l10n.subEmotionInsecure;
      case SubEmotion.guilty:
        return l10n.subEmotionGuilty;
      case SubEmotion.bored:
        return l10n.subEmotionBored;
      case SubEmotion.numb:
        return l10n.subEmotionNumb;
      case SubEmotion.confused:
        return l10n.subEmotionConfused;
      case SubEmotion.distracted:
        return l10n.subEmotionDistracted;
      case SubEmotion.proud:
        return l10n.subEmotionProud;
      case SubEmotion.confident:
        return l10n.subEmotionConfident;
      case SubEmotion.hopeful:
        return l10n.subEmotionHopeful;
      case SubEmotion.euphoric:
        return l10n.subEmotionEuphoric;
      case SubEmotion.blessed:
        return l10n.subEmotionBlessed;
      case SubEmotion.unstoppable:
        return l10n.subEmotionUnstoppable;
    }
  }
}
