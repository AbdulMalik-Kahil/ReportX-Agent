class Employee {
  final String name;
  final String role;
  final String level;
  final String team;
  final int burnoutRisk;
  final String burnoutLevel;
  final int pressure;
  final String pressureLevel;
  final int potential;
  final String potentialLevel;
  final int performance;
  final String performanceLevel;

  const Employee({
    required this.name,
    required this.role,
    required this.level,
    required this.team,
    required this.burnoutRisk,
    required this.burnoutLevel,
    required this.pressure,
    required this.pressureLevel,
    required this.potential,
    required this.potentialLevel,
    required this.performance,
    required this.performanceLevel,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      level: json['level'] ?? '',
      team: json['team'] ?? '',
      burnoutRisk: json['burnout_risk'] ?? 0,
      burnoutLevel: json['burnout_level'] ?? 'Low',
      pressure: json['pressure'] ?? 0,
      pressureLevel: json['pressure_level'] ?? 'Low',
      potential: json['potential'] ?? 0,
      potentialLevel: json['potential_level'] ?? 'Low',
      performance: json['performance'] ?? 0,
      performanceLevel: json['performance_level'] ?? 'Low',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'role': role,
      'level': level,
      'team': team,
      'burnout_risk': burnoutRisk,
      'burnout_level': burnoutLevel,
      'pressure': pressure,
      'pressure_level': pressureLevel,
      'potential': potential,
      'potential_level': potentialLevel,
      'performance': performance,
      'performance_level': performanceLevel,
    };
  }

  String get subtitle => '$role \u2022 $level';
}

class TeamData {
  final String name;
  final double avgWorkload;
  final int memberCount;
  final List<Employee> members;

  const TeamData({
    required this.name,
    required this.avgWorkload,
    required this.memberCount,
    required this.members,
  });
}

class OrgMetrics {
  final int totalEmployees;
  final int totalTeams;
  final int burnoutAlerts;
  final int burnoutMediumRisk;
  final int highPotentials;
  final int emergingPotentials;
  final Map<String, int> burnoutDistribution;
  final Map<String, int> pressureDistribution;
  final Map<String, int> growthDistribution;
  final Map<String, int> performanceDistribution;
  final List<TeamData> overloadedTeams;

  const OrgMetrics({
    required this.totalEmployees,
    required this.totalTeams,
    required this.burnoutAlerts,
    required this.burnoutMediumRisk,
    required this.highPotentials,
    required this.emergingPotentials,
    required this.burnoutDistribution,
    required this.pressureDistribution,
    required this.growthDistribution,
    required this.performanceDistribution,
    required this.overloadedTeams,
  });
}

// --- Sample Data ---
List<Employee> getSampleEmployees() {
  return const [
    Employee(name: 'Alice Chen', role: 'Senior Engineer', level: 'Senior', team: 'Platform', burnoutRisk: 0, burnoutLevel: 'Low', pressure: 16, pressureLevel: 'Low', potential: 33, potentialLevel: 'Low', performance: 0, performanceLevel: 'Low'),
    Employee(name: 'Bob Martinez', role: 'Engineer', level: 'Mid', team: 'Platform', burnoutRisk: 24, burnoutLevel: 'Low', pressure: 52, pressureLevel: 'Medium', potential: 16, potentialLevel: 'Low', performance: 16, performanceLevel: 'Low'),
    Employee(name: 'Carol Okafor', role: 'Tech Lead', level: 'Lead', team: 'Platform', burnoutRisk: 15, burnoutLevel: 'Low', pressure: 30, pressureLevel: 'Low', potential: 20, potentialLevel: 'Low', performance: 7, performanceLevel: 'Low'),
    Employee(name: 'David Kim', role: 'Junior Engineer', level: 'Junior', team: 'Frontend', burnoutRisk: 0, burnoutLevel: 'Low', pressure: 20, pressureLevel: 'Low', potential: 56, potentialLevel: 'Medium', performance: 0, performanceLevel: 'Low'),
    Employee(name: 'Eva Novak', role: 'Engineer', level: 'Mid', team: 'Frontend', burnoutRisk: 0, burnoutLevel: 'Low', pressure: 7, pressureLevel: 'Low', potential: 40, potentialLevel: 'Medium', performance: 0, performanceLevel: 'Low'),
    Employee(name: 'Frank Torres', role: 'Senior Engineer', level: 'Senior', team: 'Backend', burnoutRisk: 0, burnoutLevel: 'Low', pressure: 15, pressureLevel: 'Low', potential: 28, potentialLevel: 'Low', performance: 0, performanceLevel: 'Low'),
    Employee(name: 'Grace Liu', role: 'Product Manager', level: 'Senior', team: 'Product', burnoutRisk: 32, burnoutLevel: 'Low', pressure: 50, pressureLevel: 'Medium', potential: 15, potentialLevel: 'Low', performance: 15, performanceLevel: 'Low'),
    Employee(name: 'Hassan Ali', role: 'Designer', level: 'Mid', team: 'Design', burnoutRisk: 0, burnoutLevel: 'Low', pressure: 13, pressureLevel: 'Low', potential: 29, potentialLevel: 'Low', performance: 0, performanceLevel: 'Low'),
    Employee(name: 'Ivy Zhang', role: 'QA Engineer', level: 'Mid', team: 'QA', burnoutRisk: 10, burnoutLevel: 'Low', pressure: 25, pressureLevel: 'Low', potential: 35, potentialLevel: 'Low', performance: 5, performanceLevel: 'Low'),
    Employee(name: 'Jake Wilson', role: 'DevOps Engineer', level: 'Senior', team: 'Infrastructure', burnoutRisk: 18, burnoutLevel: 'Low', pressure: 40, pressureLevel: 'Low', potential: 22, potentialLevel: 'Low', performance: 8, performanceLevel: 'Low'),
    Employee(name: 'Karen Patel', role: 'Data Analyst', level: 'Mid', team: 'Data', burnoutRisk: 5, burnoutLevel: 'Low', pressure: 18, pressureLevel: 'Low', potential: 45, potentialLevel: 'Medium', performance: 3, performanceLevel: 'Low'),
    Employee(name: 'Leo Brown', role: 'Engineer', level: 'Junior', team: 'Backend', burnoutRisk: 0, burnoutLevel: 'Low', pressure: 10, pressureLevel: 'Low', potential: 50, potentialLevel: 'Medium', performance: 0, performanceLevel: 'Low'),
    Employee(name: 'Mia Thompson', role: 'UX Researcher', level: 'Mid', team: 'Design', burnoutRisk: 8, burnoutLevel: 'Low', pressure: 22, pressureLevel: 'Low', potential: 38, potentialLevel: 'Low', performance: 2, performanceLevel: 'Low'),
    Employee(name: 'Noah Garcia', role: 'Engineer', level: 'Mid', team: 'Platform', burnoutRisk: 20, burnoutLevel: 'Low', pressure: 45, pressureLevel: 'Medium', potential: 18, potentialLevel: 'Low', performance: 12, performanceLevel: 'Low'),
    Employee(name: 'Olivia Scott', role: 'Scrum Master', level: 'Senior', team: 'Product', burnoutRisk: 12, burnoutLevel: 'Low', pressure: 28, pressureLevel: 'Low', potential: 30, potentialLevel: 'Low', performance: 6, performanceLevel: 'Low'),
  ];
}
