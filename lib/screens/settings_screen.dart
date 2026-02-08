import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _privacyMode = true;
  bool _autoSync = false;
  bool _emailNotifications = true;
  String _syncFrequency = 'Daily';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Configure ReportX Agent preferences',
            style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 28),

          // Privacy Settings
          _SettingsSection(
            title: 'Privacy & Data',
            icon: Icons.shield_rounded,
            children: [
              _ToggleSetting(
                title: 'Privacy-First Mode',
                subtitle:
                    'Only collect aggregated metadata. No content is accessed.',
                value: _privacyMode,
                onChanged: (v) => setState(() => _privacyMode = v),
              ),
              _ToggleSetting(
                title: 'Auto-Sync Data',
                subtitle: 'Automatically sync employee metrics periodically.',
                value: _autoSync,
                onChanged: (v) => setState(() => _autoSync = v),
              ),
              _DropdownSetting(
                title: 'Sync Frequency',
                value: _syncFrequency,
                options: const ['Hourly', 'Daily', 'Weekly', 'Monthly'],
                onChanged: (v) => setState(() => _syncFrequency = v ?? 'Daily'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Notifications
          _SettingsSection(
            title: 'Notifications',
            icon: Icons.notifications_rounded,
            children: [
              _ToggleSetting(
                title: 'Email Notifications',
                subtitle: 'Receive alerts for burnout risks and team insights.',
                value: _emailNotifications,
                onChanged: (v) => setState(() => _emailNotifications = v),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Agent Configuration
          _SettingsSection(
            title: 'AI Agent Configuration',
            icon: Icons.smart_toy_rounded,
            children: [
              _InfoSetting(
                title: 'Agent Endpoint',
                value:
                    'https://reportx-agent-service-966589175692.us-central1.run.app',
              ),
              _InfoSetting(
                title: 'Agent Name',
                value: 'reportx_agent (analyst_agent)',
              ),
              _InfoSetting(
                title: 'Model',
                value: 'gemini-3-flash-preview',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              children: [
                Icon(icon, size: 20, color: AppTheme.primary),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppTheme.cardBorder),
          ...children,
        ],
      ),
    );
  }
}

class _ToggleSetting extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleSetting({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 12, color: AppTheme.textMuted)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primary,
          ),
        ],
      ),
    );
  }
}

class _DropdownSetting extends StatelessWidget {
  final String title;
  final String value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const _DropdownSetting({
    required this.title,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppTheme.cardBorder),
            ),
            child: DropdownButton<String>(
              value: value,
              underline: const SizedBox.shrink(),
              style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary),
              items: options
                  .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoSetting extends StatelessWidget {
  final String title;
  final String value;

  const _InfoSetting({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary)),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textMuted,
                fontFamily: 'monospace',
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
