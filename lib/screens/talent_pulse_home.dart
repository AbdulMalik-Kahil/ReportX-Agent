import 'package:flutter/material.dart';
import '../models/employee.dart';
import '../services/agent_service.dart';
import '../widgets/tp_sidebar.dart';
import 'org_overview_screen.dart';
import 'teams_screen.dart';
import 'employees_screen.dart';
import 'settings_screen.dart';
import 'transparency_screen.dart';

class TalentPulseHome extends StatefulWidget {
  const TalentPulseHome({super.key});

  @override
  State<TalentPulseHome> createState() => _TalentPulseHomeState();
}

class _TalentPulseHomeState extends State<TalentPulseHome> {
  int _selectedIndex = 0;
  final AgentService _agentService = AgentService();
  List<Employee> _employees = [];
  String? _lastAnalysis;

  @override
  void initState() {
    super.initState();
    _agentService.createSession();
  }

  /// Called when PDF data is imported — updates all screens
  void _onDataImported(List<Employee> employees, String analysis) {
    setState(() {
      if (employees.isNotEmpty) {
        _employees = employees;
      }
      _lastAnalysis = analysis;
    });
  }

  Widget _buildScreen() {
    switch (_selectedIndex) {
      case 0:
        return OrgOverviewScreen(
          employees: _employees,
          agentService: _agentService,
          lastAnalysis: _lastAnalysis,
          onDataImported: _onDataImported,
        );
      case 1:
        return TeamsScreen(
          employees: _employees,
          agentService: _agentService,
        );
      case 2:
        return EmployeesScreen(
          employees: _employees,
          agentService: _agentService,
        );
      case 3:
        return const SettingsScreen();
      case 4:
        return const TransparencyScreen();
      default:
        return OrgOverviewScreen(
          employees: _employees,
          agentService: _agentService,
          lastAnalysis: _lastAnalysis,
          onDataImported: _onDataImported,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          TpSidebar(
            selectedIndex: _selectedIndex,
            onItemSelected: (index) => setState(() => _selectedIndex = index),
          ),
          Expanded(child: _buildScreen()),
        ],
      ),
    );
  }
}
