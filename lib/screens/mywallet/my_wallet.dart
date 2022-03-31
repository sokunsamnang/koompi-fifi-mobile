import 'dart:typed_data';
import 'dart:ui';

import 'package:koompi_hotspot/all_export.dart';
import 'package:koompi_hotspot/providers/contact_list_provider.dart';
import 'package:koompi_hotspot/screens/mywallet/quick_payment/contact_list.dart';
import 'package:path_provider/path_provider.dart';

class MyWallet extends StatefulWidget {
  final Function? resetState;
  final String walletKey;

  const MyWallet({Key? key, this.resetState, required this.walletKey}) : super(key: key);

  @override
  _MyWalletState createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  Future<bool> redirectNavbar() async {
    Navigator.pushAndRemoveUntil(
      context,
      PageTransition(
        type: PageTransitionType.leftToRight,
        child: const Navbar(0),
      ),
      ModalRoute.withName('/navbar'),
    );
    return true;
  }

  var appBarheight = 0.0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // var _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showSnackBar() {
    const snackBarContent = SnackBar(
      content: Text("Copied Address"),
    );

    // ignore: deprecated_member_use
    _scaffoldKey.currentState?.showSnackBar(snackBarContent);
  }
  
  @override
  void initState() {
    super.initState();
    // fetchWallet();
    AppServices.noInternetConnection(_scaffoldKey);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void fetchWallet() async {
    await Provider.of<BalanceProvider>(context, listen: false).fetchPortfolio();
    await Provider.of<TrxHistoryProvider>(context, listen: false).fetchTrxHistory();
  }

  @override
  Widget build(BuildContext context) {
    var _lang = AppLocalizeService.of(context);
    AppBar appBar = AppBar();
    appBarheight = appBar.preferredSize.height;

    return WillPopScope(
      onWillPop: redirectNavbar,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            'JAAY',
            style: GoogleFonts.robotoCondensed(
              fontSize: 24,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          backgroundColor: primaryColor.withOpacity(0.8), 
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          automaticallyImplyLeading: true,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  PageTransition(
                    type: PageTransitionType.leftToRight,
                    child: const Navbar(0),
                  ),
                  ModalRoute.withName('/navbar'),
                );
              }),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await Provider.of<BalanceProvider>(context, listen: false).fetchPortfolio();
            await Provider.of<TrxHistoryProvider>(context, listen: false).fetchTrxHistory();
            await Provider.of<ContactListProvider>(context, listen: false).fetchContactList();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                myBalance(context, showSnackBar),
                const SizedBox(
                  height: 6,
                ),
                walletAccount(context),
                // Container(
                //   height: 85.0,
                //   margin: const EdgeInsets.symmetric(
                //       horizontal: 10.0, vertical: 15.0),
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.stretch,
                //     children: <Widget>[
                //       Expanded(
                //         child: ElevatedButton(
                //           style: ElevatedButton.styleFrom(
                //             onPrimary: Colors.black87,
                //             primary: HexColor('083C5A'),
                //             elevation: 5,
                //             shape: const RoundedRectangleBorder(
                //               borderRadius:
                //                   BorderRadius.all(Radius.circular(12)),
                //             ),
                //           ),
                //           onPressed: () {
                //             _sendWalletBottomSheet(
                //                 context, widget.walletKey);
                //           },
                //           child: Padding(
                //             padding: const EdgeInsets.all(5.0),
                //             child: Column(
                //               children: <Widget>[
                //                 Image.asset('assets/images/send.png',
                //                     scale: 2),
                //                 Text(
                //                   _lang.translate('send_money'),
                //                   style: const TextStyle(
                //                     fontWeight: FontWeight.w700,
                //                     color: Colors.white,
                //                   ),
                //                 )
                //               ],
                //             ),
                //           ),
                //         ),
                //       ),
                //       const SizedBox(width: 20),
                //       Expanded(
                //         child: ElevatedButton(
                //           style: ElevatedButton.styleFrom(
                //             onPrimary: Colors.black87,
                //             primary: HexColor('083C5A'),
                //             elevation: 5,
                //             shape: const RoundedRectangleBorder(
                //               borderRadius:
                //                   BorderRadius.all(Radius.circular(12)),
                //             ),
                //           ),
                //           onPressed: () {
                //             Navigator.push(
                //                 context,
                //                 PageTransition(
                //                     type: PageTransitionType.rightToLeft,
                //                     child: const ReceiveRequest()));
                //           },
                //           child: Padding(
                //             padding: const EdgeInsets.all(5.0),
                //             child: Column(
                //               children: <Widget>[
                //                 Image.asset('assets/images/receive.png',
                //                     scale: 2),
                //                 Text(
                //                   _lang.translate('receive_money'),
                //                   style: const TextStyle(
                //                     fontWeight: FontWeight.w700,
                //                     color: Colors.white,
                //                   ),
                //                 )
                //               ],
                //             ),
                //           ),
                //         ),
                //       )
                //     ],
                //   ),
                // ),
                // Container(
                //   height: 85.0,
                //   margin: const EdgeInsets.symmetric(
                //       horizontal: 10.0, vertical: 15.0),
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.stretch,
                //     children: <Widget>[
                //       Expanded(
                //         child: ElevatedButton(
                //           style: ElevatedButton.styleFrom(
                //             onPrimary: Colors.black87,
                //             primary: HexColor('083C5A'),
                //             elevation: 5,
                //             shape: const RoundedRectangleBorder(
                //               borderRadius:
                //                   BorderRadius.all(Radius.circular(12)),
                //             ),
                //           ),
                //           onPressed: () {
                //             Navigator.push(
                //               context,
                //               PageTransition(
                //                 type: PageTransitionType.rightToLeft,
                //                 child: const TrxHistory(),
                //               ),
                //             );
                //           },
                //           child: Padding(
                //             padding: const EdgeInsets.all(5.0),
                //             child: Column(
                //               children: <Widget>[
                //                 Image.asset('assets/images/payment_history.png',
                //                     scale: 2),
                //                 const Text(
                //                   'Transcation History',
                //                   style: TextStyle(
                //                     fontWeight: FontWeight.w700,
                //                     color: Colors.white,
                //                   ),
                //                 )
                //               ],
                //             ),
                //           ),
                //         ),
                //       ),
                //       const SizedBox(width: 20),
                //       Expanded(
                //         child: ElevatedButton(
                //           style: ElevatedButton.styleFrom(
                //             onPrimary: Colors.black87,
                //             primary: HexColor('083C5A'),
                //             elevation: 5,
                //             shape: const RoundedRectangleBorder(
                //               borderRadius:
                //                   BorderRadius.all(Radius.circular(12)),
                //             ),
                //           ),
                //           onPressed: () async {
                //             Navigator.push(
                //                 context,
                //                 PageTransition(
                //                     type: PageTransitionType.rightToLeft,
                //                     child: const ContactListScreen()));
                //           },
                //           child: Padding(
                //             padding: const EdgeInsets.all(5.0),
                //             child: Column(
                //               children: <Widget>[
                //                 Image.asset('assets/images/contact.png',
                //                     scale: 2),
                //                 const Text(
                //                   'Quick Transfer',
                //                   style: TextStyle(
                //                     fontWeight: FontWeight.w700, 
                //                     color: Colors.white,
                //                   ),
                //                 )
                //               ],
                //             ),
                //           ),
                //         ),
                //       )
                //     ],
                //   ),
                // ),
              ],
            ),
          )
        ),
      ),
    );
  }

  Widget myBalance(BuildContext context, Function copyAddress) {
    var balance = Provider.of<BalanceProvider>(context);
    return Container(
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.8),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 3.25,
      
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              '${balance.balanceList[1].token!} ${balance.balanceList[1].symbol!}' ,
              style: GoogleFonts.robotoCondensed(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: InkWell(
              onTap: () {
                copyAddress();
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Text(
                  mData.wallet!,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: GoogleFonts.roboto(color: Colors.black.withOpacity(0.5)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        _qrBottomSheet(context);
                      },
                      child: Image.asset('assets/images/recieve.png', scale: 2),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(const CircleBorder(side: BorderSide(color: Colors.black))),
                        padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Receive',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black.withOpacity(0.75),
                        )
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _sendWalletBottomSheet(context, widget.walletKey);
                      },
                      child: Image.asset('assets/images/transfer.png', scale: 2),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(const CircleBorder(side: BorderSide(color: Colors.black))),
                        padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Transfer',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black.withOpacity(0.75),
                        )
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Image.asset('assets/images/swap.png', scale: 2),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(const CircleBorder(side: BorderSide(color: Colors.black))),
                        padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Swap',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black.withOpacity(0.75),
                        )
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      )
    );
  }

  Widget walletAccount(BuildContext context) {
    var balance = Provider.of<BalanceProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Wallet Account',
            style: GoogleFonts.robotoCondensed(
              fontSize: 25,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
              color: Colors.black,
            )
          ),
          Card(
            margin: const EdgeInsets.only(top: 15.0),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: primaryColor.withOpacity(0.8), width: 1.5),
              borderRadius: BorderRadius.circular(12.0)
            ),
            child: Column(
              children: <Widget>[
                ListTile(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10)),
                  ),
                  leading: Image.asset('assets/images/rise-coin-icon.png', width: 40, height: 40,),
                  title: Text(
                    balance.balanceList[0].symbol!,
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Text(
                    balance.balanceList[0].token!,
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () async {
                  }
                ),
                _buildDivider(),
                ListTile(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10)),
                  ),
                  leading: Image.asset('assets/images/sel-coin-icon.png', width: 40, height: 40,),
                  title: Text(
                    balance.balanceList[1].symbol!,
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Text(
                    balance.balanceList[1].token!,
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () async {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: const TrxHistory(),
                      ),
                    );
                  }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getTotalBalance(BuildContext context) {
    var balance = Provider.of<BalanceProvider>(context);
    var _lang = AppLocalizeService.of(context);
    return Container(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 22, bottom: 22),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          // color: Colors.grey[900],
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [HexColor('0F4471'), HexColor('083358')])),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _lang.translate('total_balance'),
            style: GoogleFonts.nunito(
                textStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Image.asset('assets/images/rise-coin-icon.png', width: 20),
              const SizedBox(width: 10),
              balance.balanceList[0].token == "Token Suspended" ||
                      balance.balanceList[0].token!.isEmpty
                  ? Text(
                      balance.balanceList[0].token!,
                      style: GoogleFonts.nunito(
                          fontSize: 18.0,
                          textStyle: const TextStyle(
                              color: Colors.red, fontWeight: FontWeight.w700)),
                    )
                  : Flexible(
                    child: Text(
                        balance.balanceList[0].token!,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunito(
                            fontSize: 18.0,
                            textStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                      ),
                  ),
              Text(
                ' ${balance.balanceList[0].symbol}',
                style: GoogleFonts.nunito(
                    fontSize: 18.0,
                    textStyle: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700)),
              )
            ],
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              Image.asset('assets/images/sel-coin-icon.png', width: 22),
              const SizedBox(width: 10),
              balance.balanceList[1].token == "Token Suspended" ||
                      balance.balanceList[1].token!.isEmpty
                  ? Text(
                      balance.balanceList[1].token!,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                          fontSize: 18.0,
                          textStyle: const TextStyle(
                              color: Colors.red, fontWeight: FontWeight.w700)),
                    )
                  : Flexible(
                    child: Text(
                        balance.balanceList[1].token!,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunito(
                            fontSize: 18.0,
                            textStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                      ),
                  ),
              Text(
                ' ${balance.balanceList[1].symbol}',
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunito(
                    fontSize: 18.0,
                    textStyle: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700)),
              )
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildDivider() {
  return Container(
    width: double.infinity,
    height: 1.5,
    color: primaryColor.withOpacity(0.8),
  );
}

void _qrBottomSheet(BuildContext context) {

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final GlobalKey _keyQrShare = GlobalKey();

  void showSnackBar() {
    const snackBarContent = SnackBar(
      content: Text("Copied Address"),
    );

    // ignore: deprecated_member_use
    _scaffoldkey.currentState?.showSnackBar(snackBarContent);
  }

  void copyWallet(String _wallet) {
    Clipboard.setData(
      ClipboardData(
        text: _wallet,
      ),
    );
  }

  void qrShare(GlobalKey globalKey, String _wallet) async {
    try {
      RenderRepaintBoundary? boundary = globalKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;
      var image = await boundary?.toImage(pixelRatio: 5.0);
      ByteData? byteData = await image?.toByteData(format: ImageByteFormat.png);
      Uint8List? pngBytes = byteData?.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = await File("${tempDir.path}/KOOMPI_HOTSPOT.png").create();
      await file.writeAsBytes(pngBytes!);
      Share.shareFiles([(file.path)], text: _wallet);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  showModalBottomSheet(
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(25)),
    ),
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      var _lang = AppLocalizeService.of(context);
      return Container(
        height: MediaQuery.of(context).size.height * 0.75,
        // width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RepaintBoundary(
              key: _keyQrShare,
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'RECEIVE',
                      style: GoogleFonts.robotoCondensed(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                          fontSize: 25,
                          fontWeight: FontWeight.w700
                        )
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Scan address to receive payment',
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    QrImage(
                      data: mData.wallet ?? '',
                      version: QrVersions.auto,
                      embeddedImage: const AssetImage('assets/images/SelendraQr.png'),
                      size: 250.0,
                      embeddedImageStyle: QrEmbeddedImageStyle(
                        size: const Size(50, 50),
                      ),
                    ),
                    Text(
                      mData.fullname ?? '',
                      style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                              color: primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Text(
                        mData.wallet!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(fontSize: 12, color: Colors.black.withOpacity(0.5)),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: InkWell(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onTap: () async {
                        copyWallet(mData.wallet!);
                        showSnackBar();
                      },
                      child: Center(
                        child: Text(
                          _lang.translate('copy'),
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          )),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.black87,
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    side: BorderSide(color: primaryColor.withOpacity(0.8), width: 1.5),
                  ),
                ),
                onPressed: () {
                  qrShare(_keyQrShare, mData.wallet!);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 15),
                  child: Text(
                    _lang.translate('share'),
                    style: GoogleFonts.nunito(
                        textStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    )),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  );
}

void _sendWalletBottomSheet(BuildContext context, String walletKey) {
  showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        var _lang = AppLocalizeService.of(context);
        return Container(
          height: 153,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12)),
          ),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: MyText(
                  top: 20,
                  bottom: 20,
                  text: _lang.translate('transaction_options'),
                  color: '#000000',
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.bottomToTop,
                                    child: const QrScanner(navigator: true)));
                      },
                      child: Column(
                        children: [
                          Icon(Icons.qr_code_scanner_outlined,
                              size: 35, color: primaryColor),
                          MyText(
                            top: 6,
                            text: _lang.translate('scan_qr'),
                            fontSize: 12,
                            color: '#000000',
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.bottomToTop,
                                child: SendRequest(walletKey, "", "")));
                      },
                      child: Column(
                        children: [
                          Icon(Icons.description_outlined,
                              size: 35, color: primaryColor),
                          MyText(
                              top: 6,
                              text: _lang.translate('fill_address'),
                              fontSize: 12,
                              color: '#000000')
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      });
}
