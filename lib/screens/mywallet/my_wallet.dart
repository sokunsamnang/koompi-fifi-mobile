import 'package:koompi_hotspot/all_export.dart';
import 'package:koompi_hotspot/providers/contact_list_provider.dart';
import 'package:koompi_hotspot/screens/mywallet/quick_payment/contact_list.dart';

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
    await Provider.of<TrxHistoryProvider>(context, listen: false)
        .fetchTrxHistory();
  }

  @override
  Widget build(BuildContext context) {
    var _lang = AppLocalizeService.of(context);
    AppBar appBar = AppBar();
    appBarheight = appBar.preferredSize.height;

    return WillPopScope(
      onWillPop: redirectNavbar,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_lang.translate('my_wallet'),
              style:
                  const TextStyle(color: Colors.black, fontFamily: 'Medium')),
          backgroundColor: Colors.white,
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
        key: _scaffoldKey,
        body: RefreshIndicator(
          onRefresh: () async {
            await Provider.of<BalanceProvider>(context, listen: false).fetchPortfolio();
            await Provider.of<TrxHistoryProvider>(context, listen: false).fetchTrxHistory();
            await Provider.of<ContactListProvider>(context, listen: false).fetchContactList();
          },
          child: CustomScrollView(slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 10,
                      left: 10,
                    ),
                    child: getTotalBalance(context),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Container(
                    height: 85.0,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              onPrimary: Colors.black87,
                              primary: HexColor('083C5A'),
                              elevation: 5,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                            ),
                            onPressed: () {
                              _sendWalletBottomSheet(
                                  context, widget.walletKey);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: <Widget>[
                                  Image.asset('assets/images/send.png',
                                      scale: 2),
                                  Text(
                                    _lang.translate('send_money'),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              onPrimary: Colors.black87,
                              primary: HexColor('083C5A'),
                              elevation: 5,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: const ReceiveRequest()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: <Widget>[
                                  Image.asset('assets/images/receive.png',
                                      scale: 2),
                                  Text(
                                    _lang.translate('receive_money'),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 85.0,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              onPrimary: Colors.black87,
                              primary: HexColor('083C5A'),
                              elevation: 5,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: const TrxHistory(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: <Widget>[
                                  Image.asset('assets/images/payment_history.png',
                                      scale: 2),
                                  const Text(
                                    'Transcation History',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              onPrimary: Colors.black87,
                              primary: HexColor('083C5A'),
                              elevation: 5,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                            ),
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: const ContactListScreen()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: <Widget>[
                                  Image.asset('assets/images/contact.png',
                                      scale: 2),
                                  const Text(
                                    'Quick Transfer',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700, 
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
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

void _sendWalletBottomSheet(BuildContext context, String walletKey) {
  showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12)),
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
