import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../l10n/app_localizations.dart';
import '../../../ui/widgets/wizard_base_widgets.dart';
import '../../habit/domain/habit_model.dart';
import '../../habit/domain/habit_repository.dart';
import '../../habit/presentation/simple_habit_screen.dart';
import '../data/vision_model.dart';
import '../data/vision_repository.dart';

/// Vizyon / Hedef oluşturma wizard'ı
/// 1. Hedefin adı (İsteğe bağlı: bitiş tarihi, açıklama, emoji/renk)
/// 2. "Bu hedef için küçük adım ekle" (Yeni alışkanlık oluştur, Mevcut bağla, Şimdilik atla)
/// 3. Önizleme & Kaydet
class VisionWizardScreen extends StatefulWidget {
  const VisionWizardScreen({
    super.key,
    required this.repo,
    this.initialVision,
  });

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

  String _selectedEmoji = '🎯';
  Color _selectedColor = const Color(0xFF8B5CF6);
  String? _imagePath;
  bool _useImage = false;

  final DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  final List<String> _linkedHabitIds = [];

  static const int _totalPages = 3;

  static const List<Color> _colors = [
    Color(0xFF8B5CF6),
    Color(0xFF6366F1),
    Color(0xFFEC4899),
    Color(0xFFEF4444),
    Color(0xFFF97316),
    Color(0xFFEAB308),
    Color(0xFF22C55E),
    Color(0xFF14B8A6),
    Color(0xFF06B6D4),
    Color(0xFF3B82F6),
  ];

  static const List<Map<String, String>> _presetPhotos = [
    {
      'name': 'Vizyon',
      'path': 'assets/images/onboarding_vision_v2.png',
    },
    {
      'name': 'Rutin',
      'path': 'assets/images/onboarding_routine_v2.png',
    },
    {
      'name': 'Denge',
      'path': 'assets/images/onboarding_balance_v2.png',
    },
    {
      'name': 'Bağlantı',
      'path': 'assets/images/onboarding_connection_v2.png',
    },
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
      _endDate = v.endDate;
      _linkedHabitIds.addAll(v.linkedHabitIds);
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
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _saveVision() async {
    final id = widget.initialVision?.id ??
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
      linkedHabitIds: _linkedHabitIds,
      createdAt: widget.initialVision?.createdAt ?? DateTime.now(),
      startDate: _startDate,
      endDate: _endDate,
    );

    // Also update habits with linkedVisionId
    for (final hid in _linkedHabitIds) {
      final h = HabitRepository.instance.findById(hid);
      if (h != null && h.linkedVisionId != id) {
        h.linkedVisionId = id;
        await HabitRepository.instance.updateHabit(h);
      }
    }

    if (widget.initialVision != null) {
      await widget.repo.update(vision);
    } else {
      await widget.repo.add(vision);
    }

    if (mounted) {
      Navigator.pop(context, vision);
    }
  }

  Future<void> _pickImage([ImageSource source = ImageSource.gallery]) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _imagePath = image.path;
          _useImage = true;
        });
      }
    } catch (_) {}
  }

  void _showPhotoOptionsSheet() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E2433) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme.onSurface.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Vizyon Fotoğrafı Ekle',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Hedefini zihninde canlandıracak bir fotoğraf seç',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildPhotoSourceButton(
                        icon: Icons.photo_library_rounded,
                        label: 'Galeri',
                        onTap: () {
                          Navigator.pop(ctx);
                          _pickImage(ImageSource.gallery);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildPhotoSourceButton(
                        icon: Icons.camera_alt_rounded,
                        label: 'Kamera',
                        onTap: () {
                          Navigator.pop(ctx);
                          _pickImage(ImageSource.camera);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Veya Hazır İlham Görsellerinden Seç',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 80,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _presetPhotos.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, i) {
                      final preset = _presetPhotos[i];
                      final isSelected = _imagePath == preset['path'];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(ctx);
                          setState(() {
                            _imagePath = preset['path'];
                            _useImage = true;
                          });
                        },
                        child: Container(
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected
                                  ? _selectedColor
                                  : Colors.transparent,
                              width: 2.5,
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                preset['path']!,
                                fit: BoxFit.cover,
                              ),
                              if (isSelected)
                                Container(
                                  color: _selectedColor.withOpacity(0.4),
                                  child: const Center(
                                    child: Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPhotoSourceButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.06)
              : colorScheme.surfaceContainerHighest.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.12),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: _selectedColor),
            const SizedBox(height: 8),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSection(
    ThemeData theme,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    final hasImage = _useImage && _imagePath != null && _imagePath!.isNotEmpty;
    final isFile = hasImage &&
        (_imagePath!.startsWith('/') ||
            _imagePath!.contains('\\') ||
            _imagePath!.contains(':\\'));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Vizyon Fotoğrafı',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                letterSpacing: -0.2,
              ),
            ),
            if (hasImage)
              TextButton.icon(
                onPressed: _showPhotoOptionsSheet,
                icon: const Icon(Icons.sync_rounded, size: 16),
                label: const Text('Değiştir'),
                style: TextButton.styleFrom(
                  foregroundColor: _selectedColor,
                  visualDensity: VisualDensity.compact,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (hasImage) ...[
          // Selected Photo Preview Card
          Container(
            height: 190,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: _selectedColor.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.35 : 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                isFile
                    ? Image.file(File(_imagePath!), fit: BoxFit.cover)
                    : Image.asset(_imagePath!, fit: BoxFit.cover),
                // Gradient overlay
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.55),
                      ],
                    ),
                  ),
                ),
                // Action Buttons Overlay
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: _showPhotoOptionsSheet,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.photo_library_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Değiştir',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          setState(() {
                            _imagePath = null;
                            _useImage = false;
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Kaldır',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          // Empty State Photo Picker Card
          GestureDetector(
            onTap: _showPhotoOptionsSheet,
            child: Container(
              height: 155,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.04)
                    : _selectedColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: _selectedColor.withOpacity(0.35),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: _selectedColor.withOpacity(0.14),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add_a_photo_rounded,
                      size: 26,
                      color: _selectedColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Vizyon Fotoğrafı Ekle',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Hedefini görselleştirecek bir fotoğraf seç',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Quick Photo Sources & Presets Row
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _presetPhotos.length + 2,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                if (i == 0) {
                  return ActionChip(
                    avatar: Icon(
                      Icons.photo_library_rounded,
                      size: 16,
                      color: _selectedColor,
                    ),
                    label: const Text('Galeri'),
                    onPressed: () => _pickImage(ImageSource.gallery),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  );
                }
                if (i == 1) {
                  return ActionChip(
                    avatar: Icon(
                      Icons.camera_alt_rounded,
                      size: 16,
                      color: _selectedColor,
                    ),
                    label: const Text('Kamera'),
                    onPressed: () => _pickImage(ImageSource.camera),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  );
                }
                final preset = _presetPhotos[i - 2];
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _imagePath = preset['path'];
                      _useImage = true;
                    });
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _imagePath == preset['path']
                            ? _selectedColor
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(preset['path']!, fit: BoxFit.cover),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WizardScaffold(
      currentStep: _currentPage,
      totalSteps: _totalPages,
      showProgress: true,
      onBack: _previousPage,
      onClose: () => Navigator.pop(context),
      child: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          FocusManager.instance.primaryFocus?.unfocus();
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          // 0: Hedefin Adı ve İsteğe Bağlı Detaylar
          _buildNameAndDetailsPage(),

          // 1: Bu Hedef İçin Küçük Adım Ekle
          _buildAddSmallStepPage(),

          // 2: Önizleme & Kaydet
          _buildPreviewPage(),
        ],
      ),
    );
  }

  // ─── Step 1: Hedef Adı ve İsteğe Bağlı Detaylar ───

  Widget _buildNameAndDetailsPage() {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final isValid = _titleCtrl.text.trim().isNotEmpty;
    final hasImage = _useImage && _imagePath != null && _imagePath!.isNotEmpty;

    return WizardPage(
      emoji: hasImage ? '🖼️' : '🎯',
      title: l10n.nameYourVision,
      subtitle: l10n.nameYourVisionSubtitle,
      bottomWidget: WizardNavigationButtons(
        onNext: _nextPage,
        isNextEnabled: isValid,
        accentColor: _selectedColor,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Prominent Title Input
            TextField(
              controller: _titleCtrl,
              autofocus: true,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
              decoration: InputDecoration(
                hintText: l10n.myBigGoal,
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.5),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
              ),
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) {
                if (isValid) _nextPage();
              },
            ),
            const SizedBox(height: 18),

            // Prominent Photo Selector Section
            _buildPhotoSection(theme, colorScheme, isDark),
            const SizedBox(height: 18),

            // Accent Theme Color Row
            Row(
              children: [
                Text(
                  l10n.chooseColor,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Divider(
                    color: isDark ? Colors.white12 : Colors.black12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _colors.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final color = _colors[i];
                  final isSelected = color.value == _selectedColor.value;
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _selectedColor = color);
                    },
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Colors.white, width: 2.5)
                            : null,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 18),

            // Optional Section Divider / Header
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: isDark ? Colors.white12 : Colors.black12,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    l10n.wizardOptional,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.6),
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: isDark ? Colors.white12 : Colors.black12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Optional: End Date Picker Tile
            Container(
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.04)
                    : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? Colors.white10
                      : Colors.black.withValues(alpha: 0.05),
                ),
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _selectedColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.event_outlined,
                      color: _selectedColor, size: 20),
                ),
                title: Text(
                  l10n.endDate,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13.5),
                ),
                subtitle: Text(
                  _endDate != null
                      ? '${_endDate!.day}.${_endDate!.month}.${_endDate!.year}'
                      : l10n.durationIndefinite,
                  style: TextStyle(
                    fontSize: 12,
                    color: _endDate != null
                        ? _selectedColor
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight:
                        _endDate != null ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_endDate != null)
                      IconButton(
                        icon: const Icon(Icons.clear, size: 16),
                        onPressed: () => setState(() => _endDate = null),
                      ),
                    const Icon(Icons.chevron_right_rounded, size: 18),
                  ],
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate:
                        _endDate ?? _startDate.add(const Duration(days: 30)),
                    firstDate: _startDate,
                    lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
                  );
                  if (picked != null) setState(() => _endDate = picked);
                },
              ),
            ),
            const SizedBox(height: 10),

            // Optional: Description TextField
            TextField(
              controller: _descriptionCtrl,
              maxLines: 2,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: l10n.descriptionHintOptional,
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: isDark
                    ? Colors.white.withValues(alpha: 0.04)
                    : const Color(0xFFF8FAFC),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Step 2: Bu Hedef İçin Küçük Adım Ekle ───

  Widget _buildAddSmallStepPage() {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final allHabits = HabitRepository.instance.habits;
    final selectedHabits =
        allHabits.where((h) => _linkedHabitIds.contains(h.id)).toList();

    return WizardPage(
      emoji: '⚡',
      title: l10n.addSmallStep,
      subtitle: l10n.addSmallStepSubtitle,
      bottomWidget: WizardNavigationButtons(
        onNext: _nextPage,
        nextLabel: _linkedHabitIds.isEmpty ? l10n.skipForNow : l10n.wizardNext,
        isNextEnabled: true,
        accentColor: _selectedColor,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Option 1: Yeni Alışkanlık Oluştur
            _buildActionOptionCard(
              icon: Icons.add_circle_outline_rounded,
              color: const Color(0xFF8B5CF6),
              title: l10n.createNewHabit,
              subtitle: l10n.createNewHabitSubtitle,
              isDark: isDark,
              onTap: () async {
                HapticFeedback.lightImpact();
                final habit = await Navigator.of(context).push<Habit>(
                  MaterialPageRoute(builder: (_) => const SimpleHabitScreen()),
                );
                if (habit != null) {
                  // Ensure saved in repo
                  if (HabitRepository.instance.findById(habit.id) == null) {
                    await HabitRepository.instance.addHabit(habit);
                  }
                  setState(() {
                    if (!_linkedHabitIds.contains(habit.id)) {
                      _linkedHabitIds.add(habit.id);
                    }
                  });
                }
              },
            ),
            const SizedBox(height: 12),

            // Option 2: Mevcut Alışkanlık Bağla
            _buildActionOptionCard(
              icon: Icons.link_rounded,
              color: const Color(0xFF3B82F6),
              title: l10n.linkExistingHabit,
              subtitle: l10n.linkExistingHabitSubtitle,
              isDark: isDark,
              onTap: () => _openLinkExistingHabitsSheet(context, allHabits),
            ),
            const SizedBox(height: 20),

            // Display selected linked habits (if any)
            if (selectedHabits.isNotEmpty) ...[
              Text(
                '${l10n.linkedHabits} (${selectedHabits.length})',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 8),
              ...selectedHabits.map((habit) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _selectedColor.withValues(alpha: 0.25),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        habit.emoji ?? '🎯',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          habit.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          setState(() => _linkedHabitIds.remove(habit.id));
                        },
                      ),
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionOptionCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.06),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: isDark ? 0.22 : 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.5,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _openLinkExistingHabitsSheet(BuildContext context, List<Habit> habits) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surfaceContainerHigh,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white24 : Colors.black12,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.selectHabitsToLink,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (habits.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          l10n.emptyHabitTitle,
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    )
                  else
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(ctx).size.height * 0.45,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: habits.length,
                        itemBuilder: (_, i) {
                          final h = habits[i];
                          final isSelected = _linkedHabitIds.contains(h.id);

                          return CheckboxListTile(
                            value: isSelected,
                            activeColor: _selectedColor,
                            title: Text(
                              h.title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            secondary: Text(h.emoji ?? '🎯',
                                style: const TextStyle(fontSize: 20)),
                            onChanged: (val) {
                              setSheetState(() {
                                if (val == true) {
                                  _linkedHabitIds.add(h.id);
                                } else {
                                  _linkedHabitIds.remove(h.id);
                                }
                              });
                              setState(() {});
                            },
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: FilledButton.styleFrom(
                      backgroundColor: _selectedColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(l10n.wizardFinish),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ─── Step 3: Önizleme & Kaydet ───

  Widget _buildPreviewPage() {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final tags = [
      '${l10n.startsOn}: ${_startDate.day}.${_startDate.month}.${_startDate.year}',
      if (_endDate != null)
        '${l10n.endDate}: ${_endDate!.day}.${_endDate!.month}.${_endDate!.year}',
      if (_linkedHabitIds.isNotEmpty)
        l10n.todayStepsCount(_linkedHabitIds.length),
    ];

    return WizardPage(
      emoji: '✨',
      title: l10n.simpleHabitPreviewTitle,
      subtitle: l10n.simpleHabitPreviewSubtitle,
      bottomWidget: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _saveVision,
            style: FilledButton.styleFrom(
              backgroundColor: _selectedColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.save,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.check_rounded, size: 20),
              ],
            ),
          ),
        ),
      ),
      child: Column(
        children: [
          WizardPreviewCard(
            emoji: _selectedEmoji,
            imagePath: _useImage ? _imagePath : null,
            title: _titleCtrl.text.trim(),
            subtitle: _descriptionCtrl.text.trim().isNotEmpty
                ? _descriptionCtrl.text.trim()
                : null,
            color: _selectedColor,
            tags: tags,
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _selectedColor.withValues(alpha: 0.2),
                width: 1.2,
              ),
            ),
            child: Column(
              children: [
                if (_useImage && _imagePath != null && _imagePath!.isNotEmpty) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 130,
                      child: _imagePath!.startsWith('assets/')
                          ? Image.asset(_imagePath!, fit: BoxFit.cover)
                          : Image.file(File(_imagePath!), fit: BoxFit.cover),
                    ),
                  ),
                ] else ...[
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: _selectedColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _selectedEmoji,
                      style: const TextStyle(fontSize: 26),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Text(
                  _titleCtrl.text.trim(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (_linkedHabitIds.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _selectedColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${_linkedHabitIds.length} bağlı adım hazır',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _selectedColor,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
