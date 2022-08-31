import 'package:koompi_hotspot/all_export.dart';

class CreatePhone extends StatefulWidget {
  const CreatePhone({Key? key}) : super(key: key);

  @override
  CreatePhoneState createState() => CreatePhoneState();
}

class CreatePhoneState extends State<CreatePhone> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  final formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  String? _phone;
  String? _password;
  String? _confirmPassword;

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Initially password is obscure
  bool _obscureText = true;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  // Initially password is obscure2
  bool _obscureText2 = true;

  // Toggles2 the password show status
  void _toggle2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  void _submit() {
    final form = formKey.currentState;

    if (form!.validate()) {
      form.save();
      onSignUpByPhone();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    AppServices.noInternetConnection(globalKey);
  }

  Future<void> onSignUpByPhone() async {
    var lang = AppLocalizeService.of(context);

    dialogLoading(context);
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var response = await PostRequest().signUpWithPhone(
            StorageServices.removeZero(phoneController.text),
            passwordController.text);

        var responseJson = json.decode(response.body);

        if (response.statusCode == 200) {
          if (!mounted) return;
          Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: PinCodeVerificationScreen(
                      "+855${StorageServices.removeZero(phoneController.text)}",
                      passwordController.text)));
        } else if (response.statusCode == 401) {
          if (!mounted) return;
          await Components.dialog(
            context,
            textAlignCenter(text: responseJson['message']),
            warningTitleDialog()
          );

          if (!mounted) return;
          Navigator.of(context).pop();
        } else if (response.statusCode >= 500 && response.statusCode < 600) {
          if (!mounted) return;
          await Components.dialog(
            context,
            textAlignCenter(text: responseJson['message']),
            warningTitleDialog()
          );

          if (!mounted) return;
          Navigator.of(context).pop();
        }
      }
    } on SocketException catch (_) {
      await Components.dialog(
        context,
        textAlignCenter(text: lang.translate('no_internet_message')),
        warningTitleDialog()
      );
      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          child: createPhoneBody(
            context,
            phoneController,
            passwordController,
            confirmPasswordController,
            _obscureText,
            _toggle,
            _obscureText2,
            _toggle2,
            _phone,
            _password,
            _confirmPassword,
            formKey,
            _autoValidate,
            onSignUpByPhone,
            _submit,
          ),
        ),
      ),
    );
  }
}
