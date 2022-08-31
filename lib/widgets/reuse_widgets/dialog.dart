import 'package:koompi_hotspot/all_export.dart';

final primaryColor = HexColor('0CACDA');

Widget textAlignCenter({String text = ""}) {
  return Text(text, textAlign: TextAlign.center);
}

Widget warningTitleDialog() {
  return const Text(
    'Oops...',
    style: TextStyle(fontWeight: FontWeight.bold),
  );
}

Widget titleDialog() {
  return const Text(
    'Congratulation...!',
    style: TextStyle(fontWeight: FontWeight.bold),
  );
}

class Components {
  static Future dialogNoOption(BuildContext context, var text, var title,
      {Widget? action,
      // String firsTxtBtn = "OK",
      Color bgColor = Colors.white,
      bool removeBtn = false,
      double pLeft = 10,
      double pRight = 10,
      double pTop = 15.0,
      double pBottom = 5}) async {
    var result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context2, setState) {
            return AlertDialog(
              backgroundColor: bgColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              contentPadding: EdgeInsets.only(
                  left: pLeft, top: pTop, right: pRight, bottom: pBottom),
              title: title != null
                  ? Align(
                      alignment: Alignment.center,
                      child: title,
                    )
                  : null,
              content: text,
              actions: !removeBtn ? <Widget>[action ?? Container()] : null,
            );
          });
        });
    return result;
  }

  /* Dialog of response from server */
  static Future dialog(BuildContext context, var text, var title,
      {Widget? action,
      String firsTxtBtn = "OK",
      Color bgColor = Colors.white,
      bool removeBtn = false,
      double pLeft = 10,
      double pRight = 10,
      double pTop = 15.0,
      double pBottom = 5}) async {
    var result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context2, setState) {
            return AlertDialog(
              backgroundColor: bgColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              contentPadding: EdgeInsets.only(
                  left: pLeft, top: pTop, right: pRight, bottom: pBottom),
              title: title != null
                  ? Align(
                      alignment: Alignment.center,
                      child: title,
                    )
                  : null,
              content: text,
              actions: !removeBtn
                  ? <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  HexColor('0CACDA')),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              )),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 50)),
                            ),
                            child: Text(firsTxtBtn),
                            onPressed: () => Navigator.of(context).pop(text),
                          ),
                        ],
                      ),
                      action ?? Container()
                    ]
                  : null,
            );
          });
        });
    return result;
  }

  static Future dialogSignOut(BuildContext context, var text, var title,
      {Widget? action,
      String firsTxtBtn = "OK",
      String secTxtBtn = "CANCEL",
      Color bgColor = Colors.white,
      bool removeBtn = false,
      double pLeft = 10,
      double pRight = 10,
      double pTop = 15.0,
      double pBottom = 5}) async {
    var result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context2, setState) {
            return AlertDialog(
              backgroundColor: bgColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              contentPadding: EdgeInsets.only(
                  left: pLeft, top: pTop, right: pRight, bottom: pBottom),
              title: title != null
                  ? Align(
                      alignment: Alignment.center,
                      child: title,
                    )
                  : null,
              content: text,
              actions: !removeBtn
                  ? <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  HexColor('0CACDA')),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 35)),
                            ),
                            child: Text(secTxtBtn),
                            onPressed: () => Navigator.of(context).pop(text),
                          ),
                          TextButton(
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        HexColor('0CACDA')),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                )),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 50)),
                              ),
                              child: Text(firsTxtBtn),
                              onPressed: () async {
                                dialogLoading(context);
                                await StorageServices().deleteKeys('token');
                                await StorageServices().deleteKeys('phone');
                                await StorageServices().deleteKeys('password');
                                Timer(
                                  const Duration(milliseconds: 500),
                                  () => Navigator.pushAndRemoveUntil(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType
                                              .bottomToTop,
                                          child: const LoginPhone(),
                                        ),
                                        ModalRoute.withName('/loginPhone'),
                                      ));
                              }),
                        ],
                      ),
                      action ?? Container()
                    ]
                  : null,
            );
          });
        });
    return result;
  }

  static Future confirmMnemonicDialog(BuildContext context, var text, var title,
      {Widget? action,
      String firsTxtBtn = "OK",
      String secTxtBtn = "CANCEL",
      Color bgColor = Colors.white,
      bool removeBtn = false,
      double pLeft = 10,
      double pRight = 10,
      double pTop = 15.0,
      double pBottom = 5}) async {
    var result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context2, setState) {
            return AlertDialog(
              backgroundColor: bgColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              contentPadding: EdgeInsets.only(
                  left: pLeft, top: pTop, right: pRight, bottom: pBottom),
              title: title != null
                  ? Align(
                      alignment: Alignment.center,
                      child: title,
                    )
                  : null,
              content: text,
              actions: !removeBtn
                  ? <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  HexColor('0CACDA')),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 35)),
                            ),
                            child: Text(secTxtBtn),
                            onPressed: () => Navigator.of(context).pop(text),
                          ),
                          TextButton(
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        HexColor('0CACDA')),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                )),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 50)),
                              ),
                              child: Text(firsTxtBtn),
                              onPressed: () async {
                                Navigator.of(context).pop(text);
                              }),
                        ],
                      ),
                      action ?? Container()
                    ]
                  : null,
            );
          });
        });
    return result;
  }

  static Future dialogResetPw(BuildContext context, var text, var title,
      {Widget? action,
      String firsTxtBtn = "OK",
      Color bgColor = Colors.white,
      bool removeBtn = false,
      double pLeft = 10,
      double pRight = 10,
      double pTop = 15.0,
      double pBottom = 5}) async {
    var result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context2, setState) {
            return AlertDialog(
              backgroundColor: bgColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              contentPadding: EdgeInsets.only(
                  left: pLeft, top: pTop, right: pRight, bottom: pBottom),
              title: title != null
                  ? Align(
                      alignment: Alignment.center,
                      child: title,
                    )
                  : null,
              content: text,
              actions: !removeBtn
                  ? <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        HexColor('0CACDA')),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                )),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 50)),
                              ),
                              child: Text(firsTxtBtn),
                              onPressed: () async {
                                dialogLoading(context);
                                Timer(
                                  const Duration(milliseconds: 500),
                                  () => Navigator.pushAndRemoveUntil(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType
                                              .bottomToTop,
                                          child: const LoginPhone(),
                                        ),
                                        ModalRoute.withName('/loginPhone'),
                                      ));
                              }),
                        ],
                      ),
                      action ?? Container()
                    ]
                  : null,
            );
          });
        });
    return result;
  }

  static Future dialogUpdateApp(BuildContext context, var text, var title,
      {Widget? action,
      String? firsTxtBtn,
      Color bgColor = Colors.white,
      bool removeBtn = false,
      double pLeft = 10,
      double pRight = 10,
      double pTop = 15.0,
      double pBottom = 5,
      CallbackAction? callbackAction}) async {
    var lang = AppLocalizeService.of(context);
    var result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context2, setState) {
            return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                backgroundColor: bgColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                contentPadding: EdgeInsets.only(
                    left: pLeft, top: pTop, right: pRight, bottom: pBottom),
                title: title != null
                    ? Align(
                        alignment: Alignment.center,
                        child: title,
                      )
                    : null,
                content: text,
                actions: !removeBtn
                    ? <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          HexColor('0CACDA')),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  )),
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 50)),
                                ),
                                child: Text(lang.translate('btn_update')),
                                onPressed: () => {callbackAction}),
                          ],
                        ),
                        action ?? Container()
                      ]
                    : null,
              ),
            );
          });
        });
    return result;
  }

  static Future dialogGPS(
    BuildContext context,
    var text,
    var title, {
    Widget? action,
    String firsTxtBtn = "OK",
    String secTxtBtn = "CANCEL",
    Color bgColor = Colors.white,
    bool removeBtn = false,
    double pLeft = 10,
    double pRight = 10,
    double pTop = 15.0,
    double pBottom = 5,
  }) async {
    var result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context2, setState) {
            return AlertDialog(
              backgroundColor: bgColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              contentPadding: EdgeInsets.only(
                  left: pLeft, top: pTop, right: pRight, bottom: pBottom),
              title: title != null
                  ? Align(
                      alignment: Alignment.center,
                      child: title,
                    )
                  : null,
              content: text,
              actions: !removeBtn
                  ? <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  HexColor('0CACDA')),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 35)),
                            ),
                            child: Text(secTxtBtn),
                            onPressed: () => Navigator.of(context).pop(text),
                          ),
                          TextButton(
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        HexColor('0CACDA')),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                )),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 50)),
                              ),
                              child: Text(firsTxtBtn),
                              onPressed: () => {
                                    AppSettings.openLocationSettings(),
                                    Navigator.of(context).pop(),
                                  }),
                        ],
                      ),
                      action ?? Container()
                    ]
                  : null,
            );
          });
        });
    return result;
  }

  static Future<String> dialogPassword(
    BuildContext context,
    var text,
    var title, {
    Widget? action,
    String firsTxtBtn = "OK",
    String secTxtBtn = "CANCEL",
    Color bgColor = Colors.white,
    bool removeBtn = false,
    double pLeft = 10,
    double pRight = 10,
    double pTop = 15.0,
    double pBottom = 5,
    var actionFirstBtn,
    var actionSecBtn,
  }) async {
    var result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context2, setState) {
            return AlertDialog(
              backgroundColor: bgColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              contentPadding: EdgeInsets.only(
                  left: pLeft, top: pTop, right: pRight, bottom: pBottom),
              title: title != null
                  ? Align(
                      alignment: Alignment.center,
                      child: title,
                    )
                  : null,
              content: text,
              actions: !removeBtn
                  ? <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        HexColor('0CACDA')),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 35)),
                              ),
                              child: Text(secTxtBtn),
                              onPressed: () => {
                                    actionSecBtn,
                                    Navigator.of(context).pop(text),
                                  }),
                          TextButton(
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        HexColor('0CACDA')),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                )),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 50)),
                              ),
                              child: Text(firsTxtBtn),
                              onPressed: () => {
                                    actionFirstBtn,
                                    Navigator.of(context).pop(),
                                    Navigator.pop(context),
                                  }),
                        ],
                      ),
                      action ?? Container()
                    ]
                  : null,
            );
          });
        });
    return result;
  }
}

class ItemList extends StatelessWidget {
  final String? title;
  final String? trailing;

  const ItemList({Key? key, this.title, this.trailing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 80,
              child: Text(
                "$title: ",
                textAlign: TextAlign.left,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(trailing!, style: const TextStyle(fontSize: 13)),
            )),
          ],
        ));
  }
}

/* Progress */
Widget progress({String? content}) {
  return Material(
    color: Colors.transparent,
    child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const CircularProgressIndicator(
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation(Colors.blueAccent)),
            content == null
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                    child: textScale(text: content, hexaColor: "#FFFFFF")),
          ],
        )
      ],
    ),
  );
}

void dialogLoading(BuildContext context, {String? content}) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          child: progress(content: content),
          onWillPop: () async {
            return false;
          },
        );
      });
}

Widget textScale(
    {String? text,
    double fontSize = 18.0,
    String hexaColor = "#1BD2FA",
    TextDecoration? underline,
    BoxFit fit = BoxFit.contain,
    FontWeight? fontWeight}) {
  return FittedBox(
    fit: fit,
    child: Text(
      text!,
      style: TextStyle(
          color: Colors.blueAccent,
          decoration: underline,
          fontSize: fontSize,
          fontWeight: fontWeight),
    ),
  );
}

Widget buildDivider() {
  return Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey.shade400,
  );
}
