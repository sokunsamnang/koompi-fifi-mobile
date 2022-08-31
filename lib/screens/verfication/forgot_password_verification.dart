import 'package:http/http.dart' as http;
import 'package:koompi_hotspot/all_export.dart';
import 'package:lottie/lottie.dart';

class ForgotPasswordVerification extends StatefulWidget {
  final String phone;

  const ForgotPasswordVerification(this.phone, {Key? key}) : super(key: key);

  @override
  ForgotPasswordVerificationState createState() =>
      ForgotPasswordVerificationState();
}

class ForgotPasswordVerificationState
    extends State<ForgotPasswordVerification> {
  dynamic onTapRecognizer;

  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  StreamController<ErrorAnimationType>? errorController;

  bool isLoading = false;
  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  Future<void> _submitOtp(String vCode) async {
    var lang = AppLocalizeService.of(context);

    dialogLoading(context);
    try {
      String apiUrl = '${ApiService.url}/auth/confirm-phone';
      setState(() {
        isLoading = true;
      });
      var response = await http.post(Uri.parse(apiUrl),
          headers: <String, String>{
            "accept": "application/json",
            "Content-Type": "application/json"
          },
          body: jsonEncode(<String, String>{
            "phone": widget.phone,
            "vCode": vCode,
          }));
      var responseJson = json.decode(response.body);
      if (response.statusCode == 200 && response.body != "Incorrect Code!") {
        if (kDebugMode) {
          print(response.body);
        }

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: ResetNewPassword(widget.phone),
          ),
        );
      } else {

        if (!mounted) return;
        await Components.dialog(
          context,
          textAlignCenter(text: responseJson['message']),
          warningTitleDialog()
        );

        if (!mounted) return;
        Navigator.of(context).pop();
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print('No network socket exception');
      }
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
      backgroundColor: Colors.blue.shade50,
      key: scaffoldKey,
      body: GestureDetector(
        onTap: () {},
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 30),
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: Lottie.asset(
                  "assets/animations/otp.json",
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.center,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  lang.translate('phone_number_verification'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: primaryColor),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                      text: lang.translate('enter_the_code_sent_to'),
                      children: [
                        TextSpan(
                            text: widget.phone,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 15)),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 30),
                    child: PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 6,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      validator: (v) {
                        if (v!.length < 6) {
                          return lang.translate('verify_validate');
                        } else {
                          return null;
                        }
                      },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor:
                            hasError ? Colors.orange : Colors.white,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      animationDuration: const Duration(milliseconds: 300),
                      backgroundColor: Colors.blue.shade50,
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      onCompleted: (v) {
                        // Navigator.pushReplacement(
                        //   context, MaterialPageRoute(builder: (context) => ResetNewPassword()));
                        _submitOtp(currentText);
                        
                      },
                      onChanged: (value) {

                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError
                      ? lang.translate(
                          'please_fill_up_all_the_cells_properly_validate')
                      : "",
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 14,
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ButtonTheme(
                  height: 50,
                  child: TextButton(
                    onPressed: () async {
                      formKey.currentState!.validate();
                      // conditions for validating
                      if (currentText.length != 6) {
                        errorController!.add(ErrorAnimationType
                            .shake); // Triggering error shake animation
                        setState(() {
                          hasError = true;
                        });
                      } else {
                        await _submitOtp(currentText);
                      }
                    },
                    child: Center(
                        child: Text(
                      lang.translate('verify_bt'),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
