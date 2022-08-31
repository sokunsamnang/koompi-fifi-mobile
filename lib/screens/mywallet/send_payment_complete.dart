import 'package:koompi_hotspot/all_export.dart';
import 'package:lottie/lottie.dart';

class CompletePayment extends StatefulWidget {
  const CompletePayment({Key? key}) : super(key: key);

  @override
  CompletePaymentState createState() => CompletePaymentState();
}

class CompletePaymentState extends State<CompletePayment> {
  Future<bool> redirectNavbar() async {
    Navigator.pushAndRemoveUntil(
      context,
      PageTransition(
        type: PageTransitionType.bottomToTop,
        child: const Navbar(0),
      ),
      ModalRoute.withName('/navbar'),
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizeService.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(lang.translate('complete'),
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
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: redirectNavbar,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(
                      width: 300,
                      height: 300,
                      child: Lottie.asset(
                        'assets/animations/check-animation.json',
                        repeat: false,
                      ),
                    ),
                    Center(
                      child: Text(
                        lang.translate('payment_complete'),
                        style: const TextStyle(
                            fontFamily: 'Medium',
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ),
                    const SizedBox(height: 100.0),
                    Center(
                      child: InkWell(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 25.0),
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
                                dialogLoading(context);
                                await Provider.of<BalanceProvider>(context,listen: false).fetchPortfolio();

                                if (!mounted) return;
                                await Provider.of<TrxHistoryProvider>(context,listen: false).fetchTrxHistory();
                                Timer(
                                    const Duration(milliseconds: 1),
                                    () => Navigator.pushAndRemoveUntil(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType
                                                .bottomToTop,
                                            child: const Navbar(0),
                                          ),
                                          ModalRoute.withName('/navbar'),
                                        ));
                              },
                              child: Center(
                                child: Text(lang.translate('home'),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Poppins-Bold",
                                        fontSize: 18,
                                        letterSpacing: 1.0)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
