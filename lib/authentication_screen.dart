import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

import 'widgets/loading_screen.dart';
import '../services/database.dart';
import '../models/account.dart';

class AuthenticationScreen extends StatefulWidget {
  final VoidCallback? onSignedIn;

  const AuthenticationScreen({super.key, this.onSignedIn});

  @override
  AuthenticationScreenState createState() => AuthenticationScreenState();
}

class AuthenticationScreenState extends State<AuthenticationScreen> {
  final uuid = const Uuid();
  final globalDelay = 500;
  final _themeMain = const Color(0xFF1976D2);
  final _themeGrey = const Color(0xFF424242);
  final _bhServer = 'https://cherryblitz-api.vercel.app';

  late final double _body = 16.0;

  int lastLoginClicked = 0;
  bool isSignedIn = false;
  bool _isLoading = false;
  int _retries = 0;
  bool _isPaused = false;

  String accessToken = '';
  int userLevel = -1;
  String fullName = '';
  String username = '';
  String photoUrl = '';
  String apiPhotoUrl = 'https://api.dicebear.com/9.x/open-peeps/svg?seed=Alexander';
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _launchPrivacyPolicy() async {
    const url = 'https://devjeyem.github.io/privacy-policy.html';

    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (!launched) {
          _showToast("Could not open privacy policy");
        }
      } else {
        _showToast("No browser available to open privacy policy");
      }
    } on PlatformException catch (e) {
      _showToast("Error opening privacy policy: ${e.message ?? 'Unknown error'}");
    } catch (e) {
      _showToast("Unable to open privacy policy");
    }
  }

  Future<void> authorizeEmail(String tempUsername, String tempPassword) async {
    if (lastLoginClicked >= DateTime.now().millisecondsSinceEpoch - globalDelay) return;

    setState(() {
      userLevel = -1;
      _isLoading = true;
      lastLoginClicked = DateTime.now().millisecondsSinceEpoch;
    });

    try {
      final response = await http.post(
        Uri.parse('$_bhServer/authorize'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': tempUsername, 'password': tempPassword}),
      );

      final data = jsonDecode(response.body);
      accessToken = data['accessToken'] as String? ?? '';
      userLevel = data['userLevel'] as int? ?? -1;
      fullName = data['fullName'] as String? ?? '';
      photoUrl = data['photoUrl'] as String? ?? apiPhotoUrl;

      if (photoUrl.isEmpty) photoUrl = apiPhotoUrl;
      if (accessToken.isEmpty) {
        _showToast("Incorrect username or password.");
        setState(() {
          _isLoading = false;
          _retries++;
        });
        if (_retries >= 3) {
          _showToast("Too many attempts, please try again later.");
          setState(() => _isPaused = true);
        }
        return;
      }
    } catch (_) {
      _showToast("We are unable to process your request, try again later.");
      setState(() {
        _retries++;
        _isLoading = false;
      });
      return;
    }

    final timestamp = DateTime.now().toIso8601String();
    final accountUuid = uuid.v5(Namespace.oid.value, 'account_${username}_$timestamp');

    final account = Account(
      uuid: accountUuid,
      apiId: accessToken,
      userLevel: userLevel,
      apiName: fullName,
      apiEmail: '$username@loqo.com',
      apiPhotoUrl: photoUrl,
      isSignedIn: 1,
      isPublic: 1,
      isContributorMode: 0,
      isRestricted: 0,
      isSynchronized: 0,
      ttl: DateTime.now().add(const Duration(days: 7)).toIso8601String(),
      createdAt: timestamp,
    );

    await DatabaseService().insertAccount(account);
    _showToast("Welcome back $username!");
    isSignedIn = true;
    setState(() {
      _retries = 0;
      _isLoading = false;
    });
    widget.onSignedIn?.call();
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? LoadingScreen(size: 80.0, color: _themeMain)
        : Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1884E1),  // Light blue
              Color(0xFFB0E0FF),  // Light blue

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
                Image.asset('assets/images/ride-hailing.png', height: 80),
                const SizedBox(height: 16),
                const Text(
                  'Rideal',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'CherrySwash',
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Sign In to Continue',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: _themeGrey,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildSignInFields(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInFields() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            labelText: 'Username',
            labelStyle: TextStyle(fontSize: _body, color: _themeGrey),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _themeMain, width: 2),
            ),
            prefixIcon: Icon(Icons.person, color: _themeMain),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            labelStyle: TextStyle(fontSize: _body, color: _themeGrey),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _themeMain, width: 2),
            ),
            prefixIcon: Icon(Icons.lock, color: _themeMain),
          ),
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          height: 48,
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
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: _themeMain.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _retries >= 3
                  ? null
                  : () async {
                final username = _usernameController.text.trim();
                final password = _passwordController.text.trim();
                await authorizeEmail(username, password);
                _usernameController.clear();
                _passwordController.clear();
              },
              child: const Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: _launchPrivacyPolicy,
          child: Text(
            'Privacy Policy',
            style: TextStyle(
              fontSize: 14,
              color: _themeMain,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}