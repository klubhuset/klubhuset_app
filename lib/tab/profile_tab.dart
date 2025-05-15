import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubhuset/component/button/full_width_button.dart';
import 'package:klubhuset/component/loading_indicator.dart';
import 'package:klubhuset/main.dart';
import 'package:klubhuset/services/auth_service.dart';
import 'package:provider/provider.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Future<void> _logout() async {
      final authService = Provider.of<AuthService>(context, listen: false);
      final success = await authService.logout();

      setState(() {
        _isLoading = false;
      });

      if (success) {
        Navigator.of(context, rootNavigator: true)
            .pushReplacementNamed(AppRoutes.login);
      } else {
        setState(() {
          _errorMessage = 'Brugeren kunne ikke logges ud.';
        });
      }
    }

    return SizedBox(
        height: double.infinity,
        child: CupertinoPageScaffold(
            backgroundColor: CupertinoColors.systemGrey6,
            child: SafeArea(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(30, 50, 30, 30),
                    child: Column(children: <Widget>[
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                                color: theme.colorScheme.error, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      _isLoading
                          ? const LoadingIndicator()
                          : FullWidthButton(
                              buttonText: 'Log ud',
                              onPressed: _logout,
                            ),
                    ])))));
  }
}
