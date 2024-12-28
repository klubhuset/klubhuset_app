import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:klubhuset/state/player_votes_state.dart';
import 'package:klubhuset/tab/home_tab.dart';
import 'package:klubhuset/tab/profile_tab.dart';
import 'package:provider/provider.dart';

String _appTitle = 'Klubhuset';

// TODO 2 (CVHN): Add caching to the app

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PlayerVotesState()),
      ],
      child: const KlubhusetApp(),
    ),
  );
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
          scaffoldBackgroundColor: CupertinoColors.systemBackground),
      home: const MainPage(),
    );
  }
}

// Home page class
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.profile_circled),
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  leading: Text('Boldklubben',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                child: HomeTab(),
              );
            });

          case 1:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: ProfileTab(),
              );
            });
        }

        return Container();
      },
    );
  }
}
