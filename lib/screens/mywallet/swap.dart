import 'package:koompi_hotspot/all_export.dart';
class SwapToken extends StatefulWidget {

  const SwapToken({Key? key}) : super(key: key);

  @override
  _SwapTokenState createState() => _SwapTokenState();
}

class _SwapTokenState extends State<SwapToken> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late Map<String, String> _from;
  late Map<String, String> _to;



  @override
  void initState() {
    super.initState();
    AppServices.noInternetConnection(_scaffoldKey);

    _from = {"Name": "SEL", "icon": "assets/images/sel-coin-icon.png"};
    _to = {"Name": "LUY", "icon": "assets/images/rise-coin-icon.png"};

  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'SWAP',
          style: GoogleFonts.robotoCondensed(
            fontSize: 24,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        automaticallyImplyLeading: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            await Provider.of<BalanceProvider>(context, listen: false)
                .fetchPortfolio();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: swapFrom(context),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shadowColor: primaryColor,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(10),
                      ),
                      child: RotatedBox(quarterTurns: 1,
                        child: Image.asset('assets/images/swap.png', width: 50, height: 50)
                      ),
                      onPressed: () {
                        var temp = _from;
                        setState(() {
                          _from = _to;
                          _to = temp;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: swapTo(context),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: summarySwap(context),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
                  child: swapButton(context),
                ),
              ],
            ),
          )
      ),
    );
  }

  Widget swapFrom(context) {
    var balance = Provider.of<BalanceProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Center(
        child: InkWell(
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: primaryColor.withOpacity(0.8), width: 1.5)
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'From',
                          style: GoogleFonts.robotoCondensed(
                            textStyle: TextStyle(
                              color: HexColor('000000').withOpacity(0.5),
                              fontSize: 20,
                              fontStyle: FontStyle.italic
                            )
                          ),
                        ),
                        Text(
                          _from['Name'] == "SEL" ? 'Balance: ${balance.balanceList[1].token!}' :
                          'Balance: ${balance.balanceList[0].token!}',
                          style: GoogleFonts.robotoCondensed(
                            textStyle: TextStyle(
                              color: HexColor('000000').withOpacity(0.5),
                              fontSize: 20,
                              fontStyle: FontStyle.italic
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  // buildDivider(),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,4}'))
                          ],
                          decoration: InputDecoration(
                            hintText: '0.00',
                            hintStyle: GoogleFonts.robotoCondensed(
                              textStyle: TextStyle(
                                color: HexColor('000000').withOpacity(0.5),
                                fontSize: 20,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w700
                              )
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          ),
                          style: GoogleFonts.robotoCondensed(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontStyle: FontStyle.italic
                            )
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Image.asset("${_from["icon"]}",width: 22,),
                              Text(
                                "${_from["Name"]}",
                                style: GoogleFonts.robotoCondensed(
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontStyle: FontStyle.italic,  
                                    fontWeight: FontWeight.w700
                                  )
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              )
            ),
          ),
        )
      ),
    );
  }


  Widget swapTo(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Center(
        child: InkWell(
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: primaryColor.withOpacity(0.8), width: 1.5)
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'To',
                          style: GoogleFonts.robotoCondensed(
                            textStyle: TextStyle(
                              color: HexColor('000000').withOpacity(0.5),
                              fontSize: 20,
                              fontStyle: FontStyle.italic
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '',
                            style: GoogleFonts.robotoCondensed(
                              textStyle: TextStyle(
                                color: HexColor('000000').withOpacity(0.5),
                                fontSize: 20,
                                fontStyle: FontStyle.italic
                              )
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Image.asset("${_to["icon"]}",width: 22,),
                              Text(
                                "${_to["Name"]}",
                                style: GoogleFonts.robotoCondensed(
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontStyle: FontStyle.italic,  
                                    fontWeight: FontWeight.w700
                                  )
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ),
          ),
        )
      ),
    );
  }

  Widget summarySwap(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: primaryColor.withOpacity(0.25),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Summary',
                    style: GoogleFonts.robotoCondensed(
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500
                      )
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.50),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Price',
                              style: GoogleFonts.robotoCondensed(
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500
                                )
                              ),
                            ),
                            Text(
                              '--',
                              style: GoogleFonts.robotoCondensed(
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700
                                )
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Swap Fee',
                              style: GoogleFonts.robotoCondensed(
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500
                                )
                              ),
                            ),
                            Text(
                              '0.0001 SEL',
                              style: GoogleFonts.robotoCondensed(
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700
                                )
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ),
              ),
            ),
          ],
        )
      ),
    );
  }

  Widget swapButton(BuildContext context){
    return InkWell(
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF17ead9), Color(0xFF6078ea)]),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              
            },
            child: Center(
              child: Text(
                'SWAP',
                style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700
                  )
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget chooseToken(BuildContext context) {
    return InkWell(
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF17ead9), Color(0xFF6078ea)]),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              
            },
            child: Center(
              child: Text(
                'SWAP',
                style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700
                  )
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}