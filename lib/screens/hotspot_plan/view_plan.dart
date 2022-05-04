import 'package:koompi_hotspot/all_export.dart';
import 'package:intl/intl.dart';

class PlanView extends StatefulWidget {
  const PlanView({Key? key}) : super(key: key);

  @override
  _PlanViewState createState() => _PlanViewState();
}

class _PlanViewState extends State<PlanView> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  final TextEditingController _passwordController = TextEditingController();

  Future<void> renewPlan() async {
    var _lang = AppLocalizeService.of(context);

    var response =
        await PostRequest().renewPlanHotspot(_passwordController.text);
    var responseJson = json.decode(response.body);

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (kDebugMode) {
          print('Internet connected');
        }

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
    var _lang = AppLocalizeService.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      key: globalKey,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Colors.white,
        title: Text(
          _lang.translate('my_plan'),
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
                top: 38.0, left: 38.0, right: 38.0, bottom: 38.0),
            child: myPlan(context),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.only(
          //   topLeft: Radius.circular(12.0),
          //   topRight: Radius.circular(12.0)
          // ),
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
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: InkWell(
            child: Container(
              // width: ScreenUtil.getInstance().setWidth(330),
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
                  customBorder: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  onTap: () async {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.bottomToTop,
                        child: const ChangeHotspotPlan(),
                      ),
                    );
                  },
                  child: Center(
                    child: Text(
                      _lang.translate('change_plan'),
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
          ),
        ),
      ),
    );
  }

  Widget myPlan(BuildContext context) {
    final datePlan = DateFormat("yyyy MMM dd").parse(mPlan.timeLeft!);
    final DateTime now = DateTime.now();
    final DateTime toDayDate = DateTime(now.year, now.month, now.day);
    var different = datePlan.difference(toDayDate).inDays;
    var _lang = AppLocalizeService.of(context);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: const RenewOption(),
          ),
        );
      },
      child: Container(
        // width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height * .27,
        // padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(color: primaryColor.withOpacity(0.8), width: 1.5)
        ),
        child: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              SingleChildScrollView(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width / 0.25,
                    child: Center(
                      child: Text(
                        _lang.translate('hotspot'),
                        style: GoogleFonts.nunito(
                            textStyle: TextStyle(
                                color: primaryColor,
                                fontSize: 24,
                                fontWeight: FontWeight.w700)),
                      ),
                    )),
              ),
              Divider(
                thickness: 1.5,
                color: Colors.grey[300],
                indent: 20,
                endIndent: 20,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right: 35, left: 35),
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
                      '${mPlan.device} ${_lang.translate('devices')}',
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
                padding: const EdgeInsets.only(right: 35, left: 35),
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
                padding: const EdgeInsets.only(right: 35, left: 35),
                child: Row(
                  children: [
                    Text(
                      '${_lang.translate('plan')}:',
                      style: GoogleFonts.nunito(
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                    ),
                    Expanded(child: Container()),
                    Text(
                      '${mPlan.plan} ${_lang.translate('day')}',
                      style: GoogleFonts.nunito(
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 35, left: 35, top: 10),
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
                    mPlan.status == true
                        ? Text(
                            different == 0
                                ? 'Today'
                                : different == 1
                                    ? 'Tomorrow'
                                    : 'In ${different.toString()} Days',
                            style: GoogleFonts.nunito(
                                textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700)),
                          )
                        : Text(
                            _lang.translate('expired'),
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
                padding: const EdgeInsets.only(right: 35, left: 35),
                child: Row(
                  children: [
                    Text(
                      '${_lang.translate('valid_until')}:',
                      style: GoogleFonts.nunito(
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                    ),
                    Expanded(child: Container()),
                    Text(
                      mPlan.timeLeft!.split(' ').reversed.join(' '),
                      style: GoogleFonts.nunito(
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Divider(
                thickness: 1.5,
                color: Colors.grey[300],
                indent: 20,
                endIndent: 20,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(right: 0, left: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        mPlan.automatically == true
                            ? Icon(Icons.autorenew, color: primaryColor)
                            : Icon(Icons.touch_app_sharp, color: primaryColor),
                        const SizedBox(width: 10),
                        mPlan.automatically == true
                            ? Text(
                                '${_lang.translate('auto_renew_every')} \n${mPlan.plan} ${_lang.translate('day')}',
                                style: GoogleFonts.nunito(
                                    textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700)),
                              )
                            : Text(
                                _lang.translate('manual_renew'),
                                style: GoogleFonts.nunito(
                                    textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700)),
                              ),
                      ],
                    ),
                    Container(
                      height: 50,
                      width: 100,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          bottomLeft: Radius.circular(30.0),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          // '${mPlan.balance} RISE',
                          '${mPlan.balance} SEL',
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),
              mPlan.automatically == false && mPlan.status == false
                  ? renewButton(context)
                  : Container(),
              // SizedBox(height: 60),
            ],
          ),
          Positioned(
            left: 300,
            top: 15,
            child: IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: const RenewOption(),
                    ),
                  );
                }),
          ),
        ]),
      ),
    );
  }

  Widget renewButton(BuildContext context) {
    var _lang = AppLocalizeService.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 35, left: 35),
          child: InkWell(
            child: Container(
              // width: ScreenUtil.getInstance().setWidth(330),
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
                  onTap: () async {
                    _showDialogRenewPlan(context);
                  },
                  child: Center(
                    child: Text(
                      _lang.translate('renew'),
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
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Future<void> _showDialogRenewPlan(BuildContext context) async {
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
                            renewPlan(),
                            // Navigator.of(context).pop(),
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
