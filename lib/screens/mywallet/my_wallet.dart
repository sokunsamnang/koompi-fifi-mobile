import 'dart:typed_data';
import 'dart:ui';
import 'package:koompi_hotspot/all_export.dart';
import 'package:koompi_hotspot/providers/contact_list_provider.dart';
import 'package:koompi_hotspot/screens/mywallet/quick_payment/contact_list.dart';
import 'package:path_provider/path_provider.dart';

class MyWallet extends StatefulWidget {
  final String walletKey;

  const MyWallet({Key? key, required this.walletKey}) : super(key: key);

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
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Copied Address"),
      behavior: SnackBarBehavior.floating,
    ));
  }

  void comingSoonSnackBar() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Coming Soon!"),
      behavior: SnackBarBehavior.floating,
    ));
  }

  void copyWallet(String _wallet) {
    Clipboard.setData(
      ClipboardData(
        text: _wallet,
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    // fetchWallet();
    // Provider.of<BalanceProvider>(context, listen: false).fetchPortfolio();
    AppServices.noInternetConnection(_scaffoldKey);
  }

  @override
  void dispose() {
    super.dispose();
  }


  Future<void> fetchWallet() async {
    await Provider.of<BalanceProvider>(context, listen: false).fetchPortfolio();
    await Provider.of<TrxHistoryProvider>(context, listen: false).fetchTrxHistory();
    await Provider.of<ContactListProvider>(context, listen: false).fetchContactList();
  }

  @override
  Widget build(BuildContext context) {
    var _balance = Provider.of<BalanceProvider>(context);
    AppBar appBar = AppBar();
    appBarheight = appBar.preferredSize.height;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Fi Wallet',
          style: GoogleFonts.robotoCondensed(
            fontSize: 24,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor.withOpacity(0.8), 
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async{
          if(mounted){
            await Provider.of<BalanceProvider>(context, listen: false).fetchPortfolio();
            await Provider.of<TrxHistoryProvider>(context, listen: false).fetchTrxHistory();
            await Provider.of<ContactListProvider>(context, listen: false).fetchContactList();
          }
        },
        child: _balance.balanceList.isNotEmpty ? SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                myBalance(context, showSnackBar, copyWallet),
                const SizedBox(
                  height: 6,
                ),
                walletAccount(context),
              ],
            ),
          ),
        )
        :
        SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 1.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/images/server-down.svg', height: MediaQuery.of(context).size.height / 5,),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Something went wrong! Please try again later.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.robotoCondensed(
                      fontSize: 21, 
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }

  Widget myBalance(BuildContext context, Function showSnackBar, Function copyAddress) {
    var _balance = Provider.of<BalanceProvider>(context);
    return Container(
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.8),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      // width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height / 3.25,
      
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              '${_balance.balanceList[0].token!} ${_balance.balanceList[0].symbol!}' ,
              style: GoogleFonts.robotoCondensed(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.5,
            child: InkWell(
              onTap: () {
                copyAddress(mData.wallet!);
                showSnackBar();
                
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.black),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${mData.wallet!.substring(0, 11)}'
                      '\u2026'
                      '${mData.wallet!.substring(mData.wallet!.length - 11)}',
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: GoogleFonts.roboto(color: Colors.black.withOpacity(0.5)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.content_copy,
                      color: primaryColor.withOpacity(0.8),
                      size: 20,
                    ),
                  ],
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
                        _qrBottomSheet(context, showSnackBar, copyWallet);
                      },
                      child: Image.asset('assets/images/recieve.png', scale: 2),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(const CircleBorder()),
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
                          color: Colors.white,
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
                        shape: MaterialStateProperty.all(const CircleBorder()),
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
                          color: Colors.white,
                        )
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        comingSoonSnackBar();
                        // Navigator.push(
                        //     context,
                        //     PageTransition(
                        //       type: PageTransitionType.rightToLeft,
                        //       child: const SwapToken(),
                        //     )
                        // );
                      },
                      child: Image.asset('assets/images/swap.png', scale: 2),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(const CircleBorder()),
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
                          color: Colors.white,
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
    var _balance = Provider.of<BalanceProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Assets',
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
                  leading: Image.asset('assets/images/sel-coin-icon.png', width: 40, height: 40,),
                  title: Text(
                    _balance.balanceList[0].symbol!,
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Text(
                    _balance.balanceList[0].token!,
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: const TrxHistory(),
                      ),
                    );
                  }
                ),
                _buildDivider(),
                ListTile(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10)),
                  ),
                  leading: Image.asset('assets/images/Luy-coin.png', width: 40, height: 40,),
                  title: Text(
                    _balance.balanceList[1].symbol!,
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Text(
                    _balance.balanceList[1].token!,
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () async {
                    comingSoonSnackBar();
                  }
                ),
                _buildDivider(),
                ListTile(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10)),
                  ),
                  leading: Image.asset('assets/images/KSD-coin.png', width: 40, height: 40,),
                  title: Text(
                    _balance.balanceList[2].symbol!,
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Text(
                    _balance.balanceList[2].token!,
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () async {
                    comingSoonSnackBar();
                  }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget getTotalBalance(BuildContext context) {
  //   var balance = Provider.of<BalanceProvider>(context);
  //   var _lang = AppLocalizeService.of(context);
  //   return Container(
  //     padding: const EdgeInsets.only(right: 20, left: 20, top: 22, bottom: 22),
  //     decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(12.0),
  //         // color: Colors.grey[900],
  //         gradient: LinearGradient(
  //             begin: Alignment.centerLeft,
  //             end: Alignment.centerRight,
  //             colors: [HexColor('0F4471'), HexColor('083358')])),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           _lang.translate('total_balance'),
  //           style: GoogleFonts.nunito(
  //               textStyle: const TextStyle(
  //                   color: Colors.white, fontWeight: FontWeight.w700)),
  //         ),
  //         const SizedBox(height: 5),
  //         Row(
  //           children: [
  //             Image.asset('assets/images/rise-coin-icon.png', width: 20),
  //             const SizedBox(width: 10),
  //             balance.balanceList[0].token == "Token Suspended" ||
  //                     balance.balanceList[0].token!.isEmpty
  //                 ? Text(
  //                     balance.balanceList[0].token!,
  //                     style: GoogleFonts.nunito(
  //                         fontSize: 18.0,
  //                         textStyle: const TextStyle(
  //                             color: Colors.red, fontWeight: FontWeight.w700)),
  //                   )
  //                 : Flexible(
  //                   child: Text(
  //                       balance.balanceList[0].token!,
  //                       overflow: TextOverflow.ellipsis,
  //                       style: GoogleFonts.nunito(
  //                           fontSize: 18.0,
  //                           textStyle: const TextStyle(
  //                               color: Colors.white,
  //                               fontWeight: FontWeight.w700)),
  //                     ),
  //                 ),
  //             Text(
  //               ' ${balance.balanceList[0].symbol}',
  //               style: GoogleFonts.nunito(
  //                   fontSize: 18.0,
  //                   textStyle: const TextStyle(
  //                       color: Colors.white, fontWeight: FontWeight.w700)),
  //             )
  //           ],
  //         ),
  //         const SizedBox(height: 7),
  //         Row(
  //           children: [
  //             Image.asset('assets/images/sel-coin-icon.png', width: 22),
  //             const SizedBox(width: 10),
  //             balance.balanceList[1].token == "Token Suspended" ||
  //                     balance.balanceList[1].token!.isEmpty
  //                 ? Text(
  //                     balance.balanceList[1].token!,
  //                     overflow: TextOverflow.ellipsis,
  //                     style: GoogleFonts.nunito(
  //                         fontSize: 18.0,
  //                         textStyle: const TextStyle(
  //                             color: Colors.red, fontWeight: FontWeight.w700)),
  //                   )
  //                 : Flexible(
  //                   child: Text(
  //                       balance.balanceList[1].token!,
  //                       overflow: TextOverflow.ellipsis,
  //                       style: GoogleFonts.nunito(
  //                           fontSize: 18.0,
  //                           textStyle: const TextStyle(
  //                               color: Colors.white,
  //                               fontWeight: FontWeight.w700)),
  //                     ),
  //                 ),
  //             Text(
  //               ' ${balance.balanceList[1].symbol}',
  //               overflow: TextOverflow.ellipsis,
  //               style: GoogleFonts.nunito(
  //                   fontSize: 18.0,
  //                   textStyle: const TextStyle(
  //                       color: Colors.white, fontWeight: FontWeight.w700)),
  //             )
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

}

Widget _buildDivider() {
  return Container(
    width: double.infinity,
    height: 1.5,
    color: primaryColor.withOpacity(0.8),
  );
}

void _qrBottomSheet(BuildContext context, Function showSnackBar, Function copyWallet) {

  final GlobalKey<ScaffoldState> _modelScaffoldKey = GlobalKey<ScaffoldState>();
  // final GlobalKey _keyQrShare = GlobalKey();


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
    builder: (_) {
      var _lang = AppLocalizeService.of(context);
      return Container(
        key: _modelScaffoldKey,
        height: MediaQuery.of(context).size.height * 0.75,
        // width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RepaintBoundary(
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
                      mData.fullname ?? 'Guest',
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
                      gradient: const LinearGradient(colors: [
                        Color(0xFF17ead9),
                        Color(0xFF6078ea)
                      ]),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            color:
                                const Color(0xFF6078ea).withOpacity(.3),
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
                        copyWallet(mData.wallet!);
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        // showSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Copied Address"),
                          behavior: SnackBarBehavior.floating,
                        ));
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
                  qrShare(_modelScaffoldKey, mData.wallet!);
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
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.bottomToTop,
                                child: const ContactListScreen()));
                      },
                      child: Column(
                        children: [
                          Icon(Icons.payments_outlined,
                              size: 35, color: primaryColor),
                          const MyText(
                              top: 6,
                              text: 'Quick Transfer',
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
