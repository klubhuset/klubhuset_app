import 'package:flutter/cupertino.dart';

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
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: CupertinoColors.black,
            width: 2,
          ),
          color: value == true ? CupertinoColors.black : CupertinoColors.white,
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

/*
                                                      Container(
                                                        width: 22,
                                                        height: 22,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                            color:
                                                                CupertinoColors
                                                                    .black,
                                                            width: 2,
                                                          ),
                                                          color: selectedPlayers[
                                                                          fine[
                                                                              'id']]![
                                                                      player
                                                                          .id] ==
                                                                  true
                                                              ? CupertinoColors
                                                                  .black
                                                              : CupertinoColors
                                                                  .white,
                                                        ),
                                                        child: selectedPlayers[fine[
                                                                        'id']]![
                                                                    player
                                                                        .id] ==
                                                                true
                                                            ? Icon(
                                                                CupertinoIcons
                                                                    .checkmark,
                                                                color:
                                                                    CupertinoColors
                                                                        .white,
                                                                size: 16)
                                                            : null,
                                                      ),
 */
