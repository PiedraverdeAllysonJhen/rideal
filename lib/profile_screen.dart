import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../widgets/personal_island.dart';
import '../widgets/app_settings_dialog.dart';
import '../widgets/loading_screen.dart';

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
  bool _isSigningOut = false;

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
      setState(() {
        _currentKeepScreenOn = widget.keepScreenOn;
      });
    }
    if (widget.useLargeTexts != oldWidget.useLargeTexts) {
      setState(() {
        _currentUseLargeTexts = widget.useLargeTexts;
      });
    }
  }

  void _updateKeepScreenOn(bool value) async {
    setState(() {
      _currentKeepScreenOn = value;
    });

    // Proper implementation using wakelock_plus
    try {
      if (value) {
        await WakelockPlus.enable();
        print('Keep screen on: ENABLED - Screen will stay awake');
      } else {
        await WakelockPlus.disable();
        print('Keep screen on: DISABLED - Screen can sleep normally');
      }
    } catch (e) {
      print('Error setting wakelock: $e');
    }

    widget.onKeepScreenOnChanged(value);
  }

  void _updateUseLargeTexts(bool value) {
    setState(() {
      _currentUseLargeTexts = value;
    });

    print('Large texts: ${value ? "ENABLED" : "DISABLED"}');
    // The large text functionality should be handled by the parent widget/app
    widget.onUseLargeTextsChanged(value);
  }

  Future<void> _handleSignOut() async {
    setState(() => _isSigningOut = true);
    await Future.delayed(const Duration(milliseconds: 500));
    widget.onSignOut();
    if (mounted) setState(() => _isSigningOut = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isSigningOut) {
      return LoadingScreen(size: 80.0, color: widget.themeMain);
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFBBDEFB), Colors.white],
            stops: [0.0, 0.6],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
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
                      onTap: _handleSignOut,
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
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: ListTile(
        leading: Icon(icon, color: isDestructive ? Colors.red : widget.themeMain, size: 28),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDestructive ? Colors.red : Colors.black87,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: isDestructive ? Colors.red : widget.themeGrey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.person, size: radius, color: widget.themeMain),
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
            // Fixed: Reduced profile image size from radius 60 to 40
            netImgLg: _buildProfileImage(radius: 40),
            apiName: widget.fullName,
            apiEmail: widget.email,
            headLine2: 22,
            body: 16,
            themeBG: Colors.white,
            themeGrey: widget.themeGrey,
            themeMain: widget.themeMain,
            themeLite: widget.themeLite,
            // Fixed: Use current state values instead of widget values
            keepScreenOn: _currentKeepScreenOn,
            useLargeTexts: _currentUseLargeTexts,
            onKeepScreenOnChanged: (value) {
              // Fixed: Update both local state and parent state
              _updateKeepScreenOn(value);
              setStateDialog(() {}); // Update dialog UI immediately
            },
            onUseLargeTextsChanged: (value) {
              // Fixed: Update both local state and parent state
              _updateUseLargeTexts(value);
              setStateDialog(() {}); // Update dialog UI immediately
            },
            onSignOutTap: _handleSignOut,
          );
        },
      ),
    );
  }

  void _showAccountInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Account Information', style: TextStyle(color: widget.themeMain)),
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
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.visible,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.email,
                        style: TextStyle(fontSize: 14, color: widget.themeGrey),
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
            child: Text('Close', style: TextStyle(color: widget.themeMain)),
          ),
        ],
      ),
    );
  }

  void _showHelpSupport(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Help & Support', style: TextStyle(color: widget.themeMain)),
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
                  style: TextStyle(color: widget.themeMain, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: widget.themeMain)),
          ),
        ],
      ),
    );
  }
}