import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../../l10n/app_localizations.dart';
import '../../../ui/widgets/wizard_base_widgets.dart';
import '../data/vision_model.dart';
import '../data/vision_repository.dart';

/// Vizyon oluşturma wizard'ı
/// Kullanıcıyı adım adım yönlendiren, konuşma tarzı akış
class VisionWizardScreen extends StatefulWidget {
  const VisionWizardScreen({super.key, required this.repo, this.initialVision});

  final VisionRepository repo;
  final Vision? initialVision;

  @override
  State<VisionWizardScreen> createState() => _VisionWizardScreenState();
}

class _VisionWizardScreenState extends State<VisionWizardScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Wizard data
  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();

  // Style State
  String _selectedEmoji = '🎯';
  Color _selectedColor = const Color(0xFF8B5CF6);
  String? _imagePath;
  bool _useImage = false;

  // Date State
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;

  // Total pages
  static const int _totalPages = 5;

  // Renk paleti
  static const List<Color> _colors = [
    Color(0xFF8B5CF6), // Violet
    Color(0xFF6366F1), // Indigo
    Color(0xFFEC4899), // Pink
    Color(0xFFEF4444), // Red
    Color(0xFFF97316), // Orange
    Color(0xFFEAB308), // Yellow
    Color(0xFF22C55E), // Green
    Color(0xFF14B8A6), // Teal
    Color(0xFF06B6D4), // Cyan
    Color(0xFF3B82F6), // Blue
  ];

  // Emoji kategorileri
  static const List<String> _quickEmojis = [
    '🎯',
    '🚀',
    '💪',
    '🏆',
    '⭐',
    '💎',
    '🌟',
    '✨',
    '🔥',
    '💡',
    '🌈',
    '🌸',
    '🌻',
    '🌊',
    '🏔️',
    '🌍',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialVision != null) {
      final v = widget.initialVision!;
      _titleCtrl.text = v.title;
      _descriptionCtrl.text = v.description ?? '';
      _selectedEmoji = v.emoji ?? '🎯';
      _selectedColor = Color(v.colorValue);
      _imagePath = v.coverImage;
      _useImage = v.coverImage != null;
      _startDate = v.startDate ?? DateTime.now();
      _endDate = v.endDate;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _saveVision() async {
    final id =
        widget.initialVision?.id ??
        'vision_${DateTime.now().millisecondsSinceEpoch}';

    final vision = Vision(
      id: id,
      title: _titleCtrl.text.trim(),
      description: _descriptionCtrl.text.trim().isNotEmpty
          ? _descriptionCtrl.text.trim()
          : null,
      emoji: _selectedEmoji,
      colorValue: _selectedColor.value,
      coverImage: _useImage ? _imagePath : null,
      linkedHabitIds: const [],
      createdAt: DateTime.now(),
      startDate: _startDate,
      endDate: _endDate,
    );

    if (widget.initialVision != null) {
      await widget.repo.update(vision);
    } else {
      await widget.repo.add(vision);
    }

    if (mounted) {
      Navigator.pop(context, vision);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WizardScaffold(
      currentStep: _currentPage,
      totalSteps: _totalPages,
      showProgress: _currentPage > 0,
      onBack: _previousPage,
      onClose: () => Navigator.pop(context),
      child: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          // 0: Karşılama
          _buildWelcomePage(),

          // 1: İsim ve açıklama
          _buildNamePage(),

          // 2: Emoji ve renk
          _buildStylePage(),

          // 3: Tarih aralığı
          _buildDatePage(),

          // 4: Önizleme
          _buildPreviewPage(),
        ],
      ),
    );
  }

  Widget _buildWelcomePage() {
    final l10n = AppLocalizations.of(context);

    return WizardWelcomePage(
      emoji: '🌟',
      title: l10n.visionBoard,
      description: l10n.visionBoardDesc,
      buttonText: l10n.letsStart,
      onStart: _nextPage,
      accentColor: _selectedColor,
    );
  }

  Widget _buildNamePage() {
    final l10n = AppLocalizations.of(context);
    final isValid = _titleCtrl.text.trim().isNotEmpty;

    return WizardPage(
      emoji: '✏️',
      title: 'Name Your Vision',
      subtitle: 'Give your vision a meaningful name',
      child: Column(
        children: [
          TextField(
            controller: _titleCtrl,
            autofocus: true,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: l10n.myBigGoal,
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) {
              if (isValid) _nextPage();
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionCtrl,
            textAlign: TextAlign.center,
            maxLines: 3,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: l10n.descriptionHintOptional,
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
      bottomWidget: WizardNavigationButtons(
        onNext: _nextPage,
        isNextEnabled: isValid,
        accentColor: _selectedColor,
      ),
    );
  }

  Widget _buildStylePage() {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return WizardPage(
      emoji: _useImage ? '🖼️' : '🎨',
      title: _useImage ? 'Choose Photo' : l10n.simpleHabitEmojiTitle,
      subtitle: _useImage
          ? 'Select a photo that inspires you'
          : l10n.simpleHabitEmojiSubtitle,
      child: Column(
        children: [
          // Toggle between Style and Photo
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _useImage = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: !_useImage
                            ? colorScheme.surface
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: !_useImage
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          l10n.emojiAndColor,
                          style: TextStyle(
                            fontWeight: !_useImage
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: !_useImage
                                ? colorScheme.onSurface
                                : colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _useImage = true),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _useImage
                            ? colorScheme.surface
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: _useImage
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          l10n.photo,
                          style: TextStyle(
                            fontWeight: _useImage
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: _useImage
                                ? colorScheme.onSurface
                                : colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          if (_useImage) ...[
            // Photo Picker UI
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                  image: _imagePath != null
                      ? DecorationImage(
                          image: FileImage(File(_imagePath!)),
                          fit: BoxFit.cover,
                        )
                      : null,
                  border: Border.all(
                    color: colorScheme.outline.withOpacity(0.2),
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: _imagePath == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 48,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.tapToPickImage,
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : Stack(
                        children: [
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton.filled(
                              onPressed: () {
                                setState(() => _imagePath = null);
                              },
                              icon: const Icon(Icons.close),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.black54,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ] else ...[
            // Emoji seçimi
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: _quickEmojis.map((emoji) {
                final isSelected = emoji == _selectedEmoji;
                return WizardSelectionCard(
                  isSelected: isSelected,
                  onTap: () => setState(() => _selectedEmoji = emoji),
                  size: 56,
                  borderRadius: 14,
                  selectedColor: _selectedColor,
                  child: Text(emoji, style: const TextStyle(fontSize: 28)),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            // Renk seçimi
            Text(
              l10n.simpleHabitColorTitle,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: _colors.map((color) {
                final isSelected = color.value == _selectedColor.value;
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() => _selectedColor = color);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: isSelected ? 44 : 36,
                    height: isSelected ? 44 : 36,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(
                              color: Theme.of(context).colorScheme.surface,
                              width: 3,
                            )
                          : null,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.withOpacity(0.4),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
      bottomWidget: WizardNavigationButtons(
        onNext: _nextPage,
        isNextEnabled: !_useImage || (_useImage && _imagePath != null),
        accentColor: _selectedColor,
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() => _imagePath = image.path);
      }
    } catch (e) {
      // Handle error
    }
  }

  Widget _buildDatePage() {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return WizardPage(
      emoji: '📅',
      title: l10n.dateRangeLabel,
      subtitle: l10n.setVisionTimeline,
      child: Column(
        children: [
          // Başlangıç tarihi
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _selectedColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.play_arrow, color: _selectedColor),
            ),
            title: Text(
              l10n.startDate,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              '${_startDate.day}/${_startDate.month}/${_startDate.year}',
              style: theme.textTheme.bodyLarge?.copyWith(color: _selectedColor),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _startDate,
                firstDate: DateTime.now().subtract(const Duration(days: 30)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null) {
                setState(() => _startDate = picked);
              }
            },
          ),
          const Divider(),
          // Bitiş tarihi (isteğe bağlı)
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colorScheme.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.flag, color: colorScheme.error),
            ),
            title: Text(
              l10n.endDate,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              _endDate != null
                  ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                  : l10n.durationIndefinite,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: _endDate != null
                    ? colorScheme.error
                    : colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_endDate != null)
                  IconButton(
                    icon: Icon(Icons.clear, color: colorScheme.error),
                    onPressed: () => setState(() => _endDate = null),
                  ),
                const Icon(Icons.chevron_right),
              ],
            ),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate:
                    _endDate ?? _startDate.add(const Duration(days: 30)),
                firstDate: _startDate,
                lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
              );
              if (picked != null) {
                setState(() => _endDate = picked);
              }
            },
          ),
        ],
      ),
      bottomWidget: WizardNavigationButtons(
        onNext: _nextPage,
        accentColor: _selectedColor,
      ),
    );
  }

  Widget _buildPreviewPage() {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final tags = [
      '${l10n.startsOn}: ${_startDate.day}/${_startDate.month}/${_startDate.year}',
      if (_endDate != null)
        '${l10n.endDate}: ${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
    ];

    return WizardPage(
      emoji: '🎉',
      title: l10n.simpleHabitPreviewTitle,
      subtitle: l10n.simpleHabitPreviewSubtitle,
      child: Column(
        children: [
          // Preview card
          WizardPreviewCard(
            emoji: _selectedEmoji,
            title: _titleCtrl.text.trim(),
            subtitle: _descriptionCtrl.text.trim().isNotEmpty
                ? _descriptionCtrl.text.trim()
                : null,
            color: _selectedColor,
            tags: tags,
          ),
          const SizedBox(height: 24),
          // Vision card preview
          Container(
            width: double.infinity,
            height: 220,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: _useImage && _imagePath != null
                  ? null
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        _selectedColor.withOpacity(0.2),
                        _selectedColor.withOpacity(0.05),
                      ],
                    ),
              image: _useImage && _imagePath != null
                  ? DecorationImage(
                      image: FileImage(File(_imagePath!)),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.3),
                        BlendMode.darken,
                      ),
                    )
                  : null,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_useImage) ...[
                  Text(_selectedEmoji, style: const TextStyle(fontSize: 48)),
                  const SizedBox(height: 12),
                ],
                Text(
                  _titleCtrl.text.trim(),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _useImage ? Colors.white : _selectedColor,
                    shadows: _useImage
                        ? [
                            const Shadow(
                              color: Colors.black45,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomWidget: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _saveVision,
            style: FilledButton.styleFrom(
              backgroundColor: _selectedColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.createHabit,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.check, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
