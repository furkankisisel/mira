import 'dart:math';
import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

/// Coin Flip game - enter two options and flip a 3D coin
class CoinFlipScreen extends StatefulWidget {
  const CoinFlipScreen({super.key});

  @override
  State<CoinFlipScreen> createState() => _CoinFlipScreenState();
}

class _CoinFlipScreenState extends State<CoinFlipScreen>
    with SingleTickerProviderStateMixin {
  final _option1Controller = TextEditingController();
  final _option2Controller = TextEditingController();
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  bool _isFlipping = false;
  bool _showResult = false;
  int _result = 0; // 0 = option1, 1 = option2
  int _flipCount = 0;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeOutCubic),
    );

    _flipController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isFlipping = false;
          _showResult = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _option1Controller.dispose();
    _option2Controller.dispose();
    _flipController.dispose();
    super.dispose();
  }

  void _flipCoin() {
    if (_isFlipping) return;
    if (_option1Controller.text.trim().isEmpty ||
        _option2Controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).enterBothOptions)),
      );
      return;
    }

    final random = Random();
    setState(() {
      _isFlipping = true;
      _showResult = false;
      _result = random.nextInt(2);
      _flipCount = 5 + random.nextInt(4); // 5-8 flips
    });

    _flipController.reset();
    _flipController.forward();
  }

  void _reset() {
    setState(() {
      _showResult = false;
      _isFlipping = false;
    });
    _flipController.reset();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.coinFlipTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.coinFlipInstruction,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Option inputs
              _OptionField(
                controller: _option1Controller,
                label: l10n.option1,
                color: Colors.amber.shade600,
                enabled: !_isFlipping,
              ),
              const SizedBox(height: 12),
              _OptionField(
                controller: _option2Controller,
                label: l10n.option2,
                color: Colors.indigo.shade400,
                enabled: !_isFlipping,
              ),

              const SizedBox(height: 40),

              // Coin
              Center(
                child: AnimatedBuilder(
                  animation: _flipAnimation,
                  builder: (context, child) {
                    final rotations = _flipCount * pi * 2;
                    final currentRotation = _flipAnimation.value * rotations;
                    final normalizedRotation =
                        (currentRotation % (pi * 2)) / pi;
                    final showFront =
                        normalizedRotation < 0.5 || normalizedRotation >= 1.5;

                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateX(currentRotation),
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: showFront
                                ? [Colors.amber.shade300, Colors.amber.shade600]
                                : [
                                    Colors.indigo.shade300,
                                    Colors.indigo.shade500,
                                  ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (showFront ? Colors.amber : Colors.indigo)
                                  .withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 4,
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              showFront
                                  ? (_option1Controller.text.isEmpty
                                        ? l10n.option1
                                        : _option1Controller.text)
                                  : (_option2Controller.text.isEmpty
                                        ? l10n.option2
                                        : _option2Controller.text),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 40),

              // Result
              if (_showResult)
                AnimatedOpacity(
                  opacity: _showResult ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: (_result == 0 ? Colors.amber : Colors.indigo)
                          .withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: (_result == 0 ? Colors.amber : Colors.indigo)
                            .withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '🎉 ${l10n.theWinnerIs}',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _result == 0
                              ? _option1Controller.text
                              : _option2Controller.text,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: _result == 0
                                ? Colors.amber.shade700
                                : Colors.indigo.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  if (_showResult)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _reset,
                        icon: const Icon(Icons.refresh),
                        label: Text(l10n.playAgain),
                      ),
                    ),
                  if (_showResult) const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _isFlipping ? null : _flipCoin,
                      icon: _isFlipping
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.casino),
                      label: Text(l10n.flipCoin),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Color color;
  final bool enabled;

  const _OptionField({
    required this.controller,
    required this.label,
    required this.color,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Container(
          margin: const EdgeInsets.all(8),
          width: 24,
          height: 24,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color, width: 2),
        ),
      ),
    );
  }
}
