import 'package:flutter/cupertino.dart';

class FullWidthButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final bool outlined;

  const FullWidthButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        decoration: BoxDecoration(
          color: outlined
              ? CupertinoColors.transparent
              : CupertinoColors.systemIndigo,
          borderRadius: BorderRadius.circular(50.0),
          border: outlined
              ? Border.all(color: CupertinoColors.systemIndigo, width: 2.0)
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          buttonText,
          style: TextStyle(
            color:
                outlined ? CupertinoColors.systemIndigo : CupertinoColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
