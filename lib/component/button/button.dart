import 'package:flutter/cupertino.dart';

class Button extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final bool outlined;
  final bool enabled;
  final IconData? icon;

  const Button({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.outlined = false,
    this.enabled = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor = outlined
        ? CupertinoColors.white
        : (enabled
            ? CupertinoColors.systemIndigo
            : CupertinoColors.systemGrey4);

    final Color borderColor = outlined
        ? (enabled ? CupertinoColors.systemIndigo : CupertinoColors.systemGrey)
        : CupertinoColors.transparent;

    final Color textColor = outlined
        ? (enabled ? CupertinoColors.systemIndigo : CupertinoColors.systemGrey)
        : (enabled ? CupertinoColors.white : CupertinoColors.black);

    return Semantics(
      button: true,
      enabled: enabled,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: enabled ? onPressed : null,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: enabled ? 1.0 : 0.5,
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(50.0),
              border:
                  outlined ? Border.all(color: borderColor, width: 2.0) : null,
            ),
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: textColor,
                    size: 20,
                  ),
                  const SizedBox(width: 5),
                ],
                Text(
                  buttonText,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
