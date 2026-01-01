import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

/// Wheel of Fortune game - add options and spin the wheel
class WheelOfFortuneScreen extends StatefulWidget {
  const WheelOfFortuneScreen({super.key});

  @override
  State<WheelOfFortuneScreen> createState() => _WheelOfFortuneScreenState();
}

class _WheelOfFortuneScreenState extends State<WheelOfFortuneScreen>
    with SingleTickerProviderStateMixin {
  final List<String> _options = [];
  final _optionController = TextEditingController();
  late AnimationController _spinController;
  late Animation<double> _spinAnimation;

  bool _isSpinning = false;
  double _currentRotation = 0;
  int? _winnerIndex;

  // Premium color palette with gradients
  final List<List<Color>> _colorGradients = [
    [const Color(0xFFFF6B6B), const Color(0xFFEE5A24)], // Coral Red
    [const Color(0xFF4ECDC4), const Color(0xFF44A08D)], // Teal
    [const Color(0xFFA8E6CE), const Color(0xFF56AB2F)], // Fresh Green
    [const Color(0xFFFFE66D), const Color(0xFFFFA502)], // Golden Yellow
    [const Color(0xFF9B59B6), const Color(0xFF8E44AD)], // Purple
    [const Color(0xFF3498DB), const Color(0xFF2980B9)], // Sky Blue
    [const Color(0xFFE91E63), const Color(0xFFC2185B)], // Pink
    [const Color(0xFF00BCD4), const Color(0xFF00838F)], // Cyan
    [const Color(0xFFFF9800), const Color(0xFFE65100)], // Orange
    [const Color(0xFF673AB7), const Color(0xFF512DA8)], // Deep Purple
    [const Color(0xFF009688), const Color(0xFF00695C)], // Teal Dark
    [const Color(0xFFFF5722), const Color(0xFFBF360C)], // Deep Orange
  ];

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );

    _spinController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _calculateWinner();
      }
    });
  }

  @override
  void dispose() {
    _optionController.dispose();
    _spinController.dispose();
    super.dispose();
  }

  void _addOption() {
    final text = _optionController.text.trim();
    if (text.isEmpty) return;
    if (_options.length >= 12) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).maxOptionsReached)),
      );
      return;
    }

    setState(() => _options.add(text));
    _optionController.clear();
  }

  void _removeOption(int index) {
    setState(() => _options.removeAt(index));
  }

  void _spin() {
    if (_isSpinning || _options.length < 2) {
      if (_options.length < 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).needAtLeastTwoOptions),
          ),
        );
      }
      return;
    }

    final random = Random();
    final extraRotations = 6 + random.nextInt(4); // 6-9 full rotations
    final targetAngle = random.nextDouble() * 2 * pi;
    final totalRotation = extraRotations * 2 * pi + targetAngle;

    setState(() {
      _isSpinning = true;
      _winnerIndex = null;
    });

    _spinAnimation =
        Tween<double>(
          begin: _currentRotation,
          end: _currentRotation + totalRotation,
        ).animate(
          CurvedAnimation(
            parent: _spinController,
            curve: Curves.easeOutExpo, // More dramatic slow-down
          ),
        );

    _spinController.reset();
    _spinController.forward();
  }

  void _calculateWinner() {
    final normalizedRotation = (_spinAnimation.value % (2 * pi));
    final segmentAngle = (2 * pi) / _options.length;
    final adjustedRotation =
        (2 * pi - normalizedRotation + (segmentAngle / 2)) % (2 * pi);
    final winnerIndex =
        (adjustedRotation / segmentAngle).floor() % _options.length;

    setState(() {
      _isSpinning = false;
      _currentRotation = _spinAnimation.value;
      _winnerIndex = winnerIndex;
    });
  }

  void _reset() {
    setState(() {
      _winnerIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.wheelOfFortuneTitle), centerTitle: true),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            // Add option input - sleeker design
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _optionController,
                      enabled: !_isSpinning,
                      decoration: InputDecoration(
                        hintText: l10n.addOptionHint,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      onSubmitted: (_) => _addOption(),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [colorScheme.primary, colorScheme.tertiary],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      onPressed: _isSpinning ? null : _addOption,
                      icon: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            // Options chips - horizontal scroll
            if (_options.isNotEmpty)
              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _options.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final colors =
                        _colorGradients[index % _colorGradients.length];
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: colors),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: colors[0].withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _options[index],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              if (!_isSpinning)
                                GestureDetector(
                                  onTap: () => _removeOption(index),
                                  child: const Icon(
                                    Icons.close,
                                    size: 18,
                                    color: Colors.white70,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 20),

            // Wheel - Premium Design
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Wheel border ring
                    Container(
                      width: 306,
                      height: 306,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.8),
                            Colors.grey.shade300,
                          ],
                        ),
                      ),
                    ),

                    // Main wheel
                    AnimatedBuilder(
                      animation: _spinController,
                      builder: (context, child) {
                        final rotation = _isSpinning
                            ? _spinAnimation.value
                            : _currentRotation;
                        return Transform.rotate(angle: rotation, child: child);
                      },
                      child: SizedBox(
                        width: 290,
                        height: 290,
                        child: CustomPaint(
                          painter: _PremiumWheelPainter(
                            options: _options,
                            colorGradients: _colorGradients,
                          ),
                        ),
                      ),
                    ),

                    // Center button with gradient
                    GestureDetector(
                      onTap: _isSpinning ? null : _spin,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              colorScheme.primary,
                              colorScheme.secondary,
                            ],
                          ),
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary.withOpacity(0.5),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Center(
                          child: _isSpinning
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                )
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.play_arrow_rounded,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                    Text(
                                      l10n.spin,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),

                    // Pointer - Triangle style
                    Positioned(
                      top: -5,
                      child: CustomPaint(
                        size: const Size(40, 50),
                        painter: _PointerPainter(color: colorScheme.error),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Result - Premium card
            if (_winnerIndex != null)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _colorGradients[_winnerIndex! % _colorGradients.length][0]
                          .withOpacity(0.15),
                      _colorGradients[_winnerIndex! % _colorGradients.length][1]
                          .withOpacity(0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color:
                        _colorGradients[_winnerIndex! %
                                _colorGradients.length][0]
                            .withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          _colorGradients[_winnerIndex! %
                                  _colorGradients.length][0]
                              .withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🎉', style: TextStyle(fontSize: 24)),
                        const SizedBox(width: 8),
                        Text(
                          l10n.theWinnerIs,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('🎉', style: TextStyle(fontSize: 24)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors:
                            _colorGradients[_winnerIndex! %
                                _colorGradients.length],
                      ).createShader(bounds),
                      child: Text(
                        _options[_winnerIndex!],
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: _reset,
                      icon: const Icon(Icons.refresh),
                      label: Text(l10n.spinAgain),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color:
                              _colorGradients[_winnerIndex! %
                                  _colorGradients.length][0],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  _options.isEmpty
                      ? l10n.addOptionsToStart
                      : l10n.tapSpinToStart,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Premium wheel painter with gradients and 3D effect
class _PremiumWheelPainter extends CustomPainter {
  final List<String> options;
  final List<List<Color>> colorGradients;

  _PremiumWheelPainter({required this.options, required this.colorGradients});

  @override
  void paint(Canvas canvas, Size size) {
    if (options.isEmpty) {
      // Draw empty wheel placeholder
      final paint = Paint()
        ..color = Colors.grey.shade200
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        size.width / 2,
        paint,
      );

      // Draw dashed circle
      final dashPaint = Paint()
        ..color = Colors.grey.shade400
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        size.width / 2 - 10,
        dashPaint,
      );
      return;
    }

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final segmentAngle = (2 * pi) / options.length;

    for (int i = 0; i < options.length; i++) {
      final startAngle = i * segmentAngle - pi / 2;
      final colors = colorGradients[i % colorGradients.length];

      // Create gradient shader for each segment
      final sweepGradient = ui.Gradient.sweep(
        center,
        colors,
        [0.0, 1.0],
        TileMode.clamp,
        startAngle,
        startAngle + segmentAngle,
      );

      final paint = Paint()
        ..shader = sweepGradient
        ..style = PaintingStyle.fill;

      // Alternative: radial gradient for each segment
      final rect = Rect.fromCircle(center: center, radius: radius);
      final segmentPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ).createShader(rect)
        ..style = PaintingStyle.fill;

      // Draw segment
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(rect, startAngle, segmentAngle, false)
        ..close();

      canvas.drawPath(path, segmentPaint);

      // Draw segment divider lines
      final dividerPaint = Paint()
        ..color = Colors.white.withOpacity(0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      final endX = center.dx + radius * cos(startAngle);
      final endY = center.dy + radius * sin(startAngle);
      canvas.drawLine(center, Offset(endX, endY), dividerPaint);

      // Draw text with improved styling
      final textAngle = startAngle + segmentAngle / 2;
      final textRadius = radius * 0.62;
      final textX = center.dx + textRadius * cos(textAngle);
      final textY = center.dy + textRadius * sin(textAngle);

      canvas.save();
      canvas.translate(textX, textY);
      canvas.rotate(textAngle + pi / 2);

      final displayText = options[i].length > 12
          ? '${options[i].substring(0, 10)}...'
          : options[i];

      final textPainter = TextPainter(
        text: TextSpan(
          text: displayText,
          style: TextStyle(
            color: Colors.white,
            fontSize: options.length > 8 ? 10 : 12,
            fontWeight: FontWeight.bold,
            shadows: const [
              Shadow(
                color: Colors.black45,
                blurRadius: 3,
                offset: Offset(1, 1),
              ),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );

      canvas.restore();
    }

    // Inner circle for depth effect
    final innerShadow = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(center, 42, innerShadow);
  }

  @override
  bool shouldRepaint(_PremiumWheelPainter oldDelegate) =>
      oldDelegate.options != options;
}

/// Custom triangle pointer painter
class _PointerPainter extends CustomPainter {
  final Color color;

  _PointerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color, color.withOpacity(0.8)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();

    // Draw shadow
    canvas.save();
    canvas.translate(2, 2);
    canvas.drawPath(path, shadowPaint);
    canvas.restore();

    // Draw pointer
    canvas.drawPath(path, paint);

    // Add highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(size.width / 2, size.height - 5),
      Offset(5, 3),
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(_PointerPainter oldDelegate) => oldDelegate.color != color;
}
