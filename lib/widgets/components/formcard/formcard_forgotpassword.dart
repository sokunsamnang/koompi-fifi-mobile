import 'package:koompi_hotspot/all_export.dart';

@override
Widget formCardForgotPasswordPhone(
    BuildContext context,
    TextEditingController _phoneController,
    String _phone,
    Function _submit,
    GlobalKey<State<StatefulWidget>> formKey,
    bool _autoValidate) {
  PhoneNumber number = PhoneNumber(isoCode: 'KH');
  var _lang = AppLocalizeService.of(context);
  return SizedBox(
    width: double.infinity,
    child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InternationalPhoneNumberInput(
                countries: const ['KH'],
                onInputChanged: (PhoneNumber number) {
                  if (kDebugMode) {
                    print(number.phoneNumber);
                  }
                },
                onInputValidated: (bool value) {
                  if (kDebugMode) {
                    print(value);
                  }
                },
                errorMessage: _lang.translate('invalid_phone_number_validate'),
                ignoreBlank: false,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                selectorTextStyle: const TextStyle(color: Colors.black),
                initialValue: number,
                textFieldController: _phoneController,
                formatInput: false,
                keyboardType: TextInputType.number,
                inputDecoration: InputDecoration(
                  fillColor: Colors.grey[100],
                  filled: true,
                  hintText: _lang.translate('phone_number_tf'),
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
                  if (kDebugMode) {
                    print('On Saved: $number');
                  }
                },
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        )),
  );
}
