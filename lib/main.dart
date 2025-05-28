import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'notification_screen.dart';
import 'widgets/loading_screen.dart';
import 'widgets/personal_island.dart';
import 'widgets/app_settings_dialog.dart';
import 'widgets/custom_bottom_nav_bar.dart';
import 'authentication_screen.dart';
import 'widgets/admin_post_vehicle.dart';
import 'services/database.dart';
import 'models/account.dart';
import 'home_client.dart';
import 'models/vehicle.dart';
import 'services/vehicle_service.dart';
import 'profile_screen.dart';
import 'home_admin.dart';
import 'vehicle_screen.dart';
import 'booking_screen.dart';  // Add this import

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rideal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1976D2)),
        scaffoldBackgroundColor: const Color(0xFFF4F6F8),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const MyHomePage(title: 'Rideal - Campus Vehicle Rental'),
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
  List<Vehicle> _vehicles = [];
  Vehicle? _selectedVehicle;  // Track selected vehicle for booking
  final NotificationService _notificationService = NotificationService();

  static const Color _themeBG = Color(0xFFF4F6F8);
  static const Color _themeMain = Color(0xFF1976D2);
  static const Color _themeLite = Color(0xFFBBDEFB);
  static const Color _themeGrey = Color(0xFF424242);

  late bool _keepScreenOn;
  late bool _useLargeTexts;
  late double _extraLarge;
  late double _headLine2;
  late double _headLine3;
  late double _body;

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
    _initializeSettings();
    _initializeRequirements();
    // Listen to notification changes for UI updates
    _notificationService.addListener(_onNotificationChanged);
  }

  @override
  void dispose() {
    _notificationService.removeListener(_onNotificationChanged);
    super.dispose();
  }

  void _onNotificationChanged() {
    // Update UI when notifications change (for badge counts, etc.)
    if (mounted) setState(() {});
  }

  void _initializeSettings() {
    _keepScreenOn = false;
    _useLargeTexts = false;
    _extraLarge = 36.0;
    _headLine2 = 22.0;
    _headLine3 = 20.0;
    _body = 16.0;
  }

  Future<void> _loadVehicles() async {
    if (_isSignedIn) {
      _vehicles = await VehicleService.getFeaturedVehicles();
      if (mounted) setState(() {});
    }
  }

  void _handleNavItemSelected(int index) {
    setState(() => _selectedIndex = index);
    _buildHomePage();
  }

  Widget _getCurrentBody() {
    if (_isAdmin) {
      switch (_selectedIndex) {
        case 0:
          return HomeAdminScreen(
            vehicles: _vehicles,
            themeMain: _themeMain,
            themeLite: _themeLite,
          );
        case 1:
          return const Center(child: Text('User Management'));
        case 2:
          return AdminPostScreen(
            themeMain: _themeMain,
            headlineFontSize: _headLine2,
          );
        case 3:
          return const Center(child: Text('Analytics Dashboard'));
        case 4:
          return ProfileScreen(
            fullName: _fullName,
            email: _apiEmail,
            photoUrl: _apiPhotoUrl,
            themeMain: _themeMain,
            themeLite: _themeLite,
            themeGrey: _themeGrey,
            onSignOut: _handleSignOut,
            onKeepScreenOnChanged: _handleKeepScreenOnChanged,
            onUseLargeTextsChanged: _handleUseLargeTextsChanged,
            keepScreenOn: _keepScreenOn,
            useLargeTexts: _useLargeTexts,
          );
        default:
          return HomeAdminScreen(
            vehicles: _vehicles,
            themeMain: _themeMain,
            themeLite: _themeLite,
          );
      }
    }

    switch (_selectedIndex) {
      case 0:
        return HomeClientScreen(
          vehicles: _vehicles,
          onRentNow: _handleRentNow,  // Add rent now handler
        );
      case 1:
        return BookingScreen(
          selectedVehicle: _selectedVehicle,
          themeMain: _themeMain,
          onBookingComplete: _handleBookingComplete,

        );
      case 2:
        return VehicleScreen(vehicles: _vehicles, themeMain: _themeMain, onRentNow: _handleRentNow,);
      case 3:
        return NotificationScreen(  // Update notifications screen
          themeMain: _themeMain,
          themeLite: _themeLite,
          themeGrey: _themeGrey,
        );
      case 4:
        return ProfileScreen(
          fullName: _fullName,
          email: _apiEmail,
          photoUrl: _apiPhotoUrl,
          themeMain: _themeMain,
          themeLite: _themeLite,
          themeGrey: _themeGrey,
          onSignOut: _handleSignOut,
          onKeepScreenOnChanged: _handleKeepScreenOnChanged,
          onUseLargeTextsChanged: _handleUseLargeTextsChanged,
          keepScreenOn: _keepScreenOn,
          useLargeTexts: _useLargeTexts,
        );
      default:
        return HomeClientScreen(vehicles: _vehicles);
    }
  }

  void _handleRentNow(Vehicle vehicle) {
    setState(() {
      _selectedVehicle = vehicle;
      _selectedIndex = 1;  // Switch to bookings tab
    });
    _buildHomePage();
  }

  void _handleBookingComplete() {
    setState(() {
      _selectedVehicle = null;
      _selectedIndex = 0;  // Return to home after booking
    });
    _buildHomePage();
  }

  void _handleKeepScreenOnChanged(bool value) {
    setState(() => _keepScreenOn = value);
    WakelockPlus.toggle(enable: value);
  }

  void _handleUseLargeTextsChanged(bool value) {
    setState(() {
      _useLargeTexts = value;
      _rescaleFontSizes();
    });
  }

  void _handleAppSettingsTap() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
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
                setState(() => _keepScreenOn = newValue);
                WakelockPlus.toggle(enable: newValue);
                setStateDialog(() {});
              },
              onUseLargeTextsChanged: (newValue) {
                setState(() => _useLargeTexts = newValue);
                _rescaleFontSizes();
                setStateDialog(() {});
              },
              onSignOutTap: () {
                Navigator.of(context).pop();
                _handleSignOut();
              },
            );
          },
        );
      },
    );
  }

  void _handleSignOut() {
    DatabaseService().clearAccounts().then((_) {
      setState(() {
        _isSignedIn = false;
        _selectedIndex = 0;
        _vehicles = [];
        _selectedVehicle = null;
        _initializeSettings();
      });
      _buildHomePage();
    });
  }

  void _rescaleFontSizes() {
    setState(() {
      _extraLarge = _useLargeTexts ? 54.0 : 36.0;
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
        title: Text("Device Offline", style: TextStyle(fontSize: _headLine2)),
        content: Text("Please check your internet connection.",
            style: TextStyle(fontSize: _body)),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _isConnectionLost = true);
              Navigator.pop(context);
              _checkInternetConnection();
            },
            child: Text("Retry", style: TextStyle(fontSize: _body)),
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
      body: _getCurrentBody(),
      bottomNavigationBar: _isSignedIn
          ? CustomBottomNavBar(
        themeLite: _themeLite,
        themeDark: _themeMain,
        themeGrey: _themeGrey,
        navItem: _selectedIndex,
        isAdminMode: _isAdmin,
        isSignedIn: _isSignedIn,
        isFullyLoaded: !_isLoading,
        onItemSelected: _handleNavItemSelected,
      )
          : null,
    );
    _updateCurrentScreen();
  }

  void _updateCurrentScreen() {
    setState(() => _currentScreen = _isSignedIn ? _dashboardScreen : _signingScreen);
  }

  Future<void> _checkInternetConnection() async {
    setState(() => _isLoading = true);
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 15));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          _isOfflineMode = false;
          if (_isConnectionLost) {
            _isConnectionLost = false;
            _initializeRequirements();
          }
        });
      }
    } catch (_) {
      _showAppOfflineDialog();
      setState(() => _isOfflineMode = true);
    }
    setState(() => _isLoading = false);
  }

  Future<void> _checkSignedAccount() async {
    final accounts = await DatabaseService().getSignedAccount();
    if (accounts.isEmpty) {
      setState(() => _isSignedIn = false);
      return;
    }

    setState(() {
      _signedAccount = accounts.first;
      _fullName = _signedAccount.apiName ?? '';
      _apiEmail = _signedAccount.apiEmail ?? '';
      _apiPhotoUrl = _signedAccount.apiPhotoUrl ?? '';
      _isAdmin = (_signedAccount.userLevel ?? 0) >= 2;
      _isSignedIn = true;
    });

    await _loadVehicles();
    _buildHomePage();
  }

  Future<void> _initializeRequirements() async {
    await _checkInternetConnection();
    await _buildAuthenticationScreen();
    await _checkSignedAccount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading ? _loadingScreen : _currentScreen,
    );
  }
}