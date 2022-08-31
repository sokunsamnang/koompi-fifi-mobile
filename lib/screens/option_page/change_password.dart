import 'package:http/http.dart' as http;
import 'package:koompi_hotspot/all_export.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  ChangePasswordState createState() => ChangePasswordState();
}

class ChangePasswordState extends State<ChangePassword>
    with SingleTickerProviderStateMixin {
  String? messageAlert;
  bool enable = false;
  final ModelChangePassword _modelChangePassword = ModelChangePassword();

  @override
  void initState() {
    AppServices.noInternetConnection(_modelChangePassword.globalKey);
    super.initState();
  }

  @override
  void dispose() {
    removeAllFocus();
    _modelChangePassword.controlOldPassword.clear();
    _modelChangePassword.controlNewPassword.clear();
    _modelChangePassword.controlConfirmPassword.clear();
    super.dispose();
  }

  void popScreen() {
    Navigator.pop(context);
  }

  void onChanged(String? changed) {
    _modelChangePassword.formStateChangePassword.currentState!.validate();
  }

  void onSubmit(String? submut) {
    if (_modelChangePassword.nodeOldPassword.hasFocus) {
      FocusScope.of(context).requestFocus(_modelChangePassword.nodeNewPassword);
    } else if (_modelChangePassword.nodeNewPassword.hasFocus) {
      FocusScope.of(context)
          .requestFocus(_modelChangePassword.nodeConfirmPassword);
    } else {
      if (_modelChangePassword.enable == true) _resetPassword();
    }
  }

  String? validateOldPass(String? value) {
    if (_modelChangePassword.nodeOldPassword.hasFocus) {
      _modelChangePassword.responseOldPass =
          instanceValidate.validatePassword(value!, context);
      validateAllFieldNotEmpty();
    }
    return _modelChangePassword.responseOldPass;
  }

  String? validateNewPass(String? value) {
    if (_modelChangePassword.nodeNewPassword.hasFocus) {
      _modelChangePassword.responseNewPass =
          instanceValidate.validatePassword(value!, context);
      if (_modelChangePassword.responseNewPass == null) {
        _modelChangePassword.responseConfirm = newPasswordIsmatch();
      } else if (_modelChangePassword.responseConfirm ==
          "Password does not match") {
        // Remove Not Match Error When New Pass Error
        _modelChangePassword.responseConfirm = null;
      }
      validateAllFieldNotEmpty();
    }
    return _modelChangePassword.responseNewPass;
  }

  String? validateConfirmPass(String? value) {
    if (_modelChangePassword.nodeConfirmPassword.hasFocus) {
      _modelChangePassword.responseConfirm =
          instanceValidate.validatePassword(value!, context);
      if (_modelChangePassword.responseConfirm == null) {
        _modelChangePassword.responseConfirm = confirmPasswordIsMatch();
        validateAllFieldNotEmpty();
      }
    }
    return _modelChangePassword.responseConfirm;
  }

  void validateAllFieldNotEmpty() {
    /* Enable And Disable Button */
    if (_modelChangePassword.controlOldPassword.text.length >= 6 &&
        _modelChangePassword.controlNewPassword.text.length >= 6 &&
        _modelChangePassword.controlConfirmPassword.text.length >= 6) {
      validateAllFieldNoError();
    } else if (_modelChangePassword.enable == true) {
      enableButton(false);
    }
  }

  void validateAllFieldNoError() {
    if (_modelChangePassword.responseOldPass == null &&
        _modelChangePassword.responseNewPass == null &&
        _modelChangePassword.responseConfirm == null) {
      enableButton(true);
    } else if (_modelChangePassword.enable == true) {
      enableButton(false);
    }
  }

  String? newPasswordIsmatch() {
    var lang = AppLocalizeService.of(context);
    if (_modelChangePassword.controlConfirmPassword.text.length >= 6) {
      if (_modelChangePassword.controlNewPassword.text ==
          _modelChangePassword.controlConfirmPassword.text) {
        enableButton(true);
        _modelChangePassword.responseConfirm = null;
      } else {
        if (_modelChangePassword.enable == true) enableButton(false);
        _modelChangePassword.responseConfirm =
            lang.translate('password_does_not_match_validate');
      }
    }
    return _modelChangePassword.responseConfirm;
  }

  String? confirmPasswordIsMatch() {
    var lang = AppLocalizeService.of(context);
    if (_modelChangePassword.controlNewPassword.text.length >= 6) {
      if (_modelChangePassword.controlNewPassword.text ==
          _modelChangePassword.controlConfirmPassword.text) {
        enableButton(true);
        _modelChangePassword.responseConfirm = null;
      } else {
        if (_modelChangePassword.enable == true) enableButton(false);
        _modelChangePassword.responseConfirm =
            lang.translate('password_does_not_match_validate');
      }
    }
    return _modelChangePassword.responseConfirm;
  }

  void enableButton(bool enable) {
    setState(() => _modelChangePassword.enable = enable);
  }

  void removeAllFocus() {
    _modelChangePassword.nodeOldPassword.unfocus();
    _modelChangePassword.nodeNewPassword.unfocus();
    _modelChangePassword.nodeConfirmPassword.unfocus();
  }

  /* Current password toggle */

  // Initially password is obscure
  bool _obscureText = true;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  /* Second password toggle */

  // Initially password is obscure
  bool _obscureText2 = true;

  // Toggles the password show status
  void _toggle2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  /* Third password toggle */

  // Initially password is obscure
  bool _obscureText3 = true;

  // Toggles the password show status
  void _toggle3() {
    setState(() {
      _obscureText3 = !_obscureText3;
    });
  }

  String? alertText;
  bool isLoading = false;

  Future<void> _resetPassword() async {
    var lang = AppLocalizeService.of(context);
    dialogLoading(context);
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');
    try {
      String apiUrl = '${ApiService.url}/change-password/account-phone';
      setState(() {
        isLoading = true;
      });
      var response = await http.put(Uri.parse(apiUrl),
          headers: <String, String>{
            "accept": "application/json",
            "content-type": "application/json",
            "authorization": "Bearer ${token!}",
          },
          body: jsonEncode(<String, String>{
            "old_password": _modelChangePassword.controlOldPassword.text,
            "new_password": _modelChangePassword.controlConfirmPassword.text,
          }));

      var responseJson = json.decode(response.body);
      if (response.statusCode == 200) {
        await StorageServices().deleteAllKeys();

        if (!mounted) return;
        await Components.dialogResetPw(
          context,
          Text(lang.translate('tf_change_password'),
              textAlign: TextAlign.center),
          Text(
            lang.translate('complete'),
            style: const TextStyle(fontFamily: 'Poppins-Bold'),
          ),
        );

        if (!mounted) return;
        Navigator.pop(context);
      } else {

        if (!mounted) return;
        await Components.dialog(
          context,
          textAlignCenter(text: responseJson['message']),
          warningTitleDialog()
        );

        if (!mounted) return;
        Navigator.of(context).pop();
        if (kDebugMode) {
          print(response.body);
        }
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print('No network socket exception');
      }

      if (!mounted) return;
      await Components.dialog(
        context,
        textAlignCenter(text: lang.translate('no_internet_message')),
        warningTitleDialog()
      );

      if (!mounted) return;
      Navigator.of(context).pop();
    } on TimeoutException catch (_) {
      if (kDebugMode) {
        print('Time out exception');
      }

      if (!mounted) return;
      await Components.dialog(
        context,
        textAlignCenter(text: lang.translate('request_timeout')),
        warningTitleDialog()
      );

      if (!mounted) return;
      Navigator.of(context).pop();
    } on FormatException catch (_) {
      if (kDebugMode) {
        print('FormatException');
      }

      if (!mounted) return;
      await Components.dialog(
        context,
        textAlignCenter(text: lang.translate('server_error')),
        warningTitleDialog()
      );

      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizeService.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      key: _modelChangePassword.globalKey,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(lang.translate('change_password'),
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
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: GestureDetector(
              child: IconButton(
                splashColor: _modelChangePassword.enable == false
                    ? Colors.transparent
                    : null,
                highlightColor: _modelChangePassword.enable == false
                    ? Colors.transparent
                    : null,
                icon: Icon(Icons.check,
                    color: _modelChangePassword.enable == true
                        ? Colors.blueAccent
                        : Colors.grey),
                onPressed: () async {
                  return _modelChangePassword.enable == true
                      ? _resetPassword()
                      : null;
                },
              ),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 2,
          child: Form(
            key: _modelChangePassword.formStateChangePassword,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(left: 28.0, right: 28.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 16.0),
                    // Text(_lang.translate('current_password')),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      obscureText: _obscureText,
                      onFieldSubmitted: onSubmit,
                      controller: _modelChangePassword.controlOldPassword,
                      focusNode: _modelChangePassword.nodeOldPassword,
                      validator: validateOldPass,
                      onChanged: onChanged,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Iconsax.unlock,
                          color: primaryColor,
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            _toggle();
                          },
                          child: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: primaryColor,
                          ),
                        ),
                        hintText: lang.translate('current_password'),
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
                    ),
                    const SizedBox(height: 16.0),
                    // Text(_lang.translate('new_password_tf')),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      obscureText: _obscureText2,
                      onFieldSubmitted: onSubmit,
                      controller: _modelChangePassword.controlNewPassword,
                      focusNode: _modelChangePassword.nodeNewPassword,
                      validator: validateNewPass,
                      onChanged: onChanged,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Iconsax.unlock,
                            color: primaryColor),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            _toggle2();
                          },
                          child: Icon(
                            _obscureText2
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: primaryColor,
                          ),
                        ),
                        hintText: lang.translate('new_password_tf'),
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
                    ),
                    const SizedBox(height: 16.0),
                    // Text(_lang.translate('new_confirm_password_tf')),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      obscureText: _obscureText3,
                      onFieldSubmitted: onSubmit,
                      controller: _modelChangePassword.controlConfirmPassword,
                      focusNode: _modelChangePassword.nodeConfirmPassword,
                      validator: validateConfirmPass,
                      onChanged: onChanged,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Iconsax.unlock,
                            color: primaryColor),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            _toggle3();
                          },
                          child: Icon(
                            _obscureText3
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: primaryColor,
                          ),
                        ),
                        hintText: lang.translate('new_confirm_password_tf'),
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
