import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/chat_contact_entity.dart';

/// Contact list tile with active selected indicator.
class ContactTile extends StatelessWidget {
  final ChatContactEntity contact;
  final bool isActive;
  final VoidCallback onTap;

  const ContactTile({
    super.key,
    required this.contact,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    // Resolve icon/avatar details
    String avatarIcon = '🤖';
    if (contact.type == 'doctor') avatarIcon = '👨‍⚕️';
    if (contact.type == 'patient') avatarIcon = '👤';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isActive
            ? (isDark ? const Color(0xFF093D2C) : const Color(0xFFEBFDF5))
            : Colors.transparent,
        borderRadius: AppRadius.button,
        border: isActive
            ? const Border(
                left: BorderSide(color: AppColors.primary, width: 4),
              )
            : null,
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Stack(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  avatarIcon,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            // Online status indicator dot
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: contact.online ? AppColors.success : Colors.grey,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
          ],
        ),
        title: Text(
          contact.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: contact.specialization != null
            ? Text(
                contact.specialization!,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
      ),
    );
  }
}
