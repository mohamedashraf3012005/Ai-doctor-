import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';
import '../theme/app_theme.dart';
import '../utils/extensions.dart';

/// The shell layout containing the BottomNavigationBar.
class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/doctors')) return 1;
    if (location.startsWith('/diagnosis')) return 2;
    if (location.startsWith('/chat')) return 3;
    if (location.startsWith('/dashboard')) return 4;
    return 0; // Home
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/doctors');
        break;
      case 2:
        context.go('/diagnosis');
        break;
      case 3:
        // Auth required check
        _checkAuthAndNavigate(context, '/chat');
        break;
      case 4:
        _checkAuthAndNavigate(context, '/dashboard');
        break;
    }
  }

  void _checkAuthAndNavigate(BuildContext context, String path) {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      context.go(path);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.translate('signInToAccessSection')),
          backgroundColor: AppColors.primary,
          duration: const Duration(seconds: 2),
        ),
      );
      context.push('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _getSelectedIndex(context);
    final isDark = context.isDark;

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: (isDark ? Colors.black : const Color(0xFF062016)).withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) => _onItemTapped(index, context),
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark ? const Color(0xFF05281D) : Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: isDark ? Colors.white54 : AppColors.textSecondary,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: context.translate('home'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.people_outline),
              activeIcon: const Icon(Icons.people),
              label: context.translate('doctors'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.biotech_outlined),
              activeIcon: const Icon(Icons.biotech),
              label: context.translate('diagnosis'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.chat_bubble_outline),
              activeIcon: const Icon(Icons.chat_bubble),
              label: context.translate('chat'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.dashboard_outlined),
              activeIcon: const Icon(Icons.dashboard),
              label: context.translate('dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}
