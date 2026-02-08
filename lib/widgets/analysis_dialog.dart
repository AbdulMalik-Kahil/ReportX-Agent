import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/agent_service.dart';

class AnalysisDialog extends StatefulWidget {
  final AgentService agentService;
  final String prompt;
  final String title;

  const AnalysisDialog({
    super.key,
    required this.agentService,
    required this.prompt,
    required this.title,
  });

  @override
  State<AnalysisDialog> createState() => _AnalysisDialogState();
}

class _AnalysisDialogState extends State<AnalysisDialog> {
  String _response = '';
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _fetchAnalysis();
  }

  Future<void> _fetchAnalysis() async {
    try {
      final result = await widget.agentService.sendMessage(widget.prompt);
      if (mounted) {
        setState(() {
          _response = result;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _response = 'Failed to get analysis: $e';
          _loading = false;
          _error = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.analytics_rounded,
                      color: AppTheme.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(height: 24),
            if (_loading)
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: AppTheme.primary),
                      SizedBox(height: 16),
                      Text(
                        'Analyzing with AI Agent...',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: SingleChildScrollView(
                  child: SelectableText(
                    _response,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.6,
                      color: _error ? AppTheme.riskHigh : AppTheme.textPrimary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
