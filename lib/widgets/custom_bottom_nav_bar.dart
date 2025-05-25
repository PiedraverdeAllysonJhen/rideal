import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatefulWidget {
  final Color themeLite;
  final Color themeDark;
  final Color themeGrey;
  final int navItem;
  final bool isAdminMode;
  final bool isSignedIn;
  final bool hideAdminFeatures;
  final bool isFullyLoaded;
  final ValueChanged<int>? onItemSelected;

  const CustomBottomNavBar({
    super.key,
    required this.themeLite,
    required this.themeDark,
    required this.themeGrey,
    required this.navItem,
    required this.isAdminMode,
    required this.isSignedIn,
    required this.hideAdminFeatures,
    required this.isFullyLoaded,
    this.onItemSelected,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  static const double _iconSize = 24;
  static const double _labelFontSize = 14;
  static const double _itemWidth = 80;
  static const double _spacingWidth = 14;
  static const double _itemPadding = 8;
  static const double _iconPadding = 12;
  static const double _labelSpacing = 3;
  static const double _navBarHeight = 100;
  static const EdgeInsets _navBarPadding = EdgeInsets.fromLTRB(12, 2, 12, 10);
  static final BorderRadius _itemBorderRadius = BorderRadius.circular(24);

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    final themeLite = widget.themeLite;
    final themeDark = widget.themeDark;
    final themeGrey = widget.themeGrey;
    final onItemSelected = widget.onItemSelected;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: _itemWidth,
          decoration: BoxDecoration(
            borderRadius: _itemBorderRadius,
          ),
          child: Material(
            color: isSelected ? themeLite : Colors.transparent,
            borderRadius: _itemBorderRadius,
            child: InkWell(
              borderRadius: _itemBorderRadius,
              onTap: onItemSelected != null ? () => onItemSelected(index) : null,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    _iconPadding, _itemPadding, _iconPadding, _itemPadding),
                child: Icon(
                  icon,
                  color: isSelected ? themeDark : Colors.black45,
                  size: _iconSize,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: _labelSpacing),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: _labelFontSize,
            fontWeight: FontWeight.bold,
            color: isSelected ? themeDark : themeGrey,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final navItem = widget.navItem;
    final isAdminMode = widget.isAdminMode;
    final isSignedIn = widget.isSignedIn;
    final hideAdminFeatures = widget.hideAdminFeatures;
    final isFullyLoaded = widget.isFullyLoaded;

    return Container(
      height: _navBarHeight,
      width: double.infinity,
      padding: _navBarPadding,
      color: Colors.white,
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.location_searching_outlined,
                label: "Home",
                isSelected: navItem == 0,
              ),
              if (!isAdminMode) const SizedBox(width: _spacingWidth),
              if (!isAdminMode)
                _buildNavItem(
                  index: 1,
                  icon: Icons.menu_book,
                  label: "Study",
                  isSelected: navItem == 1,
                ),
              if (isSignedIn && !isAdminMode) const SizedBox(width: _spacingWidth),
              if (isSignedIn && !isAdminMode)
                _buildNavItem(
                  index: 2,
                  icon: Icons.emoji_events,
                  label: "Leaderboard",
                  isSelected: navItem == 2,
                ),
              if (!hideAdminFeatures) const SizedBox(width: _spacingWidth),
              if (!hideAdminFeatures)
                _buildNavItem(
                  index: 3,
                  icon: Icons.map,
                  label: "Organize",
                  isSelected: navItem == 3,
                ),
              if (!hideAdminFeatures) const SizedBox(width: _spacingWidth),
              if (!hideAdminFeatures)
                _buildNavItem(
                  index: 5,
                  icon: Icons.star,
                  label: "Bookmarks",
                  isSelected: navItem == 5,
                ),
              if (isFullyLoaded && isSignedIn) const SizedBox(width: _spacingWidth),
              if (isFullyLoaded && isSignedIn)
                _buildNavItem(
                  index: 4,
                  icon: Icons.add_circle_outline,
                  label: "Contribute",
                  isSelected: navItem == 4,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
