import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:koompi_hotspot/all_export.dart';
import 'package:koompi_hotspot/utils/auto_login_hotspot_constants.dart'
    as global;
import 'package:koompi_hotspot/utils/globals.dart' as globals;
import 'package:onesignal_flutter/onesignal_flutter.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LangProvider>(
          create: (context) => LangProvider(),
        ),
        ChangeNotifierProvider<BalanceProvider>(
          create: (context) => BalanceProvider(),
        ),
        ChangeNotifierProvider<TrxHistoryProvider>(
            create: (context) => TrxHistoryProvider()),
        ChangeNotifierProvider<GetPlanProvider>(
          create: (context) => GetPlanProvider(),
        ),
        ChangeNotifierProvider<NotificationProvider>(
          create: (context) => NotificationProvider(),
        ),
        ChangeNotifierProvider<VoteResultProvider>(
          create: (context) => VoteResultProvider(),
        ),
      ],
      child: Consumer<LangProvider>(
        builder: (context, value, child) => MaterialApp(
          builder: (context, widget) => ResponsiveWrapper.builder(
            BouncingScrollWrapper.builder(context, widget!),
            maxWidth: 2460,
            minWidth: 425,
            defaultScale: true,
            breakpoints: [
              const ResponsiveBreakpoint.autoScale(425, name: MOBILE),
              const ResponsiveBreakpoint.autoScale(800, name: TABLET),
              const ResponsiveBreakpoint.autoScale(1000, name: DESKTOP),
              const ResponsiveBreakpoint.autoScale(2460, name: '4K'),
            ],
          ),
          locale: value.manualLocale,
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('km', 'KH'),
          ],
          localizationsDelegates: const [
            AppLocalizeService.delegate,
            //build-in localization for material widgets
            GlobalWidgetsLocalizations.delegate,

            GlobalMaterialLocalizations.delegate,
          ],
          initialRoute: '/',
          navigatorKey: globals.appNavigator,
          routes: {
            '/navbar': (context) => const Navbar(0),
            '/plan': (context) => const HotspotPlan(),
            '/loginPhone': (context) => const LoginPhone(),
            '/walletScreen': (context) => const WalletScreen(),
          },
          title: 'KOOMPI Fi-Fi',
          home: const Splash(),
        ),
      ),
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  startTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? firstTime = prefs.getBool('first_time');

    if (firstTime != null && !firstTime) {
      // Not first time
      return isLoggedIn();
    } else {
      // First time
      prefs.setBool('first_time', false);
      return navigationOnboardingScreen();
    }
  }

  void navigationOnboardingScreen() {
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: const IntroScreen(),
      ),
    );
  }

  void isLoggedIn() async {
    setState(() {
      StorageServices().checkUser(context);
    });
  }

  void setDefaultLang() {
    var _lang = Provider.of<LangProvider>(context, listen: false);
    StorageServices().read('lang').then(
      (value) {
        if (value == null) {
          setState(() {
            StorageServices().saveString('lang', 'EN');
            _lang.setLocal(value, context);
          });
        } else {
          setState(() {
            _lang.setLocal(value, context);
          });
        }
      },
    );
  }

  getValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      global.phone = prefs.getString('phone');
      global.password = prefs.getString('password');
    });
    if (kDebugMode) {
      print(global.phone);
      print(global.password);
    }
  }

  @override
  void initState() {
    super.initState();
    configOneSignal();
    setState(() {
      isInternet();
      getValue();
      startTime();
    });
    initQuickActions();

    //Set Language
    setDefaultLang();
  }

  final quickActions = const QuickActions();

  void initQuickActions() {
    quickActions.initialize((type) {
      if (type == '') return;

      if (type == ShortcutItems.actionCaptivePortal.type) {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.bottomToTop,
            child: const CaptivePortalWeb(),
          ),
        );
      }
    });

    quickActions.setShortcutItems(ShortcutItems.items);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void configOneSignal() async {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    /// Set App Id.
    OneSignal.shared.setAppId("05805743-ce69-4224-9afb-b2f36bf6c1db");

    await OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);
  }

  Future<bool> isInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network, make sure there is actually a net connection.
      if (await DataConnectionChecker().hasConnection) {
        // Mobile data detected & internet connection confirmed.
        if (kDebugMode) {
          print('Mobile data detected & internet connection confirmed.');
        }
        return true;
      } else {
        // Mobile data detected but no internet connection found.
        if (kDebugMode) {
          print('Mobile data detected but no internet connection found.');
        }
        return false;
      }
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a WIFI network, make sure there is actually a net connection.
      if (kDebugMode) {
        print(
            'I am connected to a WIFI network, make sure there is actually a net connection.');
      }
      if (await DataConnectionChecker().hasConnection) {
        // Wifi detected & internet connection confirmed.
        if (kDebugMode) {
          print('Wifi detected & internet connection confirmed.');
        }
        return true;
      } else {
        // Wifi detected but no internet connection found.
        if (kDebugMode) {
          print('Wifi detected but no internet connection found.');
        }

        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: const CaptivePortalWeb(),
          ),
        );
        return false;
      }
    } else {
      // Neither mobile data or WIFI detected, not internet connection found.
      if (kDebugMode) {
        print(
            'Neither mobile data or WIFI detected, not internet connection found.');
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xff0caddb),
      body: Center(
        child: FlareActor(
          'assets/animations/koompi_splash_screen.flr',
          animation: 'Splash_Loop',
        ),
      ),
    );
  }
}
