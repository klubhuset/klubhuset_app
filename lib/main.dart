import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:klubhuset/page/login/login_page.dart';
import 'package:klubhuset/page/login/register.dart';
import 'package:klubhuset/services/auth_service.dart';
import 'package:klubhuset/state/user_votes_state.dart';
import 'package:klubhuset/tab/home_tab.dart';
import 'package:klubhuset/tab/profile_tab.dart';
import 'package:provider/provider.dart';

String _appTitle = 'Klubhuset';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserVotesState()),
        ChangeNotifierProvider(create: (context) => AuthService()),
      ],
      child: const KlubhusetApp(),
    ),
  );
}

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String register = '/register';

  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => const LoginPage(),
      home: (context) => const MainPage(),
      register: (context) => const RegisterScreen(),
    };
  }
}

class KlubhusetApp extends StatelessWidget {
  const KlubhusetApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return CupertinoApp(
      title: _appTitle,
      theme: CupertinoThemeData(
          brightness: Brightness.light,
          primaryColor: CupertinoColors.systemIndigo,
          scaffoldBackgroundColor: CupertinoColors.systemBackground),
      // Danish and English localization support
      localizationsDelegates: <LocalizationsDelegate<dynamic>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: <Locale>[
        Locale('da'),
        Locale('en'),
      ],
      home: authService.currentUser == null
          ? const LoginPage()
          : const MainPage(),
      // home: const MainPage(),
      routes: AppRoutes.routes,
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
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
          navigatorKey: _navigatorKeys[index],
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
