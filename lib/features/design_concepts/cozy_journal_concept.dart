import 'package:flutter/material.dart';

/// Konsept: Cozy Journal
/// Kahverengi/bej tonları, timeline görünüm, streak takibi, başarı ekranı
class CozyJournalConceptScreen extends StatefulWidget {
  const CozyJournalConceptScreen({super.key});

  @override
  State<CozyJournalConceptScreen> createState() =>
      _CozyJournalConceptScreenState();
}

class _CozyJournalConceptScreenState extends State<CozyJournalConceptScreen> {
  int _selectedView = 0; // 0: Timeline, 1: Success, 2: Empty

  // Renk paleti - Kahverengi/Bej tonları
  static const Color _bgColor = Color(0xFFF5EDE6);
  static const Color _cardBg = Color(0xFFFFFFFF);
  static const Color _brownDark = Color(0xFF5C4033);
  static const Color _brownMedium = Color(0xFF8B6B4F);
  static const Color _brownLight = Color(0xFFD4C4B5);
  static const Color _cream = Color(0xFFFFF9F5);
  static const Color _pink = Color(0xFFE8A0A0);
  static const Color _coral = Color(0xFFE07B7B);
  static const Color _mint = Color(0xFF98D4BB);
  static const Color _yellow = Color(0xFFF5D76E);
  static const Color _warmGray = Color(0xFF8B8B8B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 100), // Konsept seçici için boşluk
            // View seçici
            _buildViewSelector(),
            const SizedBox(height: 16),
            Expanded(
              child: _selectedView == 0
                  ? _buildTimelineView()
                  : _selectedView == 1
                  ? _buildSuccessView()
                  : _buildEmptyView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _brownLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _buildViewTab('Timeline', 0),
          _buildViewTab('Success', 1),
          _buildViewTab('Empty', 2),
        ],
      ),
    );
  }

  Widget _buildViewTab(String label, int index) {
    final isSelected = _selectedView == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedView = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? _cardBg : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? _brownDark : _brownMedium,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===================== TIMELINE VIEW =====================
  Widget _buildTimelineView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        children: [
          // Header
          _buildTimelineHeader(),
          const SizedBox(height: 20),
          // Haftalık takvim
          _buildWeekCalendar(),
          const SizedBox(height: 24),
          // Timeline günlük girişleri
          _buildTimelineEntries(),
        ],
      ),
    );
  }

  Widget _buildTimelineHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.chevron_left, color: _brownDark, size: 28),
        Text(
          'My Journals',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _brownDark,
          ),
        ),
        Icon(Icons.notifications_none, color: _brownDark, size: 24),
      ],
    );
  }

  Widget _buildWeekCalendar() {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final dates = [20, 21, 22, 23, 24, 25, 26];
    const selectedIndex = 1; // Salı seçili

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(7, (index) {
          final isSelected = index == selectedIndex;
          return Container(
            width: 40,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? _brownDark : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  days[index],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : _warmGray,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dates[index].toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : _brownDark,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTimelineEntries() {
    return Column(
      children: [
        _buildTimelineEntry(
          time: '7 AM',
          emoji: '😤',
          emojiColor: _coral,
          title: 'Just Got Betrayed By Best F...',
          description: 'Today was a painful day. I found...',
          wordCount: 215,
          showActions: true,
        ),
        _buildTimelineEntry(
          time: '',
          emoji: '😊',
          emojiColor: _mint,
          title: 'Felt happy xD',
          description: 'Today was a painful day. I found...',
          wordCount: 215,
          showActions: true,
        ),
        _buildTimelineEntry(
          time: '9 AM',
          emoji: null,
          emojiColor: null,
          title: null,
          description: null,
          wordCount: null,
          showActions: false,
        ),
        _buildTimelineEntry(
          time: '10 AM',
          emoji: null,
          emojiColor: null,
          title: null,
          description: null,
          wordCount: null,
          showActions: false,
        ),
        _buildTimelineEntry(
          time: '11 AM',
          emoji: '😃',
          emojiColor: _yellow,
          title: 'Just got promotion, OMGG!',
          description: 'Today was a painful day. I found...',
          wordCount: 215,
          showActions: false,
        ),
        _buildTimelineEntry(
          time: '12 AM',
          emoji: null,
          emojiColor: null,
          title: null,
          description: null,
          wordCount: null,
          showActions: false,
        ),
        _buildTimelineEntry(
          time: '1 PM',
          emoji: '😰',
          emojiColor: _brownLight,
          title: "don't know wht to do anym...",
          description: 'Today was a painful day. I found...',
          wordCount: 215,
          showActions: false,
        ),
      ],
    );
  }

  Widget _buildTimelineEntry({
    required String time,
    String? emoji,
    Color? emojiColor,
    String? title,
    String? description,
    int? wordCount,
    bool showActions = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Zaman göstergesi
          SizedBox(
            width: 50,
            child: Text(
              time,
              style: TextStyle(
                fontSize: 12,
                color: _warmGray,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Timeline çizgisi
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: emoji != null ? _brownMedium : _brownLight,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 2,
                height: emoji != null ? 80 : 40,
                color: _brownLight,
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Kart içeriği
          if (emoji != null)
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Emoji container
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: emojiColor?.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // İçerik
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title!,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _brownDark,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            description!,
                            style: TextStyle(fontSize: 12, color: _warmGray),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.notes, size: 14, color: _warmGray),
                              const SizedBox(width: 4),
                              Text(
                                '$wordCount total words',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _warmGray,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Aksiyonlar
                    if (showActions) ...[
                      const SizedBox(width: 8),
                      Column(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: _brownLight.withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.edit,
                              size: 16,
                              color: _brownMedium,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: _coral.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.delete_outline,
                              size: 16,
                              color: _coral,
                            ),
                          ),
                        ],
                      ),
                    ] else
                      Icon(Icons.chevron_right, color: _warmGray),
                  ],
                ),
              ),
            )
          else
            const Spacer(),
        ],
      ),
    );
  }

  // ===================== SUCCESS VIEW =====================
  Widget _buildSuccessView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Tarih
          Text(
            'Wednesday, April 25',
            style: TextStyle(fontSize: 14, color: _warmGray),
          ),
          const SizedBox(height: 16),
          // Başarı mesajı
          Text(
            'Well done, Shinomiya! You\'ve\ncompleted today\'s journal.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: _brownDark,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 40),
          // Streak sayacı
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: _cardBg,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _brownMedium.withValues(alpha: 0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '1',
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: _brownDark,
                  ),
                ),
                Text(
                  'day streak',
                  style: TextStyle(fontSize: 16, color: _brownMedium),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          // Haftalık takvim
          _buildSuccessWeekCalendar(),
          const SizedBox(height: 40),
          // Konfeti efekti (simüle)
          _buildConfettiDecoration(),
          const SizedBox(height: 30),
          // Done butonu
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: _brownDark,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Done',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.check, color: Colors.white, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessWeekCalendar() {
    final days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    const selectedIndex = 3; // Çarşamba seçili

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(7, (index) {
        final isSelected = index == selectedIndex;
        return Container(
          width: 40,
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? _brownDark : _brownLight.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              days[index],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : _brownMedium,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildConfettiDecoration() {
    return SizedBox(
      height: 60,
      child: Stack(
        children: [
          // Konfeti parçaları
          Positioned(left: 20, top: 10, child: _buildConfettiPiece(_pink, 30)),
          Positioned(left: 60, top: 0, child: _buildConfettiPiece(_mint, 25)),
          Positioned(
            left: 100,
            top: 20,
            child: _buildConfettiPiece(_yellow, 35),
          ),
          Positioned(
            right: 100,
            top: 5,
            child: _buildConfettiPiece(_coral, 28),
          ),
          Positioned(
            right: 60,
            top: 25,
            child: _buildConfettiPiece(_brownLight, 22),
          ),
          Positioned(right: 20, top: 10, child: _buildConfettiPiece(_mint, 30)),
        ],
      ),
    );
  }

  Widget _buildConfettiPiece(Color color, double size) {
    return Transform.rotate(
      angle: size * 0.1,
      child: Container(
        width: size * 0.6,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  // ===================== EMPTY VIEW =====================
  Widget _buildEmptyView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.chevron_left, color: _brownDark, size: 28),
              Text(
                'My Journals',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _brownDark,
                ),
              ),
              const SizedBox(width: 28),
            ],
          ),
          const SizedBox(height: 20),
          // Haftalık takvim
          _buildEmptyWeekCalendar(),
          const Spacer(),
          // Floating X butonu
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _coral,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _coral.withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(Icons.close, color: Colors.white, size: 28),
            ),
          ),
          const SizedBox(height: 40),
          // Boş durum mesajı
          Text(
            'You have no journal entries for this\ndate.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: _brownDark,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Please add a journal entry.',
            style: TextStyle(fontSize: 14, color: _warmGray),
          ),
          const Spacer(),
          // Create Journal butonu
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: _brownDark,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                'Create Journal',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildEmptyWeekCalendar() {
    final days = ['M', 'T', 'W', 'T', 'F'];
    final dates = [20, 21, 22, 23, 24];
    const selectedIndex = 1; // Salı seçili

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(5, (index) {
          final isSelected = index == selectedIndex;
          return Container(
            width: 48,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? _brownDark : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Text(
                  days[index],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : _warmGray,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  dates[index].toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : _brownDark,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
