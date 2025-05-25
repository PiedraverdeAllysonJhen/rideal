import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

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
  final _themeBG = const Color(0xfffff5f5);
  final _themeMain = const Color(0xffd32f2f);
  final _themeLite = const Color(0xffffcdd2);
  final _bhServer = 'https://bleedingheart-api.vercel.app';

  late final double _extraLarge = 36.0;
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
      if (accessToken.isNotEmpty) username = tempUsername;
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
    final accountUuid = uuid.v5(
        Namespace.oid.value, 'account_${username}_$timestamp');

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

  Widget _buildSignInFields() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            hintText: 'Username',
            filled: true,
            fillColor: Colors.white,
            labelStyle: TextStyle(fontSize: _body),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Password',
            filled: true,
            fillColor: Colors.white,
            labelStyle: TextStyle(fontSize: _body),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: _themeLite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
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
            child: const Text('Sign in'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? LoadingScreen(size: 80.0, color: _themeMain)
        : Scaffold(
      backgroundColor: _themeBG,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/ride-hailing.png',
                height: 80.0,
              ),
              const SizedBox(height: 8.0),
              Text(
                'Rideal',
                style: TextStyle(
                  fontSize: _extraLarge,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'CherrySwash',
                  color: _themeMain,
                ),
              ),
              const SizedBox(height: 24),
              if (!_isPaused) _buildSignInFields(),
            ],
          ),
        ),
      ),
    );
  }
}
