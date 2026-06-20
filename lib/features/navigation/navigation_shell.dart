import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/glass_bottom_nav.dart';
import '../../core/widgets/gradient_background.dart';

/// Main navigation shell with glassmorphic bottom nav.
/// Wraps the 4 main tabs: Home, Payments, Room, Profile.
class NavigationShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const NavigationShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: GradientBackground(
        child: navigationShell,
      ),
      bottomNavigationBar: GlassBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        items: const [
          GlassBottomNavItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            label: 'Home',
          ),
          GlassBottomNavItem(
            icon: Icons.account_balance_wallet_outlined,
            activeIcon: Icons.account_balance_wallet_rounded,
            label: 'Payments',
          ),
          GlassBottomNavItem(
            icon: Icons.bed_outlined,
            activeIcon: Icons.bed_rounded,
            label: 'Room',
          ),
          GlassBottomNavItem(
            icon: Icons.person_outline_rounded,
            activeIcon: Icons.person_rounded,
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
