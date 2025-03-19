import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:klubhuset/state/player_votes_state.dart';
import 'package:klubhuset/tab/home_tab.dart';
import 'package:klubhuset/tab/profile_tab.dart';
import 'package:provider/provider.dart';

String _appTitle = 'Klubhuset';

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

  @override
  Widget build(BuildContext context) {
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

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  void _onTabTapped(int index) {
    if (_selectedIndex == index) {
      // Hvis brugeren trykker på den valgte fane, popper vi til root
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.profile_circled),
            label: 'Profile',
          ),
        ],
        onTap: _onTabTapped,
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          navigatorKey:
              _navigatorKeys[index], // Brug en unik navigator til hver tab
          builder: (context) {
            if (index == 0) {
              return CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  middle: Text('Boldklubben',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                child: HomeTab(),
              );
            } else {
              return CupertinoPageScaffold(
                child: ProfileTab(),
              );
            }
          },
        );
      },
    );
  }
}
