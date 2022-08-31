import 'package:koompi_hotspot/all_export.dart';

@override
Widget createPhoneBody(
  BuildContext context,
  TextEditingController phoneController,
  TextEditingController passwordController,
  TextEditingController confirmPasswordController,
  bool obscureText,
  Function toggle,
  bool obscureText2,
  Function toggle2,
  String? phone,
  String? password,
  String? confirmPassword,
  GlobalKey formKey,
  bool autoValidate,
  Function onSignUpByPhone,
  Function submit,
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
                    obscureText,
                    toggle,
                    obscureText2,
                    toggle2,
                    phone,
                    password,
                    confirmPassword,
                    formKey,
                    submit),
              ],
            ),
          ),
        )
      ],
    ),
  );
}
