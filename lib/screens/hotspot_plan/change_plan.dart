import 'package:koompi_hotspot/all_export.dart';

class ChangeHotspotPlan extends StatefulWidget {
  const ChangeHotspotPlan({Key? key}) : super(key: key);

  @override
  _ChangeHotspotPlanState createState() => _ChangeHotspotPlanState();
}

class _ChangeHotspotPlanState extends State<ChangeHotspotPlan> {
  final TextEditingController _passwordController = TextEditingController();

  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  Future<void> buyHotspot30days(BuildContext context) async {
    var _lang = AppLocalizeService.of(context);

    try {
      var response = await PostRequest().changePlanHotspot(
        _passwordController.text,
        '30',
      );
      var responseJson = json.decode(response.body);

      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (response.statusCode == 200) {
          await Provider.of<GetPlanProvider>(context, listen: false)
              .fetchHotspotPlan();
          Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeft,
              child: const CompletePlan(),
            ),
            ModalRoute.withName('/navbar'),
          );
        } else {
          _passwordController.clear();
          await Components.dialog(
              context,
              textAlignCenter(text: responseJson['message']),
              warningTitleDialog());
          _passwordController.clear();
          Navigator.of(context).pop();
        }
      }
    } on SocketException catch (_) {
      await Components.dialog(
          context,
          textAlignCenter(text: _lang.translate('no_internet_message')),
          warningTitleDialog());
      _passwordController.clear();
      Navigator.of(context).pop();
    } on FormatException catch (_) {
      if (kDebugMode) {
        print('FormatException');
      }
      await Components.dialog(
          context,
          textAlignCenter(text: _lang.translate('server_error')),
          warningTitleDialog());
      _passwordController.clear();
      Navigator.of(context).pop();
    } on TimeoutException catch (_) {
      if (kDebugMode) {
        print('Time out exception');
      }
      await Components.dialog(
          context,
          textAlignCenter(text: _lang.translate('request_timeout')),
          warningTitleDialog());
      _passwordController.clear();
      Navigator.of(context).pop();
    }
  }

  Future<void> buyHotspot365days(BuildContext context) async {
    var _lang = AppLocalizeService.of(context);

    try {
      var response = await PostRequest().changePlanHotspot(
        _passwordController.text,
        '365',
      );
      var responseJson = json.decode(response.body);

      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (kDebugMode) {
          print('Internet connected');
        }
        if (response.statusCode == 200) {
          Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeft,
              child: const CompletePlan(),
            ),
            ModalRoute.withName('/navbar'),
          );
        } else {
          _passwordController.clear();
          await Components.dialog(
              context,
              textAlignCenter(text: responseJson['message']),
              warningTitleDialog());
          _passwordController.clear();
          Navigator.of(context).pop();
        }
      }
    } on SocketException catch (_) {
      await Components.dialog(
          context,
          textAlignCenter(text: _lang.translate('no_internet_message')),
          warningTitleDialog());
      _passwordController.clear();
      Navigator.of(context).pop();
    } on FormatException catch (_) {
      if (kDebugMode) {
        print('FormatException');
      }
      await Components.dialog(
          context,
          textAlignCenter(text: _lang.translate('server_error')),
          warningTitleDialog());
      _passwordController.clear();
      Navigator.of(context).pop();
    } on TimeoutException catch (_) {
      if (kDebugMode) {
        print('Time out exception');
      }
      await Components.dialog(
          context,
          textAlignCenter(text: _lang.translate('request_timeout')),
          warningTitleDialog());
      _passwordController.clear();
      Navigator.of(context).pop();
    }
  }

  // Initially password is obscure
  bool _obscureText = true;

  // Toggles the password show status
  void toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
    AppServices.noInternetConnection(globalKey);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: globalKey,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text('Choose a Plan',
          style: GoogleFonts.robotoCondensed(
          textStyle: const TextStyle(
            color: Colors.black,
            fontStyle: FontStyle.italic,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          )
        ),
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 2,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 28.0, right: 28.0, top: 20.0, bottom: 38.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 25.0),
                plan30DaysButton(context),
                const SizedBox(height: 50.0),
                plan365DaysButton(context),
              ],
            ),
          ),
        ),
      ));
  }

  Widget plan30DaysButton(BuildContext context) {
    var _lang = AppLocalizeService.of(context);
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, 15.0),
              blurRadius: 15.0),
          BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, -10.0),
              blurRadius: 10.0),
        ],
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Text(
                  // '5.000 RISE',
                  '50.0000 SEL',
                  style: GoogleFonts.nunito(
                      textStyle: TextStyle(
                          color: primaryColor,
                          fontSize: 30,
                          fontWeight: FontWeight.w700)),
                ),
              ),
              Divider(
                thickness: 1.5,
                color: Colors.grey[300],
                indent: 20,
                endIndent: 20,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right: 25, left: 25),
                child: Row(
                  children: [
                    Text(
                      '${_lang.translate('device')}:',
                      style: GoogleFonts.nunito(
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                    ),
                    Expanded(child: Container()),
                    Text(
                      '2 ${_lang.translate('devices')}',
                      style: GoogleFonts.nunito(
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(right: 25, left: 25),
                child: Row(
                  children: [
                    Text(
                      '${_lang.translate('speed')}:',
                      style: GoogleFonts.nunito(
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                    ),
                    Expanded(child: Container()),
                    Text(
                      '5 ${_lang.translate('mb')}',
                      style: GoogleFonts.nunito(
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(right: 25, left: 25),
                child: Row(
                  children: [
                    Text(
                      '${_lang.translate('expire')}:',
                      style: GoogleFonts.nunito(
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                    ),
                    Expanded(child: Container()),
                    Text(
                      '30 ${_lang.translate('day')}',
                      style: GoogleFonts.nunito(
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
              // SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                    child: InkWell(
                  child: Container(
                    // width: ScreenUtil.getInstance().setWidth(330),
                    height: 50,
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [Color(0xFF17ead9), Color(0xFF6078ea)]),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0xFF6078ea).withOpacity(.3),
                              offset: const Offset(0.0, 8.0),
                              blurRadius: 8.0)
                        ]),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        customBorder: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
                        onTap: () async {
                          if (mPlan.plan == '30') {
                            return;
                          } else {
                            mPlan.status == false
                                ? _showDialog30Days(context)
                                : await Components.dialog(
                                    context,
                                    textAlignCenter(
                                        text: _lang.translate('in_use_plan')),
                                    warningTitleDialog());
                          }
                        },
                        child: Center(
                          child: mPlan.plan == '30'
                              ? Text(
                                  _lang.translate('in_use'),
                                  style: GoogleFonts.nunito(
                                      textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700)),
                                )
                              : Text(
                                  _lang.translate('subscribe'),
                                  style: GoogleFonts.nunito(
                                      textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700)),
                                ),
                        ),
                      ),
                    ),
                  ),
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget plan365DaysButton(BuildContext context) {
    var _lang = AppLocalizeService.of(context);
    return Container(
      // width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height * .27,
      // padding: EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, 15.0),
              blurRadius: 15.0),
          BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, -10.0),
              blurRadius: 10.0),
        ],
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Text(
                  // '50.000 RISE',
                  '500.0000 SEL',
                  style: GoogleFonts.nunito(
                      textStyle: TextStyle(
                          color: primaryColor,
                          fontSize: 30,
                          fontWeight: FontWeight.w700)),
                ),
              ),
              Divider(
                thickness: 1.5,
                color: Colors.grey[300],
                indent: 20,
                endIndent: 20,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right: 25, left: 25),
                child: Row(
                  children: [
                    Text(
                      '${_lang.translate('device')}:',
                      style: GoogleFonts.nunito(
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                    ),
                    Expanded(child: Container()),
                    Text(
                      '2 ${_lang.translate('devices')}',
                      style: GoogleFonts.nunito(
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(right: 25, left: 25),
                child: Row(
                  children: [
                    Text(
                      '${_lang.translate('speed')}:',
                      style: GoogleFonts.nunito(
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                    ),
                    Expanded(child: Container()),
                    Text(
                      '5 ${_lang.translate('mb')}',
                      style: GoogleFonts.nunito(
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(right: 25, left: 25),
                child: Row(
                  children: [
                    Text(
                      '${_lang.translate('expire')}:',
                      style: GoogleFonts.nunito(
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                    ),
                    Expanded(child: Container()),
                    Text(
                      '365 ${_lang.translate('day')}',
                      style: GoogleFonts.nunito(
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
              // SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                    child: InkWell(
                  child: Container(
                    // width: ScreenUtil.getInstance().setWidth(330),
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                        gradient: const LinearGradient(
                            colors: [Color(0xFF17ead9), Color(0xFF6078ea)]),
                        // borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0xFF6078ea).withOpacity(.3),
                              offset: const Offset(0.0, 8.0),
                              blurRadius: 8.0)
                        ]),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                        onTap: () async {
                          if (mPlan.plan == '365') {
                            return;
                          } else {
                            mPlan.status == false
                                ? _showDialog365Days(context)
                                : await Components.dialog(
                                    context,
                                    textAlignCenter(
                                        text: _lang.translate('in_use_plan')),
                                    warningTitleDialog());
                          }
                        },
                        child: Center(
                          child: mPlan.plan == '365'
                              ? Text(
                                  _lang.translate('in_use'),
                                  style: GoogleFonts.nunito(
                                      textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700)),
                                )
                              : Text(
                                  _lang.translate('subscribe'),
                                  style: GoogleFonts.nunito(
                                      textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700)),
                                ),
                        ),
                      ),
                    ),
                  ),
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showDialog30Days(BuildContext context) async {
    var _lang = AppLocalizeService.of(context);
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            contentPadding:
                const EdgeInsets.only(left: 10, top: 15, right: 10, bottom: 5),
            title: const Text(
              'Enter password',
              textAlign: TextAlign.center,
            ),
            content: TextFormField(
              controller: _passwordController,
              onSaved: (val) => _passwordController.text = val!,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                fillColor: Colors.grey[100],
                filled: true,
                hintText: _lang.translate('password_tf'),
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
              obscureText: true,
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            HexColor('0CACDA')),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 35)),
                      ),
                      child: const Text('CANCEL'),
                      onPressed: () => {
                            Navigator.of(context).pop(),
                            _passwordController.clear(),
                          }),
                  TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            HexColor('0CACDA')),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        )),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 50)),
                      ),
                      child: const Text('OK'),
                      onPressed: () => {
                            dialogLoading(context),
                            buyHotspot30days(context),
                          }),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showDialog365Days(BuildContext context) async {
    var _lang = AppLocalizeService.of(context);
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            contentPadding:
                const EdgeInsets.only(left: 10, top: 15, right: 10, bottom: 5),
            title: const Text(
              'Enter password',
              textAlign: TextAlign.center,
            ),
            content: TextFormField(
              controller: _passwordController,
              onSaved: (val) => _passwordController.text = val!,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                fillColor: Colors.grey[100],
                filled: true,
                hintText: _lang.translate('password_tf'),
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
              obscureText: true,
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            HexColor('0CACDA')),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 35)),
                      ),
                      child: const Text('CANCEL'),
                      onPressed: () => {
                            Navigator.of(context).pop(),
                            _passwordController.clear(),
                          }),
                  TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            HexColor('0CACDA')),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        )),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 50)),
                      ),
                      child: const Text('OK'),
                      onPressed: () => {
                            dialogLoading(context),
                            buyHotspot365days(context),
                          }),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
