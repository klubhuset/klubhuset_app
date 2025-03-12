import 'package:flutter/cupertino.dart';

class Button extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final bool outlined;

  const Button(
      {super.key,
      required this.buttonText,
      required this.onPressed,
      this.outlined = false});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color:
              outlined ? CupertinoColors.white : CupertinoColors.systemIndigo,
          borderRadius: BorderRadius.circular(50.0),
          border: outlined
              ? Border.all(color: CupertinoColors.systemIndigo, width: 2.0)
              : null,
        ),
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
        child: Text(
          buttonText,
          style: TextStyle(
              color: outlined
                  ? CupertinoColors.systemIndigo
                  : CupertinoColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
      ),
    );
  }
}
