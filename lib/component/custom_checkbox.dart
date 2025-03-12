import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        if (onChanged != null) {
          onChanged!(!value);
        }
      },
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: CupertinoColors.systemGrey,
            width: 2,
          ),
          color: value ? CupertinoColors.activeBlue : CupertinoColors.white,
        ),
        child: value
            ? Icon(
                CupertinoIcons.check_mark,
                color: CupertinoColors.white,
                size: 14,
              )
            : null,
      ),
    );
  }
}
