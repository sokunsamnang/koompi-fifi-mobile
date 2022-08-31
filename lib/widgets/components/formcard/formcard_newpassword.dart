import 'package:koompi_hotspot/all_export.dart';

@override
Widget formCardNewPassword(
    BuildContext context,
    TextEditingController passwordController,
    TextEditingController confirmPasswordController,
    bool obscureText,
    Function toggle,
    bool obscureText2,
    Function toggle2,
    Function submit,
    GlobalKey<State<StatefulWidget>> formKey,
    bool autoValidate) {
  var lang = AppLocalizeService.of(context);
  return Container(
    width: double.infinity,
//      height: ScreenUtil.getInstance().setHeight(500),
    padding: const EdgeInsets.only(bottom: 1),
    child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
                onSaved: (val) => passwordController.text = val!,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: passwordController,
                obscureText: obscureText,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  fillColor: Colors.grey[100],
                  filled: true,
                  prefixIcon: Icon(
                    Icons.vpn_key_sharp,
                    color: primaryColor,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      toggle();
                    },
                    child: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                        color: primaryColor),
                  ),
                  hintText: lang.translate('new_password_tf'),
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
              ),
              const SizedBox(height: 20),
              TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    return lang.translate('password_is_required_validate');
                  }
                  if (val.length < 6) {
                    return lang.translate('password_too_short_validate');
                  }
                  if (val != passwordController.text) {
                    return lang.translate('password_does_not_match_validate');
                  }
                  return null;
                },
                onSaved: (val) => passwordController.text = val!,
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
                        color: primaryColor),
                  ),
                  hintText: lang.translate('new_confirm_password_tf'),
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
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        )),
  );
}
