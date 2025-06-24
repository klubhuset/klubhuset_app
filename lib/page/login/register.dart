import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubhuset/component/button/full_width_button.dart';
import 'package:klubhuset/component/loading_indicator.dart';
import 'package:klubhuset/services/auth_service.dart';
import 'package:klubhuset/repository/authentication_repository.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await AuthenticationRepository.register(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text.trim(),
      2,
    );

    setState(() {
      _isLoading = false;
    });

    if (result['success']) {
      if (!mounted) return;

      final authService = Provider.of<AuthService>(context, listen: false);
      final loginSuccess = await authService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (loginSuccess) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } else {
      setState(() {
        _errorMessage =
            result['message'] ?? 'Registering mislykkedes. Prøv igen.';
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGrey6,
      child: SafeArea(
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
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'Opret bruger',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 30),

                // Navn
                _buildTextField(
                  controller: _nameController,
                  placeholder: 'Navn',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Indtast venligst dit navn';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Email
                _buildTextField(
                  controller: _emailController,
                  placeholder: 'E-mail',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Indtast venligst din email';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Indtast venligst en gyldig email';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Password
                _buildTextField(
                  controller: _passwordController,
                  placeholder: 'Adgangskode',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Indtast venligst en adgangskode';
                    }
                    if (value.length < 6) {
                      return 'Adgangskoden skal være mindst 6 tegn';
                    }
                    return null;
                  },
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
                        buttonText: 'Opret konto',
                        onPressed: _register,
                      ),

                const SizedBox(height: 20),

                FullWidthButton(
                  buttonText: 'Annullér',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  outlined: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String placeholder,
    required String? Function(String?) validator,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return FormField<String>(
      validator: validator,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CupertinoTextField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              placeholder: placeholder,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1.5),
                borderRadius: BorderRadius.circular(5),
              ),
              onChanged: (value) {
                state.didChange(value);
              },
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 8),
                child: Text(
                  state.errorText!,
                  style: const TextStyle(
                    color: CupertinoColors.systemRed,
                    fontSize: 13,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
