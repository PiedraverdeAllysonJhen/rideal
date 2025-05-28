import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final Color themeLite;
  final Color themeDark;
  final Color themeGrey;
  final int navItem;
  final bool isSignedIn;
  final bool isFullyLoaded;
  final bool isAdminMode;
  final ValueChanged<int>? onItemSelected;
  final int notificationCount; // Add notification count parameter

  const CustomBottomNavBar({
    super.key,
    required this.themeLite,
    required this.themeDark,
    required this.themeGrey,
    required this.navItem,
    required this.isSignedIn,
    required this.isFullyLoaded,
    required this.isAdminMode,
    this.onItemSelected,
    this.notificationCount = 0, // Default to 0
  });

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isSelected,
    int badgeCount = 0, // Add badge count parameter
  }) {
    Widget iconWidget = Icon(
      icon,
      size: 24,
      color: isSelected ? themeDark : Colors.grey,
    );

    // Add badge if count is provided and > 0
    if (badgeCount > 0 && index == 3) {
      iconWidget = Stack(
        clipBehavior: Clip.none,
        children: [
          iconWidget,
          Positioned(
            top: -5,
            right: -5,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                badgeCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );
    }

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onItemSelected != null ? () => onItemSelected!(index) : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            iconWidget,
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSelected ? themeDark : themeGrey,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Row(
        children: [
          _buildNavItem(
            index: 0,
            icon: Icons.home_outlined,
            label: "Home",
            isSelected: navItem == 0,
          ),
          _buildNavItem(
            index: 1,
            icon: Icons.receipt_long_outlined,
            label: isAdminMode ? "Requests" : "Bookings",
            isSelected: navItem == 1,
          ),
          _buildNavItem(
            index: 2,
            icon: isAdminMode
                ? Icons.add_circle_outline
                : Icons.directions_car_filled_outlined,
            label: isAdminMode ? "Post" : "Vehicles",
            isSelected: navItem == 2,
          ),
          _buildNavItem(
            index: 3,
            icon: Icons.notifications_none,
            label: "Notifications",
            isSelected: navItem == 3,
            badgeCount: notificationCount, // Pass notification count here
          ),
          _buildNavItem(
            index: 4,
            icon: Icons.person_outline,
            label: "Profile",
            isSelected: navItem == 4,
          ),
        ],
      ),
    );
  }
}