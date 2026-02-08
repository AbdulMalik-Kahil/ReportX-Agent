import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/employee.dart';
import '../services/agent_service.dart';
import '../widgets/analysis_dialog.dart';

class TeamsScreen extends StatelessWidget {
  final List<Employee> employees;
  final AgentService agentService;

  const TeamsScreen({
    super.key,
    required this.employees,
    required this.agentService,
  });

  Map<String, List<Employee>> get _teamGroups {
    final groups = <String, List<Employee>>{};
    for (final e in employees) {
      groups.putIfAbsent(e.team, () => []);
      groups[e.team]!.add(e);
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final teams = _teamGroups;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Teams',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${teams.length} teams \u2022 ${employees.length} total members',
            style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 24),

          if (employees.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 48),
              decoration: BoxDecoration(
                color: AppTheme.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.cardBorder),
              ),
              child: Column(children: [
                Icon(Icons.groups_outlined, size: 48, color: AppTheme.textMuted.withOpacity(0.5)),
                const SizedBox(height: 16),
                const Text('No teams yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                const SizedBox(height: 8),
                const Text('Upload a PDF report in Org Overview to see team data', style: TextStyle(fontSize: 13, color: AppTheme.textMuted)),
              ]),
            ),

          // Team Cards Grid
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: teams.entries.map((entry) {
              final teamName = entry.key;
              final members = entry.value;
              final avgPressure =
                  members.map((m) => m.pressure).reduce((a, b) => a + b) /
                      members.length;
              final avgBurnout =
                  members.map((m) => m.burnoutRisk).reduce((a, b) => a + b) /
                      members.length;

              return SizedBox(
                width: 380,
                child: _TeamCard(
                  teamName: teamName,
                  members: members,
                  avgPressure: avgPressure,
                  avgBurnout: avgBurnout,
                  onAnalyze: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AnalysisDialog(
                        agentService: agentService,
                        title: 'Team Analysis: $teamName',
                        prompt: '''
Analyze the "$teamName" team with the following members:

${members.map((m) => '- ${m.name} (${m.role}, ${m.level}): Burnout=${m.burnoutRisk}, Pressure=${m.pressure}, Potential=${m.potential}, Performance=${m.performance}').join('\n')}

Provide:
1. Team Health Summary
2. Workload Distribution Analysis
3. Risk Indicators (burnout, turnover)
4. Team Strengths
5. Areas for Improvement
6. Specific Manager Recommendations

Be concise and actionable.
''',
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _TeamCard extends StatelessWidget {
  final String teamName;
  final List<Employee> members;
  final double avgPressure;
  final double avgBurnout;
  final VoidCallback onAnalyze;

  const _TeamCard({
    required this.teamName,
    required this.members,
    required this.avgPressure,
    required this.avgBurnout,
    required this.onAnalyze,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.groups_rounded,
                        color: AppTheme.primary, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        teamName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        '${members.length} members',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                onPressed: onAnalyze,
                tooltip: 'Analyze with AI',
                icon: const Icon(Icons.analytics_rounded,
                    color: AppTheme.primary, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _MiniStat(
                  label: 'Avg Pressure',
                  value: avgPressure.toStringAsFixed(0)),
              const SizedBox(width: 24),
              _MiniStat(
                  label: 'Avg Burnout',
                  value: avgBurnout.toStringAsFixed(0)),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppTheme.cardBorder, height: 1),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: members
                .map((m) => Chip(
                      label: Text(
                        m.name.split(' ').first,
                        style: const TextStyle(fontSize: 11),
                      ),
                      visualDensity: VisualDensity.compact,
                      backgroundColor: AppTheme.background,
                      side: const BorderSide(color: AppTheme.cardBorder),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}
