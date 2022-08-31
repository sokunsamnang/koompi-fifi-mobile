import 'package:koompi_hotspot/all_export.dart';

@override
Widget formCardPhoneNumbers(
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
    GlobalKey<State<StatefulWidget>> formKey,
    Function submit) {
  PhoneNumber number = PhoneNumber(isoCode: 'KH');
  var lang = AppLocalizeService.of(context);
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.only(bottom: 1),
    child: Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text(lang.translate('create_account'),
                  style: const TextStyle(
                      fontSize: 24,
                      fontFamily: "Poppins-Bold",
                      letterSpacing: .6)),
            ),
            Center(
              child: Text(lang.translate('create_a_new_account'),
                  style: const TextStyle(letterSpacing: .6)),
            ),
            const SizedBox(
              height: 60,
            ),
            InternationalPhoneNumberInput(
              countries: const ['KH'],
              onInputChanged: (PhoneNumber number) {
              },
              onInputValidated: (bool value) {
              },
              errorMessage: lang.translate('invalid_phone_number_validate'),
              ignoreBlank: false,
              autoValidateMode: AutovalidateMode.onUserInteraction,
              selectorTextStyle: const TextStyle(color: Colors.black),
              initialValue: number,
              textFieldController: phoneController,
              formatInput: false,
              keyboardType: TextInputType.phone,
              inputDecoration: InputDecoration(
                fillColor: Colors.grey[100],
                filled: true,
                hintText: lang.translate('phone_number_tf'),
                hintStyle: const TextStyle(color: Colors.black, fontSize: 12.0),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: primaryColor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: primaryColor,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.red),
                ),
              ),
              onSaved: (PhoneNumber number) {
                
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              validator: (val) {
                if (val!.isEmpty) {
                  return lang.translate('password_is_required_validate');
                }
                if (val.length < 6) {
                  return lang.translate('password_too_short_validate');
                }
                if (val != confirmPasswordController.text) {
                  return lang.translate('password_does_not_match_validate');
                }
                return null;
              },
              onSaved: (val) => password = val!,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: passwordController,
              obscureText: obscureText,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                fillColor: Colors.grey[100],
                filled: true,
                prefixIcon: Icon(Icons.vpn_key_sharp, color: primaryColor),
                suffixIcon: GestureDetector(
                  onTap: () {
                    toggle();
                  },
                  child: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: primaryColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: primaryColor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: primaryColor,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                hintText: lang.translate('password_tf'),
                hintStyle: const TextStyle(color: Colors.black, fontSize: 12.0),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              validator: (val) {
                if (val!.isEmpty) {
                  return lang.translate('password_is_required_validate');
                }
                if (val != passwordController.text) {
                  return lang.translate('password_does_not_match_validate');
                }
                return null;
              },
              onSaved: (val) => confirmPassword = val!,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: confirmPasswordController,
              obscureText: obscureText2,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                fillColor: Colors.grey[100],
                filled: true,
                prefixIcon: Icon(Icons.vpn_key_sharp, color: primaryColor),
                suffixIcon: GestureDetector(
                  onTap: () {
                    toggle2();
                  },
                  child: Icon(
                    obscureText2 ? Icons.visibility_off : Icons.visibility,
                    color: primaryColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: primaryColor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: primaryColor,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                hintText: lang.translate('confirm_password_tf'),
                hintStyle: const TextStyle(color: Colors.black, fontSize: 12.0),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
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
                    onTap: () {
                      submit();
                    },
                    child: Center(
                      child: Text(lang.translate('sign_up_bt'),
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
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    lang.translate('already_have_an_account'),
                    style: const TextStyle(
                      fontFamily: "Poppins-Medium",
                    ),
                  ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                              context,
                              PageTransition(
                                  type: PageTransitionType.bottomToTop,
                                  child: const LoginPhone()),
                              ModalRoute.withName('/loginPhone'))
                          .then((value) {
                        phoneController.clear();
                        passwordController.clear();
                        confirmPasswordController.clear();
                      });
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Text(
                      lang.translate('sign_in_bt'),
                      style: const TextStyle(
                          color: Color(0xfff79c4f), fontFamily: "Poppins-Bold"),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
