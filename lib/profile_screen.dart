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
      body: SafeArea(
        child: Column(
          children: [
            PersonalIsland(
              netImgSm: _buildProfileImage(radius: 30),
              apiName: widget.fullName,
              themeLite: widget.themeLite,
              headLine3: 20,
              isSignedIn: true,
              onAppSettingsTap: () => _showAppSettingsDialog(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildProfileItem(
                    icon: Icons.person,
                    title: 'Account Information',
                    onTap: () => _showAccountInfo(context),
                  ),
                  _buildProfileItem(
                    icon: Icons.settings,
                    title: 'App Settings',
                    onTap: () => _showAppSettingsDialog(context),
                  ),
                  _buildProfileItem(
                    icon: Icons.help,
                    title: 'Help & Support',
                    onTap: () => _showHelpSupport(context),
                  ),
                  _buildProfileItem(
                    icon: Icons.logout,
                    title: 'Sign Out',
                    onTap: widget.onSignOut,
                    isDestructive: true,
                  ),
                ],
              ),
            ),
          ],
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
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: isDestructive ? Colors.red : widget.themeMain),
        title: Text(title,
            style: TextStyle(color: isDestructive ? Colors.red : Colors.black87)),
        trailing: const Icon(Icons.chevron_right),
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
        title: const Text('Account Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.check_box_outline_blank, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.fullName,
                    style: const TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 36, top: 4),
              child: Text(
                widget.email,
                style: TextStyle(
                  fontSize: 14,
                  color: widget.themeGrey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHelpSupport(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Text('Contact our support team at:\ncherryblitz.dev0@gmail.com'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}