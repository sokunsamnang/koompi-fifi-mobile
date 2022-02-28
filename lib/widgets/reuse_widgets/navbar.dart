import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:koompi_hotspot/all_export.dart';
import 'package:koompi_hotspot/utils/auto_login_hotspot_constants.dart'
    as global;

class Navbar extends StatefulWidget {
  final int selectedIndex;

  const Navbar(this.selectedIndex, {Key? key}) : super(key: key);
  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> with WidgetsBindingObserver {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const MyLocationView(),
    const WifiConnect(),
    const MorePage(),
  ];

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.paused:
        DataConnectivityService()
            .connectivityStreamController
            .stream
            .listen((event) {
          if (kDebugMode) {
            print(event);
          }
          if (event == DataConnectionStatus.connected) {
            return;
          } else if (event == DataConnectionStatus.disconnected) {
            _paused();
          } else {
            return;
          }
        });
        break;
      case AppLifecycleState.inactive:
        break;
      default:
        break;
    }
  }

  Future _paused() async {
    if (kDebugMode) {
      print('paused');
    }
    return inputWeb();
  }

  final flutterWebViewPlugin = FlutterWebviewPlugin();

  StreamSubscription<WebViewStateChanged>? _onchanged;

  Future inputWeb() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      global.phone = prefs.getString('phone')!;
      global.password = prefs.getString('password')!;

      if (kDebugMode) {
        print('Run web portal');
      }
      flutterWebViewPlugin.close();
      flutterWebViewPlugin.launch(selectedUrl,
          hidden: true, withJavascript: true, ignoreSSLErrors: true);
      _onchanged = flutterWebViewPlugin.onStateChanged
          .listen((WebViewStateChanged state) {
        if (mounted) {
          if (state.type == WebViewState.finishLoad) {
            // if the full website page loaded
            if (kDebugMode) {
              print('web laoded');
            }
            flutterWebViewPlugin.evalJavascript(
                'document.getElementById("user").value="${global.phone}"'); // Replace with the id of username field
            flutterWebViewPlugin.evalJavascript(
                'document.getElementById("password").value="${global.password}"'); // Replace with the id of password field
            flutterWebViewPlugin.evalJavascript(
                'document.getElementById("btnlogin").click()'); // Replace with Submit button id

          } else if (state.type == WebViewState.abortLoad) {
            // if there is a problem with loading the url
            if (kDebugMode) {
              print("there is a problem...");
            }
          } else if (state.type == WebViewState.startLoad) {
            // if the url started loading
            if (kDebugMode) {
              print("start loading...");
            }
          }
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.selectedIndex == 0) {
      _selectedIndex = 0;
    }
    if (widget.selectedIndex == 1) {
      _selectedIndex = 1;
    }
    if (widget.selectedIndex == 2) {
      _selectedIndex = 2;
    }
    if (widget.selectedIndex == 3) {
      _selectedIndex = 3;
    }

    // Data Connection AppLifecycleState
    WidgetsBinding.instance!.addObserver(this);
    DataConnectivityService()
        .connectivityStreamController
        .stream
        .listen((event) {
      if (kDebugMode) {
        print(event);
      }
      if (event == DataConnectionStatus.connected) {
        return;
      } else if (event == DataConnectionStatus.disconnected) {
        _paused();
      } else {
        return;
      }
    });
  }

  @override
  void dispose() {
    // _onchanged.cancel();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _lang = AppLocalizeService.of(context);
    return Scaffold(
      drawer: const SideMenu(),
      body: Center(
        child: SafeArea(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
                gap: 8,
                activeColor: Colors.white,
                iconSize: 24,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                duration: const Duration(milliseconds: 500),
                tabBackgroundColor: primaryColor,
                tabs: [
                  GButton(
                    icon: LineIcons.home,
                    text: _lang.translate('home'),
                  ),
                  GButton(
                    icon: LineIcons.map,
                    text: _lang.translate('map'),
                  ),
                  GButton(
                    icon: Icons.wifi_outlined,
                    text: _lang.translate('wifi'),
                  ),
                  GButton(
                    icon: LineIcons.bars,
                    text: _lang.translate('more'),
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }),
          ),
        ),
      ),
    );
  }
}
