import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/employee.dart';

class OverloadedTeamsCard extends StatelessWidget {
  final List<TeamData> teams;

  const OverloadedTeamsCard({super.key, required this.teams});

  @override
  Widget build(BuildContext context) {
    if (teams.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.warningBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.warningBorder, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded,
                  color: AppTheme.warningText, size: 22),
              const SizedBox(width: 8),
              const Text(
                'Overloaded Teams',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...teams.map((team) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      team.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      'Avg workload: ${team.avgWorkload.toInt()}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'monospace',
                        color: AppTheme.warningText,
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
