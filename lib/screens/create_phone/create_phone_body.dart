import 'package:koompi_hotspot/all_export.dart';

@override
Widget createPhoneBody(
  BuildContext context,
  TextEditingController phoneController,
  TextEditingController passwordController,
  TextEditingController confirmPasswordController,
  bool _obscureText,
  Function _toggle,
  bool _obscureText2,
  Function _toggle2,
  String? _phone,
  String? _password,
  String? _confirmPassword,
  GlobalKey formKey,
  bool _autoValidate,
  Function onSignUpByPhone,
  Function _submit,
) {
  return Scaffold(
    backgroundColor: Colors.white,
    resizeToAvoidBottomInset: true,
    body: Stack(
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
            padding: const EdgeInsets.only(left: 28.0, right: 28.0, top: 35.0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 50),
                formCardPhoneNumbers(
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
                    _submit),
              ],
            ),
          ),
        )
      ],
    ),
  );
}
