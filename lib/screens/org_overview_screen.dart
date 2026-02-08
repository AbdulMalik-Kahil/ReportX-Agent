import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/employee.dart';
import '../services/agent_service.dart';
import '../widgets/stat_card.dart';
import '../widgets/risk_chart.dart';
import '../widgets/overloaded_teams_card.dart';
import '../widgets/privacy_notice.dart';
import '../widgets/analysis_dialog.dart';
import '../widgets/pdf_upload_card.dart';

class OrgOverviewScreen extends StatefulWidget {
  final List<Employee> employees;
  final AgentService agentService;
  final String? lastAnalysis;
  final void Function(List<Employee>, String) onDataImported;

  const OrgOverviewScreen({
    super.key,
    required this.employees,
    required this.agentService,
    this.lastAnalysis,
    required this.onDataImported,
  });

  @override
  State<OrgOverviewScreen> createState() => _OrgOverviewScreenState();
}

class _OrgOverviewScreenState extends State<OrgOverviewScreen> {
  bool _syncing = false;
  bool _analysisExpanded = true;

  bool get _hasData => widget.employees.isNotEmpty;

  OrgMetrics _computeMetrics() {
    final employees = widget.employees;
    if (employees.isEmpty) {
      return OrgMetrics(
        totalEmployees: 0, totalTeams: 0,
        burnoutAlerts: 0, burnoutMediumRisk: 0,
        highPotentials: 0, emergingPotentials: 0,
        burnoutDistribution: {'Low': 0, 'Medium': 0, 'High': 0},
        pressureDistribution: {'Low': 0, 'Medium': 0, 'High': 0},
        growthDistribution: {'Low': 0, 'Medium': 0, 'High': 0},
        performanceDistribution: {'Low': 0, 'Medium': 0, 'High': 0},
        overloadedTeams: [],
      );
    }

    final teams = <String>{};
    int burnoutAlerts = 0, burnoutMedium = 0, highPotentials = 0, emergingPotentials = 0;
    final burnout = {'Low': 0, 'Medium': 0, 'High': 0};
    final pressure = {'Low': 0, 'Medium': 0, 'High': 0};
    final growth = {'Low': 0, 'Medium': 0, 'High': 0};
    final perf = {'Low': 0, 'Medium': 0, 'High': 0};
    final teamWorkloads = <String, List<int>>{};

    for (final e in employees) {
      teams.add(e.team);
      burnout[e.burnoutLevel] = (burnout[e.burnoutLevel] ?? 0) + 1;
      if (e.burnoutLevel == 'High') burnoutAlerts++;
      if (e.burnoutLevel == 'Medium') burnoutMedium++;
      pressure[e.pressureLevel] = (pressure[e.pressureLevel] ?? 0) + 1;
      growth[e.potentialLevel] = (growth[e.potentialLevel] ?? 0) + 1;
      if (e.potentialLevel == 'High') highPotentials++;
      if (e.potentialLevel == 'Medium') emergingPotentials++;
      perf[e.performanceLevel] = (perf[e.performanceLevel] ?? 0) + 1;
      teamWorkloads.putIfAbsent(e.team, () => []);
      teamWorkloads[e.team]!.add(e.pressure);
    }

    final overloaded = <TeamData>[];
    teamWorkloads.forEach((team, pressures) {
      final avg = pressures.reduce((a, b) => a + b) / pressures.length;
      if (avg > 15) {
        overloaded.add(TeamData(
          name: team, avgWorkload: avg, memberCount: pressures.length,
          members: employees.where((e) => e.team == team).toList(),
        ));
      }
    });
    overloaded.sort((a, b) => b.avgWorkload.compareTo(a.avgWorkload));

    return OrgMetrics(
      totalEmployees: employees.length, totalTeams: teams.length,
      burnoutAlerts: burnoutAlerts, burnoutMediumRisk: burnoutMedium,
      highPotentials: highPotentials, emergingPotentials: emergingPotentials,
      burnoutDistribution: burnout, pressureDistribution: pressure,
      growthDistribution: growth, performanceDistribution: perf,
      overloadedTeams: overloaded,
    );
  }

  void _syncData() {
    if (!_hasData) return;
    setState(() => _syncing = true);
    final data = widget.employees.map((e) => e.toJson()).toList();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AnalysisDialog(
        agentService: widget.agentService,
        title: 'Organization Analysis',
        prompt:
            'Analyze ${data.length} employees:\n${data.map((e) => "- ${e['name']} (${e['role']}, ${e['team']}): Burnout=${e['burnout_risk']}, Pressure=${e['pressure']}, Potential=${e['potential']}, Perf=${e['performance']}").join('\n')}\n\nProvide: Health Summary, Risk Analysis, Recommendations.',
      ),
    );
    setState(() => _syncing = false);
  }

  @override
  Widget build(BuildContext context) {
    final m = _computeMetrics();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Organization Overview',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                  const SizedBox(height: 4),
                  Text('AI-powered talent intelligence \u2022 Privacy-first \u2022 Explainable',
                      style: TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
                ],
              ),
              if (_hasData)
                ElevatedButton.icon(
                  onPressed: _syncing ? null : _syncData,
                  icon: _syncing
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.sync_rounded, size: 18),
                  label: Text(_syncing ? 'Syncing...' : 'Sync Data'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.syncGreen, foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 28),

          // PDF Upload — always shown at top when no data
          if (!_hasData) ...[
            _buildEmptyState(),
            const SizedBox(height: 20),
          ],

          PdfUploadCard(
            agentService: widget.agentService,
            onDataImported: widget.onDataImported,
          ),
          const SizedBox(height: 20),

          // === Everything below only shows when data exists ===
          if (_hasData) ...[
            // Stat Cards
            LayoutBuilder(builder: (context, c) {
              final w = (c.maxWidth - 48) / 4;
              return Row(children: [
                SizedBox(width: w, child: StatCard(title: 'Employees', value: '${m.totalEmployees}', icon: Icon(Icons.groups_rounded, color: AppTheme.textMuted, size: 28))),
                const SizedBox(width: 16),
                SizedBox(width: w, child: StatCard(title: 'Teams', value: '${m.totalTeams}', icon: Icon(Icons.grid_view_rounded, color: AppTheme.textMuted, size: 28))),
                const SizedBox(width: 16),
                SizedBox(width: w, child: StatCard(title: 'Burnout Alerts', value: '${m.burnoutAlerts}', subtitle: '${m.burnoutMediumRisk} medium risk', icon: const Text('🔴', style: TextStyle(fontSize: 24)))),
                const SizedBox(width: 16),
                SizedBox(width: w, child: StatCard(title: 'High Potentials', value: '${m.highPotentials}', subtitle: '${m.emergingPotentials} emerging', icon: const Text('⭐', style: TextStyle(fontSize: 24)))),
              ]);
            }),
            const SizedBox(height: 20),

            // Charts Row 1
            LayoutBuilder(builder: (context, c) {
              final w = (c.maxWidth - 16) / 2;
              return Row(children: [
                SizedBox(width: w, child: RiskChart(title: 'Burnout Risk', data: m.burnoutDistribution)),
                const SizedBox(width: 16),
                SizedBox(width: w, child: RiskChart(title: 'Performance Pressure', data: m.pressureDistribution)),
              ]);
            }),
            const SizedBox(height: 20),

            // Charts Row 2
            LayoutBuilder(builder: (context, c) {
              final w = (c.maxWidth - 16) / 2;
              return Row(children: [
                SizedBox(width: w, child: RiskChart(title: 'Growth Potential', data: m.growthDistribution)),
                const SizedBox(width: 16),
                SizedBox(width: w, child: RiskChart(title: 'Performance Degradation', data: m.performanceDistribution)),
              ]);
            }),
            const SizedBox(height: 20),

            // AI Analysis
            if (widget.lastAnalysis != null && widget.lastAnalysis!.isNotEmpty)
              _buildAnalysisCard(),

            if (widget.lastAnalysis != null && widget.lastAnalysis!.isNotEmpty)
              const SizedBox(height: 20),

            // Overloaded Teams
            if (m.overloadedTeams.isNotEmpty)
              OverloadedTeamsCard(teams: m.overloadedTeams),

            if (m.overloadedTeams.isNotEmpty)
              const SizedBox(height: 20),
          ],

          // Privacy Notice — always shown
          const PrivacyNotice(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(
        children: [
          Icon(Icons.insert_drive_file_outlined, size: 48, color: AppTheme.textMuted.withOpacity(0.5)),
          const SizedBox(height: 16),
          const Text(
            'No employee data yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 8),
          const Text(
            'Upload a PDF report below to populate the dashboard\nwith employee metrics, team analytics, and AI insights',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppTheme.textMuted, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _analysisExpanded = !_analysisExpanded),
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFEFF6FF),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.analytics_rounded, color: AppTheme.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('AI Analysis Report', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                      Text('Generated from uploaded PDF data', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                    ]),
                  ),
                  Icon(_analysisExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded, color: AppTheme.textSecondary),
                ],
              ),
            ),
          ),
          if (_analysisExpanded)
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxHeight: 500),
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: SelectableText(widget.lastAnalysis!, style: const TextStyle(fontSize: 13, height: 1.7, color: AppTheme.textPrimary)),
              ),
            ),
        ],
      ),
    );
  }
}
