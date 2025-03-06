import 'package:flutter/cupertino.dart';

class Button extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const Button({super.key, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: CupertinoColors.systemIndigo,
          borderRadius: BorderRadius.circular(50.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
        child: Text(
          buttonText,
          style: TextStyle(
              color: CupertinoColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
      ),
    );
  }
}
