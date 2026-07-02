import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../theme/app_theme.dart';

/// Shimmer loading placeholder widget.
class AppLoadingWidget extends StatelessWidget {
  final int itemCount;

  const AppLoadingWidget({super.key, this.itemCount = 3});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF093D2C) : Colors.grey.shade200,
      highlightColor: isDark ? const Color(0xFF114C39) : Colors.grey.shade50,
      child: Column(
        children: List.generate(
          itemCount,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppRadius.card,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Centered circular loading spinner.
class AppLoadingSpinner extends StatelessWidget {
  final String? message;

  const AppLoadingSpinner({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
