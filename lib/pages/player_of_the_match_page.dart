import 'package:flutter/cupertino.dart';

class PlayerOfTheMatchPage extends StatelessWidget {
  // @override
  // Widget build(BuildContext context) {
  //   return CupertinoPageScaffold(
  //     navigationBar: const CupertinoNavigationBar(
  //       middle: Text('Kampens spiller'),
  //     ),
  //     child: Center(
  //       child: const Text('Vælg kampens spiller'),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Kampens spiller'),
        ),
        child: Column(children: <Widget>[
          // Input the name of the match
          Container(
            child: SafeArea(
              child: Form(
                autovalidateMode: AutovalidateMode.always,
                onChanged: () {
                  Form.maybeOf(primaryFocus!.context!)?.save();
                },
                child: CupertinoTextFormFieldRow(
                  prefix: const Text('Indtast navn på kamp'),
                  placeholder: 'Navn på kampen',
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Indtast et navn på kampen';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),

          // Vote on the player of the match
          Container(
            child: CupertinoListSection.insetGrouped(
              header: const Text('Stem på kampens spiller'),
              children: <CupertinoListTile>[
                CupertinoListTile.notched(
                  title: const Text('Anders H. Brandt'),
                  trailing: const CupertinoListTileChevron(),
                ),
              ],
            ),
          )
        ]));
  }
}

/**
 
CupertinoListSection.insetGrouped(
        header: const Text('Stem på kampens spiller'),
        children: <CupertinoListTile>[
          CupertinoListTile.notched(
            title: const Text('Anders H. Brandt'),
            trailing: const CupertinoListTileChevron(),
          ),
        ],
      ),

 * 
 * 
 * 
 */
