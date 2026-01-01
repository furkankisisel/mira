import 'package:flutter/material.dart';
import 'soft_peach_concept.dart';
import 'lavender_dreams_concept.dart';
import 'mint_fresh_concept.dart';
import 'cotton_candy_concept.dart';
import 'focused_zen_concept.dart';
import 'guided_journey_concept.dart';
import 'soft_cloud_concept.dart';
import 'warm_journal_concept.dart';
import 'cozy_journal_concept.dart';

/// Ana görüntüleyici - Tüm tasarım konseptleri arasında geçiş yapabilirsiniz
class DesignConceptViewer extends StatefulWidget {
  const DesignConceptViewer({super.key});

  @override
  State<DesignConceptViewer> createState() => _DesignConceptViewerState();
}

class _DesignConceptViewerState extends State<DesignConceptViewer> {
  int _currentIndex = 0;

  final List<_ConceptInfo> _concepts = [
    _ConceptInfo(
      name: 'Soft Peach',
      description: 'Sıcak şeftali & krem tonları',
      emoji: '🍑',
      builder: () => const SoftPeachConceptScreen(),
    ),
    _ConceptInfo(
      name: 'Lavender Dreams',
      description: 'Zarif lavanta & mor tonları',
      emoji: '💜',
      builder: () => const LavenderDreamsConceptScreen(),
    ),
    _ConceptInfo(
      name: 'Mint Fresh',
      description: 'Taze nane & turkuaz tonları',
      emoji: '🌿',
      builder: () => const MintFreshConceptScreen(),
    ),
    _ConceptInfo(
      name: 'Cotton Candy',
      description: 'Pamuk şeker - pembe & mavi',
      emoji: '🍭',
      builder: () => const CottonCandyConceptScreen(),
    ),
    _ConceptInfo(
      name: 'Focused Zen',
      description: 'Minimalist, tek odak noktası',
      emoji: '🎯',
      builder: () => const FocusedZenConceptScreen(),
    ),
    _ConceptInfo(
      name: 'Guided Journey',
      description: 'Adım adım yönlendirmeli akış',
      emoji: '🗺️',
      builder: () => const GuidedJourneyConceptScreen(),
    ),
    _ConceptInfo(
      name: 'Soft Cloud',
      description: 'Bulutsu, rüya gibi yumuşak',
      emoji: '☁️',
      builder: () => const SoftCloudConceptScreen(),
    ),
    _ConceptInfo(
      name: 'Warm Journal',
      description: 'Sıcak günlük & duygu takibi',
      emoji: '📔',
      builder: () => const WarmJournalConceptScreen(),
    ),
    _ConceptInfo(
      name: 'Cozy Journal',
      description: 'Kahverengi tonlar & timeline',
      emoji: '📖',
      builder: () => const CozyJournalConceptScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Mevcut konsept ekranı
          _concepts[_currentIndex].builder(),

          // Üstte konsept seçici
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '🎨 Tasarım Konseptleri',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_concepts.length, (index) {
                          final concept = _concepts[index];
                          final isSelected = index == _currentIndex;
                          return GestureDetector(
                            onTap: () => setState(() => _currentIndex = index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.grey[900]
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Text(concept.emoji),
                                  const SizedBox(width: 6),
                                  Text(
                                    concept.name,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _concepts[_currentIndex].description,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConceptInfo {
  final String name;
  final String description;
  final String emoji;
  final Widget Function() builder;

  _ConceptInfo({
    required this.name,
    required this.description,
    required this.emoji,
    required this.builder,
  });
}
