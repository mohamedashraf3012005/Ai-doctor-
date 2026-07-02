import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';

/// Dashed file upload container replicating the website's upload dropzone.
class UploadDropzone extends StatelessWidget {
  final String? selectedFilePath;
  final String? selectedFileName;
  final ValueChanged<PlatformFile> onFileSelected;
  final VoidCallback onClearFile;

  const UploadDropzone({
    super.key,
    required this.selectedFilePath,
    required this.selectedFileName,
    required this.onFileSelected,
    required this.onClearFile,
  });

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );
    if (result != null && result.files.single.path != null) {
      onFileSelected(result.files.single);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF05281D) : Colors.white,
        borderRadius: AppRadius.card,
        border: Border.all(
          color: isDark ? const Color(0xFF114C39) : AppColors.border,
          style: BorderStyle.solid,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: selectedFilePath != null
            ? Column(
                children: [
                  ClipRRect(
                    borderRadius: AppRadius.button,
                    child: selectedFileName!.toLowerCase().endsWith('.pdf')
                        ? Container(
                            height: 180,
                            width: double.infinity,
                            color: Colors.red.shade50,
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.picture_as_pdf, color: Colors.red, size: 64),
                                SizedBox(height: 12),
                                Text(
                                  'PDF Report Selected',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                                ),
                              ],
                            ),
                          )
                        : Image.file(
                            File(selectedFilePath!),
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          selectedFileName!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white70 : AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: onClearFile,
                        icon: const Icon(Icons.delete_outline, color: AppColors.danger),
                      ),
                    ],
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.cloud_upload_outlined,
                      size: 32,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Select a medical scan file',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Supports JPG, PNG, or PDF formats',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Material(
                    color: AppColors.primary,
                    borderRadius: AppRadius.pill,
                    child: InkWell(
                      onTap: _pickFile,
                      borderRadius: AppRadius.pill,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        child: Text(
                          'Browse Files',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
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
