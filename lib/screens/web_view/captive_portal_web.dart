import 'package:koompi_hotspot/all_export.dart';
import 'package:koompi_hotspot/providers/contact_list_provider.dart';
import 'package:koompi_hotspot/utils/auto_login_hotspot_constants.dart'
    as global;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path/path.dart';

// String selectedUrl = 'http://connectivitycheck.android.com/generate_204';
String selectedUrl = 'https://unifi.koompi.org/guest/s/srdd5hh7/#/';
String otherUrl = 'https://koompi.com/';

class CaptivePortalWeb extends StatefulWidget {
  const CaptivePortalWeb({Key? key}) : super(key: key);

  @override
  _CaptivePortalWebState createState() => _CaptivePortalWebState();
}

class _CaptivePortalWebState extends State<CaptivePortalWeb> {
  final GlobalKey webViewKey = GlobalKey();



  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  PullToRefreshController? pullToRefreshController;
  String url = "";
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _lang = AppLocalizeService.of(context);

    Timer requestTimer = Timer(const Duration(seconds: 5), () async {
      StorageServices().checkUser(context);
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(_lang.translate('login_hotspot'),
          style: GoogleFonts.robotoCondensed(
            textStyle: const TextStyle(
              color: Colors.black,
              fontStyle: FontStyle.italic,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            )
          ),
        ),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              });
        }),
      ),
      body: WillPopScope(
        onWillPop: () async {
          return Navigator.canPop(context);
        },
        child: InAppWebView(
          key: webViewKey,
          initialUrlRequest: URLRequest(url: Uri.parse(selectedUrl)),
          initialOptions: options,
          pullToRefreshController: pullToRefreshController,
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
          onLoadStart: (controller, url) {
            setState(() {
              this.url = url.toString();
              urlController.text = this.url;
            });
          },
          androidOnPermissionRequest: (controller, origin, resources) async {
            return PermissionRequestResponse(
                resources: resources,
                action: PermissionRequestResponseAction.GRANT);
          },
          onReceivedServerTrustAuthRequest: (controller, challenge) async {
            return ServerTrustAuthResponse(
                action: ServerTrustAuthResponseAction.PROCEED);
          },
          onLoadResource: (controller, url) async {
            print(controller);
            setState(() {
              

              // controller.evaluateJavascript(source: '''
              //   document.getElementById("user").value="${global.phone}";
              //   document.getElementById("password").value="${global.password}";
              //   document.getElementById("btnlogin").click();
              // ''');uateJavascript(source: "");

              controller.evaluateJavascript(source: """
                var scopeUser = angular.element(document.getElementById('user')).scope();
                scopeUser.\$apply('homeCtrl.formModel.username = "${global.phone}";');
                var scopePass = angular.element(document.getElementById('password')).scope();
                scopePass.\$apply('homeCtrl.formModel.password = "${global.password}";');
                document.getElementById("btnlogin").click();
              """);
            });
          },
          onLoadStop: (controller, url) async {
            print(url);
            print(controller);
            setState(() {

              this.url = url.toString();
              urlController.text = this.url;
              // controller.evaluateJavascript(source: '''
              //   document.getElementById("user").value="${global.phone}";
              //   document.getElementById("password").value="${global.password}";
              //   document.getElementById("btnlogin").click();
              // ''');
              
              controller.evaluateJavascript(source: """
                var scopeUser = angular.element(document.getElementById('user')).scope();
                scopeUser.\$apply('homeCtrl.formModel.username = "${global.phone}";');
                var scopePass = angular.element(document.getElementById('password')).scope();
                scopePass.\$apply('homeCtrl.formModel.password = "${global.password}";');
                document.getElementById("btnlogin").click();
              """);
              
            });

            
            if(url == Uri.parse(selectedUrl)){
              print('requesting');
              requestTimer;
              if(mData.fullname!.isNotEmpty){
                print('request cancel');
                requestTimer.cancel();
              }
            }
            
          },
          onConsoleMessage: (controller, consoleMessage) {
            if (kDebugMode) {
              print(consoleMessage);
            }
          },
        ),
      ),
    );
  }
}