import 'package:in_app_update/in_app_update.dart';
import 'package:koompi_hotspot/all_export.dart';
import 'package:koompi_hotspot/providers/contact_list_provider.dart';

class LoginPhone extends StatefulWidget {
  const LoginPhone({Key? key}) : super(key: key);

  @override
  _LoginPhoneState createState() => _LoginPhoneState();
}

class _LoginPhoneState extends State<LoginPhone> {
  final formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  final String _email = '';
  final String _password = '';

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String token = '';
  String messageAlert = '';
  bool isLoading = false;

  AppUpdateInfo? updateInfo;

  // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> checkForUpdate() async {
  //   InAppUpdate.checkForUpdate().then((info) {
  //     setState(() {
  //       updateInfo = info;
  //     });
  //   }).catchError((e) {
  //     showSnack(e.toString());
  //   });
  // }

  // void showSnack(String text) {
  //   if (globalKey.currentContext != null) {
  //     ScaffoldMessenger.of(globalKey.currentContext!)
  //         .showSnackBar(SnackBar(content: Text(text)));
  //   }
  // }

  @override
  void initState() {
    super.initState();
    AppServices.noInternetConnection(globalKey);
  }

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
    passwordController.dispose();
  }

  void _submitLogin() {
    final form = formKey.currentState;

    if (form!.validate()) {
      form.save();
      login();
    } else {
      setState(() {
        autovalidateMode = AutovalidateMode.always;
      });
    }
  }

  //check connection and login
  Future<void> login() async {
    var _lang = AppLocalizeService.of(context);
    dialogLoading(context);
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (kDebugMode) {
          print('Internet connected');
        }
        var response = await PostRequest().userLogInPhone(
            StorageServices.removeZero(phoneController.text),
            passwordController.text);

        var responseJson = json.decode(response.body);

        if (response.statusCode == 200) {
          token = responseJson['token'];
          await GetRequest().getUserProfile(token).then((values) {
            setState(() {
              isLoading = true;
            });
          });
          if (token != '') {
            await StorageServices().saveString('token', token);
            await StorageServices().saveString('phone', '0${StorageServices.removeZero(phoneController.text)}');
            await StorageServices().saveString('password', passwordController.text);
            await Provider.of<BalanceProvider>(context, listen: false).fetchPortfolio();
            await Provider.of<TrxHistoryProvider>(context, listen: false).fetchTrxHistory();
            await Provider.of<GetPlanProvider>(context, listen: false).fetchHotspotPlan();
            await Provider.of<NotificationProvider>(context, listen: false).fetchNotification();
            await Provider.of<ContactListProvider>(context, listen: false).fetchContactList();
            Navigator.pushAndRemoveUntil(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: const Navbar(0),
              ),
              ModalRoute.withName('/navbar'),
            );
          } else {
            Navigator.of(context).pop();
            try {
              messageAlert = responseJson['error']['message'];
            } catch (e) {
              messageAlert = responseJson['message'];
            }
          }
        } else if (response.statusCode == 401) {
          await Components.dialog(
              context,
              textAlignCenter(text: responseJson['message']),
              warningTitleDialog());
          Navigator.of(context).pop();
        } else if (response.statusCode >= 500 && response.statusCode < 600) {
          await Components.dialog(
              context,
              textAlignCenter(text: responseJson['message']),
              warningTitleDialog());
          Navigator.of(context).pop();
        }
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print('No network socket exception');
      }
      await Components.dialog(
          context,
          textAlignCenter(text: _lang.translate('no_internet_message')),
          warningTitleDialog());
      Navigator.of(context).pop();
    } on TimeoutException catch (_) {
      if (kDebugMode) {
        print('Time out exception');
      }
      await Components.dialog(
          context,
          textAlignCenter(text: _lang.translate('request_timeout')),
          warningTitleDialog());
      Navigator.of(context).pop();
    } on FormatException catch (_) {
      if (kDebugMode) {
        print('FormatException');
      }
      await Components.dialog(
          context,
          textAlignCenter(text: _lang.translate('server_error')),
          warningTitleDialog());
      Navigator.of(context).pop();
    }
  }

  // Initially password is obscure
  bool _obscureText = true;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Image.asset("assets/images/image_02.png"),
              ],
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 35.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      child: TextButton(
                        child: const Icon(Icons.language, color: Colors.black),
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: const LanguageView()));
                        },
                      ),
                    ),
                    const SizedBox(height: 40),
                    const SizedBox(
                      width: 150,
                      height: 100,
                      child: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/Koompi-WiFi-Icon.png')),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 28.0, right: 28.0),
                      child: formLoginPhone(
                          context,
                          phoneController,
                          passwordController,
                          _obscureText,
                          _toggle,
                          _email,
                          _password,
                          formKey,
                          _submitLogin),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
