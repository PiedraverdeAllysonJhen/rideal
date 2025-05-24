import 'package:flutter/material.dart';

class PersonalIsland extends StatelessWidget {
  final Widget? netImgSm;
  final String? apiName;
  final Color themeLite;
  final double headLine3;
  final bool isSignedIn;
  final VoidCallback? onAppSettingsTap;

  const PersonalIsland({
  super.key,
  this.netImgSm,
  this.apiName,
  required this.themeLite,
  required this.headLine3,
  required this.isSignedIn,
  this.onAppSettingsTap,
  });

  static const double _islandTopPadding = 64.0;
  static const double _islandHorizontalPadding = 16.0;
  static const double _containerPadding = 8.0;
  static const double _borderRadius = 30.0;
  static const double _smallSpacing = 4.0;
  static const double _mediumSpacing = 8.0;

  @override
  Widget build(BuildContext context) {
    if (!isSignedIn) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: _islandTopPadding,
      left: _islandHorizontalPadding,
      right: _islandHorizontalPadding,
      child: GestureDetector(
        onTap: () async {
          onAppSettingsTap?.call();
        },
        child: Container(
          padding: const EdgeInsets.all(_containerPadding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(_borderRadius),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(width: _smallSpacing),
                  netImgSm ?? const SizedBox.shrink(),
                  const SizedBox(width: _mediumSpacing),
                  Text(
                    apiName ?? '',
                    style: TextStyle(
                      fontSize: headLine3,
                      color: Colors.black,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}