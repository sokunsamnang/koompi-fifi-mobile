import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:koompi_hotspot/all_export.dart';
import 'package:koompi_hotspot/providers/contact_list_provider.dart';
import 'package:koompi_hotspot/utils/auto_login_hotspot_constants.dart' as global;
import 'package:koompi_hotspot/utils/globals.dart' as globals;
import 'package:dart_ping/dart_ping.dart';

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
        ChangeNotifierProvider<ContactListProvider>(
          create: (context) => ContactListProvider(),
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
        print("value $value");
        if (value == null) {
          setState(() {
            _lang.setLocal("EN", context);
          });
        }
        else if(value == 'EN') {
          setState(() {
            _lang.setLocal("EN", context);
          });
        }
        else if(value == 'KH') {
          setState(() {
            _lang.setLocal("KH", context);
          });
        }
      },
    );
  }

  getValue() async {
    const storage = FlutterSecureStorage();
    setState(() {
      global.phone = storage.read(key: 'phone').toString();
      global.password = storage.read(key: 'password').toString();
    });
  }


  @override
  void initState() {
    super.initState();

    if(mounted){
      setState(() {
        //Set Language
        setDefaultLang();
      
        startTime();
        getValue();
        // hasInternetInternetConnection();
        isWifiAccess();
        initQuickActions();
        initDynamicLinks();
      });
    }

  }

  String url = '';

  ///Retreive dynamic link firebase.
  void initDynamicLinks() async {
    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      handleDynamicLink(deepLink);
    }
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      final Uri? deepLink = dynamicLink?.link;

      if (deepLink != null) {
        handleDynamicLink(deepLink);
      }
    }, onError: (OnLinkErrorException e) async {
      if (kDebugMode) {
        print(e.message);
      }
    });
  }

  handleDynamicLink(Uri url) {
    List<String> separatedString = [];
    separatedString.addAll(url.path.split('/'));
    if (separatedString[1] == "startapp") {
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.bottomToTop,
          child: const MyAccount(),
        ),
      );
    }
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


  Future<void> isWifiAccess() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    
    if (connectivityResult == ConnectivityResult.wifi) {
        // Create ping object with desired args
      try {
        final ping = Ping('google.com', count: 2);

        // Begin ping process and listen for output
        ping.stream.listen((event) {
          if(event.error != null) {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.bottomToTop,
                child: const CaptivePortalWeb(),
              ),
            );
          }
        });
      }catch(e){
        // print(e);
      }
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
