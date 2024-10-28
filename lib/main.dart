import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:klubhuset/tabs/home_tab.dart';
import 'styles.dart';

String _appTitle = 'Klubhuset';

void main() {
  runApp(const KlubhusetApp());
}

class KlubhusetApp extends StatelessWidget {
  const KlubhusetApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // This app is designed only to work vertically, so we limit
    // orientations to portrait up and down.
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return CupertinoApp(
      title: _appTitle,
      theme: CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: CupertinoColors.systemIndigo,
      ),
      home: const MainPage(),
    );
  }
}

// Home page class
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  // @override
  // Widget build(BuildContext context) {
  //   return CupertinoPageScaffold(
  //     navigationBar: CupertinoNavigationBar(
  //       leading: Text(_appTitle,
  //           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
  //     ),
  //     child: Container(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Hjem',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.profile_circled),
            label: 'Profil',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  leading: Text('Hjem',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                child: HomeTab(),
              );
            });

          case 1:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  leading: Text('Profil',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                child: Container(),
              );
            });
        }

        return Container();
      },
    );
  }
}
