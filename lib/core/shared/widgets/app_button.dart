import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Primary app button matching the website's pill-style buttons.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isOutlined;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final Color? color;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isOutlined = false,
    this.isLoading = false,
    this.icon,
    this.width,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = color ?? AppColors.primary;

    return SizedBox(
      width: width,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Material(
          color: isOutlined ? Colors.transparent : bgColor,
          borderRadius: AppRadius.pill,
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(999)),
            onTap: isLoading ? null : onPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: isOutlined
                  ? BoxDecoration(
                      borderRadius: AppRadius.pill,
                      border: Border.all(
                        color: bgColor.withValues(alpha: 0.5),
                      ),
                    )
                  : null,
              child: Row(
                mainAxisSize: width != null ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoading) ...[
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(
                          isOutlined ? bgColor : Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ] else if (icon != null) ...[
                    Icon(
                      icon,
                      size: 18,
                      color: isOutlined ? bgColor : Colors.white,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      color: isOutlined ? bgColor : Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
