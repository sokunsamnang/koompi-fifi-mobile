import 'package:koompi_hotspot/all_export.dart';
import 'package:koompi_hotspot/screens/mywallet/wallet_settings/restore_key.dart';

class WalletChoice extends StatefulWidget {
  const WalletChoice({Key? key}) : super(key: key);

  // final Function onGetWallet;
  // final Function showAlertDialog;

  // WalletChoice(this.onGetWallet, this.showAlertDialog);

  @override
  _WalletChoiceState createState() => _WalletChoiceState();
}

class _WalletChoiceState extends State<WalletChoice> {
  String? alertText;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        // brightness: Brightness.light,
        title: Text(
          'Fi Wallet',
          style: GoogleFonts.robotoCondensed(
            textStyle: const TextStyle(
              color: Colors.black,
              fontStyle: FontStyle.italic,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            )
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(30.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/wallet.png',
                  ),
                ],
              ),
            ),
            
            Center(
              child: InkWell(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFF17ead9), Color(0xFF6078ea)]),
                    borderRadius: BorderRadius.circular(12),  
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onTap: () async {
                        // dialogLoading(context);
                        // var response = await GetRequest().getWallet();
                        // var responseJson = json.decode(response.body);
                        // if (response.statusCode == 200) {
                        //   await Components.dialog(
                        //       context,
                        //       textAlignCenter(text: responseJson['message']),
                        //       titleDialog());
                        //   await Provider.of<BalanceProvider>(context,
                        //           listen: false)
                        //       .fetchPortfolio();
                        //   await Provider.of<TrxHistoryProvider>(context,
                        //           listen: false)
                        //       .fetchTrxHistory();
                        //   StorageServices().read('token').then((value) async {
                        //     String _token = value!;
                        //     await GetRequest().getUserProfile(_token);
                        //   });
                        //   Timer(
                        //     const Duration(milliseconds: 500),
                        //     () => Navigator.pushAndRemoveUntil(
                        //           context,
                        //           PageTransition(
                        //             type: PageTransitionType
                        //                 .bottomToTop,
                        //             child: const Navbar(0),
                        //           ),
                        //           ModalRoute.withName('/navbar'),
                        //         ));
                        // } else {
                        //   await Components.dialog(
                        //       context,
                        //       textAlignCenter(text: responseJson['message']),
                        //       warningTitleDialog());
                        //   Navigator.pop(context);
                        //   Navigator.pop(context);
                        // }
                      },
                      child: const Center(
                        child: Text('Generate Wallet',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Poppins-Bold",
                            fontSize: 18,
                            letterSpacing: 1.0)
                          ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Center(
              child: InkWell(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),  
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onTap: () async {

                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.bottomToTop,
                            child: const RestoreKey(title: "Import",)
                          )
                        );
                        
                        // dialogLoading(context);
                        // var response = await GetRequest().getWallet();
                        // var responseJson = json.decode(response.body);
                        // if (response.statusCode == 200) {
                        //   await Components.dialog(
                        //       context,
                        //       textAlignCenter(text: responseJson['message']),
                        //       titleDialog());
                        //   await Provider.of<BalanceProvider>(context,
                        //           listen: false)
                        //       .fetchPortfolio();
                        //   await Provider.of<TrxHistoryProvider>(context,
                        //           listen: false)
                        //       .fetchTrxHistory();
                        //   StorageServices().read('token').then((value) async {
                        //     String _token = value!;
                        //     await GetRequest().getUserProfile(_token);
                        //   });
                        //   Timer(
                        //     const Duration(milliseconds: 500),
                        //     () => Navigator.pushAndRemoveUntil(
                        //           context,
                        //           PageTransition(
                        //             type: PageTransitionType
                        //                 .bottomToTop,
                        //             child: const Navbar(0),
                        //           ),
                        //           ModalRoute.withName('/navbar'),
                        //         ));
                        // } else {
                        //   await Components.dialog(
                        //       context,
                        //       textAlignCenter(text: responseJson['message']),
                        //       warningTitleDialog());
                        //   Navigator.pop(context);
                        //   Navigator.pop(context);
                        // }
                      },
                      child: Center(
                        child: Text('Import Wallet',
                          style: TextStyle(
                            color: primaryColor,
                            fontFamily: "Poppins-Bold",
                            fontSize: 18,
                            letterSpacing: 1.0
                          )
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
