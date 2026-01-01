import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mira/l10n/app_localizations.dart';
import 'google_drive_backup_manager.dart';
import 'backup_data_service.dart';

class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  bool _busy = false;
  List<dynamic> _files = [];
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  Future<void> _backup() async {
    setState(() {
      _busy = true;
      _statusMessage = null;
    });

    try {
      // Collect real app data
      final backupData = await BackupDataService.instance.collectBackupData();

      // Upload to Google Drive
      final res = await GoogleDriveBackupManager.instance.backupToDrive(
        backupData,
      );

      if (mounted) {
        setState(() {
          _busy = false;
          _statusMessage = res == null
              ? AppLocalizations.of(context).backupFailed
              : AppLocalizations.of(context).backupSuccess('OK');
        });
        if (res != null) {
          _refreshList();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _statusMessage = '${AppLocalizations.of(context).backupFailed}: $e';
        });
      }
    }
  }

  Future<void> _refreshList() async {
    if (!mounted) return;
    setState(() => _busy = true);

    try {
      final files = await GoogleDriveBackupManager.instance.listBackups();
      if (mounted) {
        setState(() {
          _busy = false;
          _files = files;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _restore(String fileId) async {
    setState(() {
      _busy = true;
      _statusMessage = null;
    });

    try {
      // Download backup from Google Drive
      final content = await GoogleDriveBackupManager.instance.restoreFromDrive(
        fileId,
      );

      if (content == null) {
        if (mounted) {
          setState(() {
            _busy = false;
            _statusMessage = AppLocalizations.of(context).restoreFailed;
          });
        }
        return;
      }

      // Apply restored data to SharedPreferences and reload repositories
      await BackupDataService.instance.restoreBackupData(content);

      if (mounted) {
        setState(() {
          _busy = false;
          _statusMessage = AppLocalizations.of(context).restoreSuccess('OK');
        });

        // Show success dialog with restart recommendation
        _showRestoreSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _statusMessage = '${AppLocalizations.of(context).restoreFailed}: $e';
        });
      }
    }
  }

  void _showRestoreSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(AppLocalizations.of(context).restoreSuccess('').split(':')[0]),
          ],
        ),
        content: Text(AppLocalizations.of(context).restoreSuccessMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context).ok),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.backupRestore),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header / Status Area
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                _BackupActionCard(
                  onBackup: _busy ? null : _backup,
                  isBusy: _busy,
                ),
                if (_statusMessage != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer.withOpacity(
                        0.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _statusMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme.colorScheme.onSecondaryContainer,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 16),

          // List Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.lastBackup('').split(':')[0], // "Last Backups" roughly
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: _busy ? null : _refreshList,
                  icon: const Icon(Icons.refresh),
                  tooltip: l10n.refreshList,
                ),
              ],
            ),
          ),

          // Backup List
          Expanded(
            child: _busy && _files.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _files.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history_toggle_off,
                          size: 64,
                          color: theme.colorScheme.outline.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noBackups,
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: _files.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      dynamic file = _files[index];
                      // Google Drive API returns DateTime or formatted string depending on library
                      // But here 'file' is likely a googleapis.drive.v3.File
                      // We access fields safely.

                      String name = 'Unknown';
                      String? modifiedTime;
                      String id = '';

                      try {
                        name = file.name ?? 'Unnamed';
                        id = file.id ?? '';
                        if (file.modifiedTime != null) {
                          // It's a DateTime
                          modifiedTime = DateFormat.yMMMd().add_jm().format(
                            file.modifiedTime!.toLocal(),
                          );
                        }
                      } catch (_) {
                        // Fallback if dynamic structure is different
                      }

                      return Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: theme.colorScheme.outlineVariant.withOpacity(
                              0.5,
                            ),
                          ),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: theme.colorScheme.primaryContainer,
                            child: Icon(
                              Icons.cloud_done,
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            modifiedTime ?? name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text(
                            'Google Drive • $name',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          trailing: TextButton(
                            onPressed: _busy ? null : () => _restore(id),
                            child: Text(l10n.restore),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _BackupActionCard extends StatelessWidget {
  final VoidCallback? onBackup;
  final bool isBusy;

  const _BackupActionCard({required this.onBackup, required this.isBusy});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: isBusy
                ? const SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : const Icon(
                    Icons.cloud_upload_rounded,
                    size: 32,
                    color: Colors.white,
                  ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.backupNow,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.backupToDrive, // "Backup to Drive" or similar
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            child: InkWell(
              onTap: onBackup,
              borderRadius: BorderRadius.circular(30),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: Text(
                  l10n.createFirstHabit.contains('Create')
                      ? 'Start Backup'
                      : l10n.backupNow, // Fallback logic, ideally strict key
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
