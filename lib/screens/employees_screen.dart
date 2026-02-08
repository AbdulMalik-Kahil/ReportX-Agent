import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/employee.dart';
import '../services/agent_service.dart';
import '../widgets/analysis_dialog.dart';

class EmployeesScreen extends StatefulWidget {
  final List<Employee> employees;
  final AgentService agentService;

  const EmployeesScreen({
    super.key,
    required this.employees,
    required this.agentService,
  });

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  String _searchQuery = '';
  String _riskFilter = 'All Risk Levels';

  List<Employee> get _filteredEmployees {
    var list = widget.employees;

    // Search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      list = list.where((e) {
        return e.name.toLowerCase().contains(query) ||
            e.role.toLowerCase().contains(query) ||
            e.team.toLowerCase().contains(query);
      }).toList();
    }

    // Risk level filter
    if (_riskFilter != 'All Risk Levels') {
      list = list.where((e) {
        return e.burnoutLevel == _riskFilter ||
            e.pressureLevel == _riskFilter ||
            e.potentialLevel == _riskFilter ||
            e.performanceLevel == _riskFilter;
      }).toList();
    }

    return list;
  }

  void _evaluateEmployee(Employee employee) {
    showDialog(
      context: context,
      builder: (ctx) => AnalysisDialog(
        agentService: widget.agentService,
        title: 'Evaluation: ${employee.name}',
        prompt: '''
Provide a detailed performance evaluation for this employee:

Name: ${employee.name}
Role: ${employee.role} (${employee.level})
Team: ${employee.team}
Burnout Risk Score: ${employee.burnoutRisk} (${employee.burnoutLevel})
Performance Pressure: ${employee.pressure} (${employee.pressureLevel})
Growth Potential: ${employee.potential} (${employee.potentialLevel})
Performance Score: ${employee.performance} (${employee.performanceLevel})

Follow this structure:
1. Overall Performance Rating (Excellent/Good/Satisfactory/Needs Improvement/Poor)
2. Key Strengths (3-5)
3. Areas for Improvement (2-3)
4. Notable Achievements
5. Development Recommendations
6. Burnout Risk Assessment with reasoning
7. Growth Potential with career path suggestions
8. Manager Support Suggestions

Be objective, evidence-based, and privacy-focused.
''',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredEmployees;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'Employees',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'All employees \u2022 ${filtered.length} results',
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 20),

          if (widget.employees.isEmpty)
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.cardBorder),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.people_outline, size: 48, color: AppTheme.textMuted.withOpacity(0.5)),
                    const SizedBox(height: 16),
                    const Text('No employees yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                    const SizedBox(height: 8),
                    const Text('Upload a PDF report in Org Overview to see employee data', style: TextStyle(fontSize: 13, color: AppTheme.textMuted)),
                  ],
                ),
              ),
            ),

          if (widget.employees.isNotEmpty) ...[
          // Search & Filter Row
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.cardBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.cardBorder),
                  ),
                  child: TextField(
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: const InputDecoration(
                      hintText: 'Search by name, role, or team...',
                      hintStyle: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 13,
                      ),
                      prefixIcon: Icon(Icons.search,
                          color: AppTheme.textMuted, size: 20),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                decoration: BoxDecoration(
                  color: AppTheme.cardBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.cardBorder),
                ),
                child: DropdownButton<String>(
                  value: _riskFilter,
                  underline: const SizedBox.shrink(),
                  icon: const Icon(Icons.keyboard_arrow_down,
                      color: AppTheme.textSecondary, size: 20),
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textPrimary,
                  ),
                  items: ['All Risk Levels', 'Low', 'Medium', 'High']
                      .map((level) => DropdownMenuItem(
                            value: level,
                            child: Text(level),
                          ))
                      .toList(),
                  onChanged: (v) =>
                      setState(() => _riskFilter = v ?? 'All Risk Levels'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Table
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.cardBorder),
              ),
              child: Column(
                children: [
                  // Table Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text('EMPLOYEE',
                              style: _headerStyle),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text('TEAM',
                              style: _headerStyle),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text('BURNOUT RISK',
                              style: _headerStyle,
                              textAlign: TextAlign.center),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text('PRESSURE',
                              style: _headerStyle,
                              textAlign: TextAlign.center),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text('POTENTIAL',
                              style: _headerStyle,
                              textAlign: TextAlign.center),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text('PERFORMANCE',
                              style: _headerStyle,
                              textAlign: TextAlign.center),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: AppTheme.cardBorder),

                  // Table Body
                  Expanded(
                    child: ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 1, color: AppTheme.cardBorder),
                      itemBuilder: (context, index) {
                        final emp = filtered[index];
                        return _EmployeeRow(
                          employee: emp,
                          onTap: () => _evaluateEmployee(emp),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          ], // end if employees.isNotEmpty
        ],
      ),
    );
  }
}

const _headerStyle = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w600,
  color: AppTheme.textMuted,
  letterSpacing: 0.5,
);

class _EmployeeRow extends StatelessWidget {
  final Employee employee;
  final VoidCallback onTap;

  const _EmployeeRow({required this.employee, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              // Employee Name & Role
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee.name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      employee.subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              // Team
              Expanded(
                flex: 2,
                child: Text(
                  employee.team,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
              // Burnout Risk
              Expanded(
                flex: 2,
                child: _MetricCell(
                  value: employee.burnoutRisk,
                  level: employee.burnoutLevel,
                ),
              ),
              // Pressure
              Expanded(
                flex: 2,
                child: _MetricCell(
                  value: employee.pressure,
                  level: employee.pressureLevel,
                ),
              ),
              // Potential
              Expanded(
                flex: 2,
                child: _MetricCell(
                  value: employee.potential,
                  level: employee.potentialLevel,
                ),
              ),
              // Performance
              Expanded(
                flex: 2,
                child: _MetricCell(
                  value: employee.performance,
                  level: employee.performanceLevel,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricCell extends StatelessWidget {
  final int value;
  final String level;

  const _MetricCell({required this.value, required this.level});

  Color get _levelColor {
    switch (level) {
      case 'High':
        return AppTheme.riskHigh;
      case 'Medium':
        return AppTheme.riskMedium;
      default:
        return AppTheme.riskLow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$value',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          level,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: _levelColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
