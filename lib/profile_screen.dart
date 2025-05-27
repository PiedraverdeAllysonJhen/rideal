import 'package:flutter/material.dart';
import '../widgets/personal_island.dart';
import '../widgets/app_settings_dialog.dart';

class ProfileScreen extends StatefulWidget {
  final String fullName;
  final String email;
  final String photoUrl;
  final Color themeMain;
  final Color themeLite;
  final Color themeGrey;
  final VoidCallback onSignOut;
  final ValueChanged<bool> onKeepScreenOnChanged;
  final ValueChanged<bool> onUseLargeTextsChanged;
  final bool keepScreenOn;
  final bool useLargeTexts;

  const ProfileScreen({
    super.key,
    required this.fullName,
    required this.email,
    required this.photoUrl,
    required this.themeMain,
    required this.themeLite,
    required this.themeGrey,
    required this.onSignOut,
    required this.onKeepScreenOnChanged,
    required this.onUseLargeTextsChanged,
    required this.keepScreenOn,
    required this.useLargeTexts,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late bool _currentKeepScreenOn;
  late bool _currentUseLargeTexts;

  @override
  void initState() {
    super.initState();
    _currentKeepScreenOn = widget.keepScreenOn;
    _currentUseLargeTexts = widget.useLargeTexts;
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.keepScreenOn != oldWidget.keepScreenOn) {
      _currentKeepScreenOn = widget.keepScreenOn;
    }
    if (widget.useLargeTexts != oldWidget.useLargeTexts) {
      _currentUseLargeTexts = widget.useLargeTexts;
    }
  }

  void _updateKeepScreenOn(bool value) {
    setState(() => _currentKeepScreenOn = value);
    widget.onKeepScreenOnChanged(value);
  }

  void _updateUseLargeTexts(bool value) {
    setState(() => _currentUseLargeTexts = value);
    widget.onUseLargeTextsChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFBBDEFB),  // Light blue
              Colors.white,
            ],
            stops: [0.0, 0.6],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Profile Header with Personal Island
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: PersonalIsland(
                  netImgSm: _buildProfileImage(radius: 36),
                  apiName: widget.fullName,
                  themeLite: widget.themeLite,
                  headLine3: 24,
                  isSignedIn: true,
                  onAppSettingsTap: () => _showAppSettingsDialog(context),
                  islandPadding: const EdgeInsets.all(16),
                  namePadding: const EdgeInsets.only(left: 16),
                ),
              ),

              // Menu Items List
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    const SizedBox(height: 16),
                    _buildProfileItem(
                      icon: Icons.person_outline,
                      title: 'Account Information',
                      onTap: () => _showAccountInfo(context),
                    ),
                    _buildProfileItem(
                      icon: Icons.settings_outlined,
                      title: 'App Settings',
                      onTap: () => _showAppSettingsDialog(context),
                    ),
                    _buildProfileItem(
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      onTap: () => _showHelpSupport(context),
                    ),
                    _buildProfileItem(
                      icon: Icons.logout,
                      title: 'Sign Out',
                      onTap: widget.onSignOut,
                      isDestructive: true,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? Colors.red : widget.themeMain,
          size: 28,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDestructive ? Colors.red : Colors.black87,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: isDestructive ? Colors.red : widget.themeGrey,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildProfileImage({required double radius}) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white,
      child: widget.photoUrl.isEmpty
          ? Icon(Icons.person, size: radius, color: widget.themeMain)
          : ClipOval(
        child: Image.network(
          widget.photoUrl,
          fit: BoxFit.cover,
          width: radius * 2,
          height: radius * 2,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.error, color: widget.themeMain);
          },
        ),
      ),
    );
  }

  void _showAppSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AppSettingsDialog(
            netImgLg: _buildProfileImage(radius: 60),
            apiName: widget.fullName,
            apiEmail: widget.email,
            headLine2: 22,
            body: 16,
            themeBG: Colors.white,
            themeGrey: widget.themeGrey,
            themeMain: widget.themeMain,
            themeLite: widget.themeLite,
            keepScreenOn: _currentKeepScreenOn,
            useLargeTexts: _currentUseLargeTexts,
            onKeepScreenOnChanged: (value) {
              _updateKeepScreenOn(value);
              setStateDialog(() {});
            },
            onUseLargeTextsChanged: (value) {
              _updateUseLargeTexts(value);
              setStateDialog(() {});
            },
            onSignOutTap: widget.onSignOut,
          );
        },
      ),
    );
  }

  void _showAccountInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Account Information',
          style: TextStyle(color: widget.themeMain),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildProfileImage(radius: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.fullName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.email,
                        style: TextStyle(
                          fontSize: 14,
                          color: widget.themeGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(color: widget.themeMain),
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpSupport(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Help & Support',
          style: TextStyle(color: widget.themeMain),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Need assistance? Contact our support team:'),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.email, color: widget.themeMain, size: 20),
                const SizedBox(width: 12),
                Text(
                  'cherryblitz.dev0@gmail.com',
                  style: TextStyle(
                    color: widget.themeMain,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(color: widget.themeMain),
            ),
          ),
        ],
      ),
    );
  }
}