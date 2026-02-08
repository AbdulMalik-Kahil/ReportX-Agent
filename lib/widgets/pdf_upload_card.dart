import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../theme/app_theme.dart';
import '../models/employee.dart';
import '../services/agent_service.dart';

class PdfUploadCard extends StatefulWidget {
  final AgentService agentService;
  final void Function(List<Employee> employees, String analysis) onDataImported;

  const PdfUploadCard({
    super.key,
    required this.agentService,
    required this.onDataImported,
  });

  @override
  State<PdfUploadCard> createState() => _PdfUploadCardState();
}

class _PdfUploadCardState extends State<PdfUploadCard> {
  bool _uploading = false;
  String? _error;
  String? _fileName;

  Future<void> _pickAndUploadPdf() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) return;
      final file = result.files.first;
      if (file.bytes == null) {
        setState(() => _error = 'Could not read file data.');
        return;
      }

      setState(() {
        _uploading = true;
        _error = null;
        _fileName = file.name;
      });

      final res = await widget.agentService.uploadPdfForAnalysis(
        fileBytes: file.bytes!,
        fileName: file.name,
      );

      if (mounted) {
        setState(() => _uploading = false);

        if (res.success && res.employees.isNotEmpty) {
          // Push data to parent — updates all screens
          widget.onDataImported(res.employees, res.analysis);
        } else if (!res.success) {
          setState(() => _error = res.error ?? 'Analysis failed.');
        } else {
          // No employees parsed but got analysis
          widget.onDataImported([], res.analysis);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _uploading = false;
          _error = 'Error: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.picture_as_pdf_rounded,
                      color: Color(0xFFD97706), size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PDF Data Import',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        'Upload a PDF — data will populate Teams, Employees & Overview',
                        style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: AppTheme.cardBorder, height: 24),

          // Content
          if (_error != null) _buildError(),
          if (_uploading) _buildLoading(),
          if (!_uploading && _error == null) _buildUploadArea(),
        ],
      ),
    );
  }

  Widget _buildUploadArea() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: InkWell(
        onTap: _pickAndUploadPdf,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 32),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.cardBorder, width: 1.5),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: AppTheme.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.cloud_upload_rounded,
                    color: AppTheme.primary, size: 28),
              ),
              const SizedBox(height: 12),
              const Text('Click to upload PDF',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary)),
              const SizedBox(height: 4),
              const Text('Employee data will update all dashboard screens',
                  style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        children: [
          if (_fileName != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFBAE6FD)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.description_rounded,
                      color: AppTheme.primary, size: 20),
                  const SizedBox(width: 10),
                  Text(_fileName!,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary)),
                ],
              ),
            ),
          const CircularProgressIndicator(color: AppTheme.primary),
          const SizedBox(height: 16),
          const Text('Extracting data & analyzing with AI...',
              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
          const SizedBox(height: 4),
          const Text('This may take 20-40 seconds',
              style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFECACA)),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: AppTheme.riskHigh, size: 20),
                const SizedBox(width: 10),
                Expanded(
                    child: Text(_error!,
                        style: const TextStyle(
                            fontSize: 13, color: AppTheme.riskHigh))),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => setState(() => _error = null),
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }
}
