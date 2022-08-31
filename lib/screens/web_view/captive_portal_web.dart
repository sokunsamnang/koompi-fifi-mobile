import 'package:koompi_hotspot/all_export.dart';
import 'package:koompi_hotspot/utils/auto_login_hotspot_constants.dart'
    as global;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

String selectedUrl = 'http://connectivitycheck.android.com/generate_204';
// String selectedUrl = 'https://unifi.koompi.org/guest/s/srdd5hh7/#/';
String otherUrl = 'https://koompi.com/';

class CaptivePortalWeb extends StatefulWidget {
  const CaptivePortalWeb({Key? key}) : super(key: key);

  @override
  CaptivePortalWebState createState() => CaptivePortalWebState();
}

class CaptivePortalWebState extends State<CaptivePortalWeb> {
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
    var lang = AppLocalizeService.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(lang.translate('login_hotspot'),
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
                Iconsax.arrow_left_2,
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
            setState(() {
              controller.evaluateJavascript(source: '''
                document.getElementById("phonenumber").value="${global.phone}";
                document.getElementById("userpassword").value="${global.password}";
                document.getElementById("btnlogin").click();
              ''');

              // controller.evaluateJavascript(source: """
              //   var scopeUser = angular.element(document.getElementById('user')).scope();
              //   scopeUser.\$apply('homeCtrl.formModel.username = "${global.phone}";');
              //   var scopePass = angular.element(document.getElementById('password')).scope();
              //   scopePass.\$apply('homeCtrl.formModel.password = "${global.password}";');
              //   document.getElementById("btnlogin").click();
              // """);
            });
          },
          onLoadStop: (controller, url) async {
            setState(() {
              this.url = url.toString();
              urlController.text = this.url;
              controller.evaluateJavascript(source: '''
                document.getElementById("phonenumber").value="${global.phone}";
                document.getElementById("userpassword").value="${global.password}";
                document.getElementById("btnlogin").click();
              ''');
              
              // controller.evaluateJavascript(source: """
              //   var scopeUser = angular.element(document.getElementById('user')).scope();
              //   scopeUser.\$apply('homeCtrl.formModel.username = "${global.phone}";');
              //   var scopePass = angular.element(document.getElementById('password')).scope();
              //   scopePass.\$apply('homeCtrl.formModel.password = "${global.password}";');
              //   document.getElementById("btnlogin").click();
              // """);
              
            });

            
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