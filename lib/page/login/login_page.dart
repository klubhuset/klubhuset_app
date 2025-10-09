import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:klubhuset/component/button/full_width_button.dart';
import 'package:klubhuset/component/loading_indicator.dart';
import 'package:klubhuset/main.dart'; // for AppRoutes.register
import 'package:klubhuset/services/auth_service.dart';
import 'package:klubhuset/services/platform_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    if (_formKey.currentState?.validate() != true) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final authService = Provider.of<AuthService>(context, listen: false);
    final success = await authService.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      setState(() => _errorMessage = 'Invalid email or password.');
    }
  }

  String? _emailValidator(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Please enter your email';
    if (!v.contains('@') || !v.contains('.')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if ((value ?? '').isEmpty) return 'Please enter your password';
    return null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final useCupertino = PlatformService.isIOS;
    final theme = Theme.of(context);

    final content = SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(30, 50, 30, 30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.sports_soccer,
                size: 80,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Klubhuset',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall
                    ?.copyWith(color: theme.colorScheme.primary),
              ),
              const SizedBox(height: 40),
              Text(
                'Log ind',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 5),
              RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    color: useCupertino
                        ? CupertinoColors.label
                        : theme.colorScheme.onSurface,
                  ),
                  children: [
                    TextSpan(
                      text: 'eller ',
                      style: TextStyle(
                        color: useCupertino
                            ? CupertinoColors.systemGrey
                            : theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    TextSpan(
                      text: 'Tilmeld dig her',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, AppRoutes.register);
                        },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Email field
              useCupertino
                  ? _buildCupertinoField(
                      controller: _emailController,
                      placeholder: 'E-mail',
                      validator: _emailValidator,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [
                        AutofillHints.username,
                        AutofillHints.email
                      ],
                    )
                  : TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [
                        AutofillHints.username,
                        AutofillHints.email
                      ],
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        border: OutlineInputBorder(),
                      ),
                      validator: _emailValidator,
                    ),

              const SizedBox(height: 20),

              // Password field
              useCupertino
                  ? _buildCupertinoField(
                      controller: _passwordController,
                      placeholder: 'Adgangskode',
                      validator: _passwordValidator,
                      obscureText: true,
                      autofillHints: const [AutofillHints.password],
                      onSubmitted: (_) => _login(),
                    )
                  : TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      onFieldSubmitted: (_) => _login(),
                      decoration: const InputDecoration(
                        labelText: 'Adgangskode',
                        border: OutlineInputBorder(),
                      ),
                      validator: _passwordValidator,
                    ),

              const SizedBox(height: 30),

              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              _isLoading
                  ? const LoadingIndicator()
                  : FullWidthButton(
                      buttonText: 'Login',
                      onPressed: _login,
                    ),
            ],
          ),
        ),
      ),
    );

    // Wrap in platform-appropriate scaffold
    return useCupertino
        ? CupertinoPageScaffold(
            backgroundColor: CupertinoColors.systemGrey6,
            child: content,
          )
        : Scaffold(
            backgroundColor: theme.colorScheme.surface,
            body: content,
          );
  }

  /// Builds a reusable Cupertino text field with validation error display.
  Widget _buildCupertinoField({
    required TextEditingController controller,
    required String placeholder,
    String? Function(String?)? validator,
    bool obscureText = false,
    List<String>? autofillHints,
    TextInputType? keyboardType,
    void Function(String)? onSubmitted,
  }) {
    return FormField<String>(
      validator: validator,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CupertinoTextField(
              controller: controller,
              keyboardType: keyboardType,
              textInputAction:
                  obscureText ? TextInputAction.done : TextInputAction.next,
              obscureText: obscureText,
              autofillHints: autofillHints,
              onSubmitted: onSubmitted,
              placeholder: placeholder,
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
              decoration: BoxDecoration(
                border: Border.all(color: CupertinoColors.black, width: 1.5),
                borderRadius: BorderRadius.circular(5),
              ),
              onChanged: state.didChange,
            ),
            if (state.hasError) ...[
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  state.errorText!,
                  style: const TextStyle(
                    color: CupertinoColors.systemRed,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
