import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PrivacyNotice extends StatelessWidget {
  const PrivacyNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.privacyBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.privacyBorder, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🔒 ', style: TextStyle(fontSize: 14)),
          Expanded(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: 'Privacy Notice: ',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text:
                        'ReportX Agent collects ONLY aggregated metadata (counts, durations, timestamps). No message content, email subjects, attachments, or screen activity is ever accessed.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
