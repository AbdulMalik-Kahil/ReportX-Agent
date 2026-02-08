import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TransparencyScreen extends StatelessWidget {
  const TransparencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Transparency',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'How ReportX Agent protects your data and ensures fairness',
            style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 28),

          // Data Collection
          _TransparencyCard(
            icon: Icons.data_usage_rounded,
            title: 'What Data We Collect',
            items: const [
              'Aggregated metadata only: counts, durations, timestamps',
              'No message content, email subjects, or attachments',
              'No screen activity or browsing data',
              'No personal communications or private messages',
              'Only professional performance metrics shared by managers',
            ],
          ),
          const SizedBox(height: 16),

          // How AI Works
          _TransparencyCard(
            icon: Icons.smart_toy_rounded,
            title: 'How Our AI Works',
            items: const [
              'AI evaluations are advisory - managers make final decisions',
              'Every insight includes clear reasoning and evidence',
              'Bias detection: model outputs are checked for demographic bias',
              'No black-box decisions - all recommendations are explainable',
              'Regular model audits for fairness and accuracy',
            ],
          ),
          const SizedBox(height: 16),

          // Privacy Principles
          _TransparencyCard(
            icon: Icons.shield_rounded,
            title: 'Privacy Principles',
            items: const [
              'Privacy-First Mode: enabled by default for all organizations',
              'Data minimization: collect only what\'s necessary',
              'Encryption at rest and in transit',
              'No data sold to third parties - ever',
              'Employees can request their data at any time',
              'Compliant with GDPR, CCPA, and SOC 2 standards',
            ],
          ),
          const SizedBox(height: 16),

          // Bias Prevention
          _TransparencyCard(
            icon: Icons.balance_rounded,
            title: 'Bias Prevention',
            items: const [
              'Demographic-blind evaluations: gender, race, age not used',
              'Regular bias audits on model outputs',
              'Diverse training data and evaluation criteria',
              'Human-in-the-loop: AI assists, humans decide',
              'Feedback mechanism for flagging unfair assessments',
            ],
          ),
        ],
      ),
    );
  }
}

class _TransparencyCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> items;

  const _TransparencyCard({
    required this.icon,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppTheme.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Icon(Icons.check_circle_rounded,
                          color: AppTheme.riskLow, size: 16),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
