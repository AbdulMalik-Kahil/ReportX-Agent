import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../models/employee.dart';

class PdfAnalysisResult {
  final bool success;
  final String filename;
  final int pages;
  final List<Employee> employees;
  final String analysis;
  final String? error;

  PdfAnalysisResult({
    required this.success,
    this.filename = '',
    this.pages = 0,
    this.employees = const [],
    this.analysis = '',
    this.error,
  });
}

class AgentService {
  static const String baseUrl =
      'https://reportx-agent-service-966589175692.us-central1.run.app';
  static const String appName = 'reportx_agent';

  String _userId = 'talent_pulse_user';
  String? _sessionId;

  String get userId => _userId;
  String? get sessionId => _sessionId;

  void setUserId(String id) => _userId = id;

  Future<String> createSession() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/apps/$appName/users/$_userId/sessions'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _sessionId = data['id'];
      }
    } catch (e) {
      print('Session creation error: $e');
    }
    return _sessionId ?? '';
  }

  String _extractResponseText(dynamic data) {
    if (data is List && data.isNotEmpty) {
      for (var i = data.length - 1; i >= 0; i--) {
        final event = data[i];
        final content = event['content'];
        if (content != null && content['role'] == 'model') {
          final parts = content['parts'] as List?;
          if (parts != null && parts.isNotEmpty) {
            final textParts = parts
                .where((p) => p['thought'] != true && p['text'] != null)
                .map((p) => p['text'] as String)
                .toList();
            if (textParts.isNotEmpty) return textParts.join('');
          }
        }
      }
    }
    return '';
  }

  Future<String> sendMessage(String message) async {
    if (_sessionId == null || _sessionId!.isEmpty) await createSession();
    if (_sessionId == null || _sessionId!.isEmpty) {
      return 'Error: Could not create session.';
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/run'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'app_name': appName,
          'user_id': _userId,
          'session_id': _sessionId,
          'new_message': {
            'role': 'user',
            'parts': [
              {'text': message}
            ],
          },
          'streaming': false,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final text = _extractResponseText(data);
        return text.isNotEmpty ? text : 'Agent returned empty response.';
      } else {
        return 'Error: ${response.statusCode}';
      }
    } catch (e) {
      return 'Connection error: $e';
    }
  }

  /// Upload PDF → get structured employees + analysis
  Future<PdfAnalysisResult> uploadPdfForAnalysis({
    required Uint8List fileBytes,
    required String fileName,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/api/analyze-pdf');
      final request = http.MultipartRequest('POST', uri);
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: fileName,
      ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        // Parse employees from response
        final List<Employee> employees = [];
        final rawEmployees = data['employees'] as List? ?? [];
        for (final e in rawEmployees) {
          try {
            employees.add(Employee.fromJson(e));
          } catch (_) {}
        }

        return PdfAnalysisResult(
          success: true,
          filename: data['filename'] ?? fileName,
          pages: data['pages'] ?? 0,
          employees: employees,
          analysis: data['analysis'] ?? '',
        );
      } else {
        final body = jsonDecode(response.body);
        return PdfAnalysisResult(
          success: false,
          error: body['detail'] ?? 'Upload failed: ${response.statusCode}',
        );
      }
    } catch (e) {
      return PdfAnalysisResult(success: false, error: 'Connection error: $e');
    }
  }

  void resetSession() => _sessionId = null;
}
