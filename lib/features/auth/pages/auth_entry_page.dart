import 'package:flutter/material.dart';
import 'register_page.dart';
import 'login_page.dart';

class AuthEntryPage extends StatefulWidget {
  final VoidCallback? onLoginSuccess;

  const AuthEntryPage({super.key, this.onLoginSuccess});

  @override
  State<AuthEntryPage> createState() => _AuthEntryPageState();
}

class _AuthEntryPageState extends State<AuthEntryPage> {
  bool _showLogin = false;

  void _goToLogin() {
    setState(() => _showLogin = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _showLogin
            ? LoginPage(onLoginSuccess: widget.onLoginSuccess)
            : RegisterPage(
                onNavigateToLogin: _goToLogin,
                onLoginSuccess: widget.onLoginSuccess,
              ),
      ),
    );
  }
}
