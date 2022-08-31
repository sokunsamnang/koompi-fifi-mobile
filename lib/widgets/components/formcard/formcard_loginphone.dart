import 'package:koompi_hotspot/all_export.dart';

@override
Widget formLoginPhone(
    BuildContext context,
    TextEditingController phoneController,
    TextEditingController passwordController,
    bool obscureText,
    Function toggle,
    String email,
    String password,
    GlobalKey<State<StatefulWidget>> formKey,
    Function submitLogin) {
  PhoneNumber number = PhoneNumber(isoCode: 'KH');
  var lang = AppLocalizeService.of(context);
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.only(bottom: 1),
    child: Padding(
        padding: const EdgeInsets.only(
            left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(lang.translate('welcome'),
                    style: const TextStyle(
                        fontSize: 24,
                        fontFamily: "Poppins-Bold",
                        letterSpacing: .6)),
              ),
              Center(
                child: Text(lang.translate('sign_in_to_continue'),
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
                // selectorConfig: SelectorConfig(
                //   selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                // ),
                ignoreBlank: false,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                selectorTextStyle: const TextStyle(color: Colors.black),
                initialValue: number,
                textFieldController: phoneController,
                formatInput: false,
                keyboardType: TextInputType.number,
                inputDecoration: InputDecoration(
                  fillColor: Colors.grey[100],
                  filled: true,
                  hintText: lang.translate('phone_number_tf'),
                  hintStyle:
                      const TextStyle(color: Colors.black, fontSize: 12.0),
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
              // IntlPhoneField(
              //   disableLengthCheck: true,
              //   showDropdownIcon: false,
              //   countries: const ["KH"],
              //   flagsButtonPadding: const EdgeInsets.all(12),
              //   decoration: InputDecoration(
              //     fillColor: Colors.grey[100],
              //     filled: true,
              //     hintText: _lang.translate('phone_number_tf'),
              //     hintStyle: const TextStyle(color: Colors.black, fontSize: 12.0),
              //     focusedBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12.0),
              //       borderSide: BorderSide(
              //         color: primaryColor,
              //       ),
              //     ),
              //     enabledBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12.0),
              //       borderSide: BorderSide(
              //         color: primaryColor,
              //       ),
              //     ),
              //     errorBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12.0),
              //       borderSide: const BorderSide(color: Colors.red),
              //     ),
              //     focusedErrorBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12.0),
              //       borderSide: const BorderSide(color: Colors.red),
              //     ),
              //   ),
              //   onChanged: (phone) {
              //     print(phone.completeNumber);
              //   },
              //   onCountryChanged: (country) {
              //     print('Country changed to: ' + country.name);
              //   },
              // ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: passwordController,
                validator: (val) {
                  if (val!.isEmpty) {
                    return lang.translate('password_is_required_validate');
                  }
                  if (val.length < 6) {
                    return lang.translate('password_too_short_validate');
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onSaved: (val) => password = val!,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  fillColor: Colors.grey[100],
                  filled: true,
                  hintText: lang.translate('password_tf'),
                  hintStyle:
                      const TextStyle(color: Colors.black, fontSize: 12.0),
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
                ),
                obscureText: obscureText,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.bottomToTop,
                                  child: const ForgotPassword()))
                          .then((value) {
                        phoneController.clear();
                        passwordController.clear();
                      });
                    },
                    child: Text(
                      lang.translate('forgot_password_bt'),
                      style: const TextStyle(
                        color: Color(0xFF5d74e3),
                        fontFamily: "Poppins-Bold",
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
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
                        submitLogin();
                      },
                      child: Center(
                        child: Text(lang.translate('sign_in_bt'),
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
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    lang.translate('dont_have_an_account'),
                    style: const TextStyle(fontFamily: "Poppins-Medium"),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.bottomToTop,
                                  child: const CreatePhone()))
                          .then((value) {
                        phoneController.clear();
                        passwordController.clear();
                      });
                    },
                    child: Text(lang.translate('sign_up_bt'),
                        style: const TextStyle(
                            color: Color(0xFF5d74e3),
                            fontFamily: "Poppins-Bold")),
                  )
                ],
              )
            ],
          ),
        )),
  );
}
