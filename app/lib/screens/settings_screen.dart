import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../services/audio_service.dart';
import '../services/vibration_service.dart';
import '../services/storage_service.dart';

/// Settings screen
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _sfxEnabled = true;
  bool _bgmEnabled = true;
  bool _vibrationEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      _sfxEnabled = AudioService.instance.sfxEnabled;
      _bgmEnabled = AudioService.instance.bgmEnabled;
      _vibrationEnabled = VibrationService.instance.enabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GameColors.background,
      appBar: AppBar(
        backgroundColor: GameColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'SETTINGS',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Sound section
            _buildSectionTitle('SOUND'),
            const SizedBox(height: 12),
            _buildSettingTile(
              icon: Icons.music_note,
              title: 'Background Music',
              value: _bgmEnabled,
              onChanged: (value) {
                setState(() {
                  _bgmEnabled = value;
                });
                AudioService.instance.setBGMEnabled(value);
              },
            ),
            const SizedBox(height: 8),
            _buildSettingTile(
              icon: Icons.volume_up,
              title: 'Sound Effects',
              value: _sfxEnabled,
              onChanged: (value) {
                setState(() {
                  _sfxEnabled = value;
                });
                AudioService.instance.setSFXEnabled(value);
              },
            ),

            const SizedBox(height: 32),

            // Haptics section
            _buildSectionTitle('HAPTICS'),
            const SizedBox(height: 12),
            _buildSettingTile(
              icon: Icons.vibration,
              title: 'Vibration',
              value: _vibrationEnabled,
              onChanged: (value) {
                setState(() {
                  _vibrationEnabled = value;
                });
                VibrationService.instance.setEnabled(value);
              },
            ),

            const SizedBox(height: 32),

            // Data section
            _buildSectionTitle('DATA'),
            const SizedBox(height: 12),
            _buildActionTile(
              icon: Icons.delete_outline,
              title: 'Reset Progress',
              subtitle: 'Clear all saved data',
              color: Colors.red,
              onTap: () => _showResetConfirmation(context),
            ),

            const SizedBox(height: 32),

            // About section
            _buildSectionTitle('ABOUT'),
            const SizedBox(height: 12),
            _buildInfoTile(
              icon: Icons.info_outline,
              title: 'Version',
              value: '1.0.0',
            ),
            const SizedBox(height: 8),
            _buildInfoTile(
              icon: Icons.code,
              title: 'Built with',
              value: 'Flutter',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white54,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: GameColors.boardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: GameColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: GameColors.boardBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: color.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: GameColors.boardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: GameColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Reset Progress?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'This will delete all your saved data including high score, coins, and statistics. This action cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'CANCEL',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              await StorageService.instance.clearAll();
              if (mounted) {
                navigator.pop();
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('Progress has been reset'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text(
              'RESET',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
