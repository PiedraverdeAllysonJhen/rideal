// main.dart
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'widgets/loading_screen.dart';
import 'widgets/personal_island.dart';
import 'widgets/app_settings_dialog.dart';
import 'widgets/custom_bottom_nav_bar.dart';
import 'authentication_screen.dart';

import '../services/database.dart';
import '../models/account.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rideal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF1976D2)),
        scaffoldBackgroundColor: const Color(0xFFF4F6F8),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const MyHomePage(title: 'A fast and efficient on-campus vehicle rental app for students and staffs.'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final uuid = const Uuid();

  static const Color _themeBG = Color(0xFFF4F6F8);
  static const Color _themeMain = Color(0xFF1976D2);
  static const Color _themeLite = Color(0xFFBBDEFB);
  static const Color _themeGrey = Color(0xFF424242);

  late bool _keepScreenOn = false;
  late bool _useLargeTexts = false;
  late double _extraLarge = 36.0;
  late double _headLine2 = 22.0;
  late double _headLine3 = 20.0;
  late double _body = 16.0;

  bool _isLoading = true;
  bool _isOfflineMode = true;
  bool _isConnectionLost = false;
  bool _isSignedIn = false;
  bool _isAdmin = false;
  int _selectedIndex = 0;
  late Widget _signingScreen;
  late Widget _loadingScreen = const SizedBox();
  late Widget _dashboardScreen = Container();
  late Widget _currentScreen;

  late Account _signedAccount;
  Widget _netImgSm = const SizedBox(width: 15.0);
  Widget _netImgLg = const SizedBox(width: 30.0);
  String _apiPhotoUrl = '';
  String _apiEmail = '';
  String _fullName = '';

  @override
  void initState() {
    super.initState();
    _initializeRequirements();
  }

  void _handleNavItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _buildHomePage();
  }

  void _handleAppSettingsTap() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AppSettingsDialog(
          netImgLg: _netImgLg,
          apiName: _fullName,
          apiEmail: _apiEmail,
          headLine2: _headLine2,
          body: _body,
          themeBG: _themeBG,
          themeGrey: _themeGrey,
          themeMain: _themeMain,
          themeLite: _themeLite,
          keepScreenOn: _keepScreenOn,
          useLargeTexts: _useLargeTexts,
          onKeepScreenOnChanged: (newValue) {
            setState(() {
              _keepScreenOn = newValue;
            });
            WakelockPlus.toggle(enable: _keepScreenOn);
            Navigator.of(context).pop();
            _handleAppSettingsTap();
            _buildHomePage();
          },
          onUseLargeTextsChanged: (newValue) {
            setState(() {
              _useLargeTexts = newValue;
            });
            _rescaleFontSizes();
            Navigator.of(context).pop();
            _handleAppSettingsTap();
            _buildHomePage();
          },
          onSignOutTap: () {
            Navigator.of(context).pop();
            DatabaseService().clearAccounts().then((_) {
              setState(() {
                _isSignedIn = false;
                _selectedIndex = 0;
              });
              _buildHomePage();
            });
          },
        );
      },
    );
  }

  Future<void> _rescaleFontSizes() async {
    setState(() {
      _extraLarge = _useLargeTexts ? 54.0 : 32.0;
      _headLine2 = _useLargeTexts ? 34.0 : 22.0;
      _headLine3 = _useLargeTexts ? 24.0 : 20.0;
      _body = _useLargeTexts ? 20.0 : 16.0;
    });
  }

  Widget _buildProfileImage({required double radius}) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white,
      child: _apiPhotoUrl.isEmpty
          ? const Icon(Icons.person, color: Colors.blueAccent)
          : ClipOval(
        child: Image.network(
          _apiPhotoUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error_outline, color: Colors.red);
          },
        ),
      ),
    );
  }

  Future<void> _loadNetImg() async {
    if (!_isOfflineMode && _isSignedIn) {
      try {
        final netImgSm = _buildProfileImage(radius: 15);
        final netImgLg = _buildProfileImage(radius: 30);

        setState(() {
          _netImgSm = netImgSm;
          _netImgLg = netImgLg;
        });
      } catch (_) {
        setState(() {
          _netImgSm = const SizedBox(width: 15.0);
          _netImgLg = const SizedBox(width: 30.0);
        });
      }
    } else {
      setState(() {
        _netImgSm = const SizedBox(width: 15.0);
        _netImgLg = const SizedBox(width: 30.0);
      });
    }
  }

  Future<void> _showAppOfflineDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Device is Offline", style: TextStyle(fontSize: _headLine2)),
        content: Text("Please check your internet connection.", style: TextStyle(fontSize: _body)),
        actions: [
          TextButton(
            onPressed: () async {
              setState(() => _isConnectionLost = true);
              Navigator.of(context).pop();
              _checkInternetConnection();
            },
            child: Text("Retry", style: TextStyle(fontSize: _body, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _buildAuthenticationScreen() async {
    _loadingScreen = LoadingScreen(size: 80.0, color: _themeMain);
    _signingScreen = AuthenticationScreen(
      onSignedIn: () {
        setState(() => _isSignedIn = true);
        _checkSignedAccount();
        _loadNetImg();
      },
    );
    _updateCurrentScreen();
  }

  Future<void> _buildHomePage() async {
    WakelockPlus.toggle(enable: _keepScreenOn);

    _dashboardScreen = Scaffold(
      body: Stack(
        children: [
          PersonalIsland(
            netImgSm: _netImgSm,
            apiName: _fullName,
            themeLite: _themeLite,
            headLine3: _headLine3,
            isSignedIn: _isSignedIn,
            onAppSettingsTap: _handleAppSettingsTap,
          ),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Rideal',
                  style: TextStyle(
                    fontSize: _extraLarge,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'CherrySwash',
                    color: _themeMain,
                  ),
                ),
                const SizedBox(width: 12.0),
                Text('v1.0', style: TextStyle(fontSize: _body, color: _themeGrey)),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        themeLite: _themeLite,
        themeDark: _themeMain,
        themeGrey: _themeGrey,
        navItem: _selectedIndex,
        isAdminMode: _isAdmin,
        isSignedIn: _isSignedIn,
        isFullyLoaded: !_isLoading,
        onItemSelected: _handleNavItemSelected,
      ),
    );
    _updateCurrentScreen();
  }

  void _updateCurrentScreen() {
    setState(() => _currentScreen = _isSignedIn ? _dashboardScreen : _signingScreen);
  }

  Future<void> _checkInternetConnection() async {
    setState(() => _isLoading = true);

    bool connected = false;
    try {
      final result = await InternetAddress.lookup('google.com').timeout(const Duration(seconds: 15));
      connected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;

      if (_isConnectionLost) {
        setState(() => _isConnectionLost = false);
        _initializeRequirements();
      }
    } catch (_) {
      _showAppOfflineDialog();
    }

    setState(() {
      _isOfflineMode = !connected;
      _isLoading = false;
    });
  }

  Future<void> _checkSignedAccount() async {
    final accounts = await DatabaseService().getSignedAccount();

    if (accounts.isEmpty) {
      setState(() => _isSignedIn = false);
      _buildHomePage();
      return;
    }

    setState(() {
      _signedAccount = accounts.first;
      _fullName = _signedAccount.apiName!;
      _apiEmail = _signedAccount.apiEmail!;
      _apiPhotoUrl = _signedAccount.apiPhotoUrl!;
      _isAdmin = (_signedAccount.userLevel! >= 2);
      _isSignedIn = true;
    });

    _buildHomePage();
  }

  Future<void> _initializeRequirements() async {
    await _checkInternetConnection();
    await _buildAuthenticationScreen();
    await _checkSignedAccount();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? _loadingScreen : _currentScreen;
  }
}
