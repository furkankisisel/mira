import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../../l10n/app_localizations.dart';
import '../data/vision_model.dart';
import '../data/vision_repository.dart';
import '../../habit/domain/habit_repository.dart';
import '../../habit/domain/habit_types.dart';

/// Vizyon düzenleme ekranı - Tek sayfa düzeni
class VisionEditScreen extends StatefulWidget {
  const VisionEditScreen({
    super.key,
    required this.repo,
    required this.vision,
  });

  final VisionRepository repo;
  final Vision vision;

  @override
  State<VisionEditScreen> createState() => _VisionEditScreenState();
}

class _VisionEditScreenState extends State<VisionEditScreen> {
  // Controllers
  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _scrollController = ScrollController();

  // Style State
  String _selectedEmoji = '🎯';
  Color _selectedColor = const Color(0xFF8B5CF6);
  String? _imagePath;
  bool _useImage = false;

  // Date State
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;

  // Color palette
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

  // Emoji presets
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
    _loadExistingVision();
  }

  void _loadExistingVision() {
    final v = widget.vision;
    _titleCtrl.text = v.title;
    _descriptionCtrl.text = v.description ?? '';
    _selectedEmoji = v.emoji ?? '🎯';
    _selectedColor = Color(v.colorValue);
    _imagePath = v.coverImage;
    _useImage = v.coverImage != null;
    _startDate = v.startDate ?? DateTime.now();
    _endDate = v.endDate;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
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

  Future<void> _saveVision() async {
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).nameRequired)),
      );
      return;
    }

    final vision = Vision(
      id: widget.vision.id,
      title: _titleCtrl.text.trim(),
      description: _descriptionCtrl.text.trim().isNotEmpty
          ? _descriptionCtrl.text.trim()
          : null,
      emoji: _selectedEmoji,
      colorValue: _selectedColor.value,
      coverImage: _useImage ? _imagePath : null,
      linkedHabitIds: widget.vision.linkedHabitIds,
      createdAt: widget.vision.createdAt,
      startDate: _startDate,
      endDate: _endDate,
    );

    await widget.repo.update(vision);

    if (mounted) {
      Navigator.pop(context, vision);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(l10n.edit),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _saveVision,
            child: Text(
              l10n.save,
              style: TextStyle(
                color: _selectedColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Description Section
            _buildSection(
              title: l10n.nameYourVision,
              child: Column(
                children: [
                  TextField(
                    controller: _titleCtrl,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: l10n.myBigGoal,
                      hintStyle: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.3),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor:
                          colorScheme.surfaceContainerHighest.withOpacity(0.5),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _descriptionCtrl,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    style: theme.textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: l10n.descriptionHintOptional,
                      hintStyle: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.3),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor:
                          colorScheme.surfaceContainerHighest.withOpacity(0.3),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Style Section (Emoji/Color vs Image)
            _buildSection(
              title: l10n.simpleHabitEmojiTitle,
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
                  const SizedBox(height: 20),

                  if (_useImage) ...[
                    // Photo Picker UI
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest
                              .withOpacity(0.5),
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
                    // Emoji Selection
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: _quickEmojis.map((emoji) {
                        final isSelected = emoji == _selectedEmoji;
                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            setState(() => _selectedEmoji = emoji);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? _selectedColor.withOpacity(0.15)
                                  : colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(14),
                              border: isSelected
                                  ? Border.all(color: _selectedColor, width: 2)
                                  : null,
                            ),
                            child: Center(
                              child: Text(emoji,
                                  style: const TextStyle(fontSize: 26)),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    // Color Selection
                    Text(
                      l10n.simpleHabitColorTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
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
                                      color: colorScheme.surface,
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
            ),
            const SizedBox(height: 24),

            // Date Range Section
            _buildSection(
              title: l10n.dateRangeLabel,
              child: Column(
                children: [
                  // Start Date
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
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: _selectedColor,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _startDate,
                        firstDate:
                            DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setState(() => _startDate = picked);
                      }
                    },
                  ),
                  const Divider(),
                  // End Date
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
                        initialDate: _endDate ??
                            _startDate.add(const Duration(days: 30)),
                        firstDate: _startDate,
                        lastDate:
                            DateTime.now().add(const Duration(days: 365 * 2)),
                      );
                      if (picked != null) {
                        setState(() => _endDate = picked);
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Linked Habits Section
            if (widget.vision.linkedHabitIds.isNotEmpty) ...[
              _buildSection(
                title: l10n.linkHabits,
                child: ListenableBuilder(
                  listenable: HabitRepository.instance,
                  builder: (context, _) {
                    final habits = HabitRepository.instance.habits;
                    final linkedHabits = habits
                        .where(
                            (h) => widget.vision.linkedHabitIds.contains(h.id))
                        .toList();

                    if (linkedHabits.isEmpty) return const SizedBox();

                    return Column(
                      children: linkedHabits.map((habit) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: colorScheme.outline.withOpacity(0.1),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: habit.color.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    habit.emoji ?? '⭐',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      habit.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      habit.habitType == HabitType.simple
                                          ? l10n.habit
                                          : l10n.advancedHabit,
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
            const SizedBox(height: 8),

            // Save Button
            SizedBox(
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
                      l10n.save,
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
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: child,
        ),
      ],
    );
  }
}
