import 'package:flutter/cupertino.dart';
import 'package:klubhuset/component/button/button.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: double.infinity,
        child: CupertinoPageScaffold(
          backgroundColor: CupertinoColors.systemGrey6,
          child: SafeArea(
            child: Center(
              child: Form(
                child: Column(
                  children: [
                    CupertinoTextFormFieldRow(
                      placeholder: 'E-mail',
                      padding: const EdgeInsets.all(16),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                      controller: _emailController,
                    ),
                    const SizedBox(height: 16),
                    CupertinoTextFormFieldRow(
                      placeholder: 'Password',
                      padding: const EdgeInsets.all(16),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      controller: _passwordController,
                    ),
                    const SizedBox(height: 16),
                    Button(
                        buttonText: 'Login',
                        onPressed: () {
                          // Handle login logic here
                        }),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
