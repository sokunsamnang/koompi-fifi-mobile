import 'package:koompi_hotspot/all_export.dart';

@override
Widget forgetPasswordBody(
    BuildContext context,
    String _phone,
    TextEditingController _phoneController,
    Function _submitValidate,
    GlobalKey<FormState> formKey,
    bool _autoValidate) {
  var _lang = AppLocalizeService.of(context);
  return Scaffold(
    backgroundColor: Colors.white,
    resizeToAvoidBottomInset: true,
    body: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(child: Container()),
            Expanded(child: Container()),
            Expanded(child: Container()),
            Expanded(child: Container()),
            Expanded(child: Container()),
            Expanded(child: Image.asset("assets/images/image_02.png"))
          ],
        ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 28.0, right: 28.0, top: 40.0),
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Image.asset("assets/images/security.png"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        _lang.translate('forgot_password'),
                        style: TextStyle(
                            color: primaryColor,
                            fontFamily: 'Medium',
                            fontSize: 23),
                      ),
                    ),
                    Center(
                      child: Text(
                        _lang.translate('forgot_password_tx'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Medium',
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                formCardForgotPasswordPhone(context, _phoneController, _phone,
                    _submitValidate, formKey, _autoValidate),
                // const SizedBox(height: 20),
                Center(
                    child: InkWell(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [Color(0xFF17ead9), Color(0xFF6078ea)]),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0xFF6078ea).withOpacity(.3),
                              offset: const Offset(0.0, 8.0),
                              blurRadius: 8.0)
                        ]),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        onTap: () async {
                          _submitValidate();
                        },
                        child: Center(
                          child: Text(_lang.translate('reset_password_bt'),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Poppins-Bold",
                                  fontSize: 18,
                                  letterSpacing: 1.0)),
                        ),
                      ),
                    ),
                  ),
                )),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        _lang.translate('back_to_login'),
                        style: const TextStyle(fontFamily: "Poppins-Medium"),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPhone()));
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Text(_lang.translate('sign_in_bt'),
                            style: const TextStyle(
                                color: Color(0xfff79c4f),
                                fontFamily: "Poppins-Bold")),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );
}
