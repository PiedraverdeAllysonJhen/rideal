import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'admin_requests_screen.dart';
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
import '../services/notification_service.dart';
import 'profile_screen.dart';
import 'home_admin.dart';
import 'vehicle_screen.dart';
import 'booking_screen.dart';

void main() {
  // Sample notifications - in real app, load from database/service
  final notificationService = NotificationService();

  notificationService.addNotification(
    NotificationItem(
      id: '1',
      title: 'Welcome to Rideal!',
      message: 'Start by booking your first vehicle',
      timestamp: DateTime.now(),
      type: 'promotion',
    ),
  );

  notificationService.addNotification(
    NotificationItem(
      id: '2',
      title: 'Payment Successful',
      message: 'Your payment of ₱2,400 for Honda Civic has been processed successfully.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      type: 'payment',
      data: {'vehicleName': 'Honda Civic', 'amount': 2400},
    ),
  );

  notificationService.addNotification(
    NotificationItem(
      id: '3',
      title: 'Booking Confirmed',
      message: 'Your booking for Toyota Vios from Jan 28-30 has been confirmed.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      type: 'booking',
      isRead: true,
      data: {'vehicleName': 'Toyota Vios', 'startDate': '2025-01-28', 'endDate': '2025-01-30'},
    ),
  );

  notificationService.addNotification(
    NotificationItem(
      id: '4',
      title: 'Pickup Reminder',
      message: 'Don\'t forget to pick up your Honda Civic tomorrow at 9:00 AM.',
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      type: 'reminder',
      data: {'vehicleName': 'Honda Civic', 'pickupTime': '9:00 AM'},
    ),
  );

  notificationService.addNotification(
    NotificationItem(
      id: '5',
      title: 'Special Offer',
      message: '20% off on weekend bookings! Valid until January 31st.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      type: 'promotion',
      isRead: true,
    ),
  );

  notificationService.addNotification(
    NotificationItem(
      id: '6',
      title: 'Return Reminder',
      message: 'Please return your rented Nissan Almera by 6:00 PM today.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      type: 'reminder',
      data: {'vehicleName': 'Nissan Almera', 'returnTime': '6:00 PM'},
    ),
  );

  runApp(MyApp());
}

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
  Vehicle? _selectedVehicle;
  final RidealNotificationService _notificationService = RidealNotificationService();

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
  bool _showGetStarted = true;

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
    _notificationService.addListener(_onNotificationChanged);
  }

  @override
  void dispose() {
    _notificationService.removeListener(_onNotificationChanged);
    super.dispose();
  }

  void _onNotificationChanged() {
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
          return AdminRequestsScreen(
            themeMain: _themeMain,
            themeLite: _themeLite,
            themeGrey: _themeGrey,
          );
        case 2:
          return AdminPostScreen(
            themeMain: _themeMain,
            headlineFontSize: _headLine2,
          );
        case 3:
          return NotificationScreen(
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
          onRentNow: _handleRentNow,
          themeMain: _themeMain,
          themeLite: _themeLite,
          notificationService: _notificationService,
        );
      case 1:
        return BookingScreen(
          selectedVehicle: _selectedVehicle,
          themeMain: _themeMain,
          onBookingComplete: _handleBookingComplete,
          notificationService: _notificationService,
        );
      case 2:
        return VehicleScreen(
          vehicles: _vehicles,
          themeMain: _themeMain,
          onRentNow: _handleRentNow,
        );
      case 3:
        return NotificationScreen(
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
        return HomeClientScreen(
          vehicles: _vehicles,
          onRentNow: _handleRentNow,
          themeMain: _themeMain,
          themeLite: _themeLite,
        );
    }
  }

  void _handleRentNow(Vehicle vehicle) {
    setState(() {
      _selectedVehicle = vehicle;
      _selectedIndex = 1;
    });
    _buildHomePage();
  }

  void _handleBookingComplete() {
    setState(() {
      _selectedVehicle = null;
      _selectedIndex = 0;
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
        notificationCount: _notificationService.notifications.length,
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

  void _handleGetStarted() {
    setState(() {
      _showGetStarted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showGetStarted && !_isSignedIn) {
      return GetStartedScreen(onGetStarted: _handleGetStarted);
    }

    return Scaffold(
      body: _isLoading ? _loadingScreen : _currentScreen,
    );
  }
}

class GetStartedScreen extends StatelessWidget {
  final VoidCallback onGetStarted;

  const GetStartedScreen({super.key, required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    const themeMain = Color(0xFF1976D2);
    const themeGrey = Color(0xFF424242);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1884E1),
              Color(0xFFB0E0FF),
            ],
            stops: [0.15, 0.6],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/ride-hailing.png', height: 120),
                const SizedBox(height: 24),
                const Text(
                  'Welcome to Rideal',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    color: Colors.white,
                    letterSpacing: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Campus vehicle rental made simple, fast, and affordable',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 48),
                _buildFeatureCard(
                  icon: Icons.directions_car,
                  title: 'Browse Vehicles',
                  description: 'Discover a wide range of campus-friendly vehicles',
                ),
                const SizedBox(height: 20),
                _buildFeatureCard(
                  icon: Icons.calendar_today,
                  title: 'Easy Booking',
                  description: 'Reserve your vehicle in just a few taps',
                ),
                const SizedBox(height: 20),
                _buildFeatureCard(
                  icon: Icons.credit_card,
                  title: 'Secure Payments',
                  description: 'Safe and hassle-free payment options',
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF1565C0),
                          Color(0xFF1976D2),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: themeMain.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: onGetStarted,
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Already have an account?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
                TextButton(
                  onPressed: onGetStarted,
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1976D2).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF1976D2), size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1976D2),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}