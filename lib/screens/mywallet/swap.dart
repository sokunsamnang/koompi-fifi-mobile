import 'package:koompi_hotspot/all_export.dart';
import 'package:koompi_hotspot/providers/contact_list_provider.dart';
import 'package:koompi_hotspot/widgets/reuse_widgets/swap_token_widget.dart';
class SwapToken extends StatefulWidget {

  const SwapToken({Key? key}) : super(key: key);

  @override
  _SwapTokenState createState() => _SwapTokenState();
}

class _SwapTokenState extends State<SwapToken> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String asset = "";

  final List<SwapTokenModel> _swapTokenModelList = [
    SwapTokenModel(
      tokenName: 'SEL',
      imageToken: Image.asset(
        'assets/images/sel-coin-icon.png',
        width: 25,
      )
    ),
    SwapTokenModel(
      tokenName: 'LUY',
      imageToken: Image.asset(
        'assets/images/rise-coin-icon.png',
        width: 25,
      )
    ),
  ];

  SwapTokenModel _swapTokenModel = SwapTokenModel();
  List<DropdownMenuItem<SwapTokenModel>>? _swapTokenModelDropdownList;
  List<DropdownMenuItem<SwapTokenModel>> _buildTokenTypeModelDropdown(
      List tokenTypeModelList) {
    List<DropdownMenuItem<SwapTokenModel>> items = [];
    for (SwapTokenModel swapTokenModel in tokenTypeModelList) {
      items.add(DropdownMenuItem(
        value: swapTokenModel,
        child: Row(
          children: [
            swapTokenModel.imageToken!,
            const SizedBox(width: 10.0),
            Text(swapTokenModel.tokenName!),
          ],
        ),
      ));
    }
    return items;
  }

  _onChangetokenTypeModelDropdown(SwapTokenModel? swapTokenModel) {
    setState(() {
      _swapTokenModel = swapTokenModel!;
    });
  }

  int index = 0;


  @override
  void initState() {
    super.initState();
    // fetchWallet();
    AppServices.noInternetConnection(_scaffoldKey);

    // Value Dropdown
    _swapTokenModelDropdownList = _buildTokenTypeModelDropdown(_swapTokenModelList);
    _swapTokenModel = _swapTokenModelList[0];
    asset = _swapTokenModel.tokenName!;

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
            await Provider.of<TrxHistoryProvider>(context, listen: false)
                .fetchTrxHistory();
            await Provider.of<ContactListProvider>(context, listen: false)
                .fetchContactList();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: swapFrom(context),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: swapTo(context),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 100.0),
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
                          'Balance: ${balance.balanceList[1].token!}',
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
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,4}'))
                          ],
                          decoration: InputDecoration(
                            hintText: 'Enter amount',
                            hintStyle: GoogleFonts.robotoCondensed(
                              textStyle: TextStyle(
                                color: HexColor('000000').withOpacity(0.5),
                                fontSize: 20,
                                fontStyle: FontStyle.italic
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
                      // Expanded(
                      //   child: CustomBottomSheet(
                      //     dropdownMenuItemList: _swapTokenModelDropdownList,
                      //     onChanged: _onChangetokenTypeModelDropdown,
                      //     value: _swapTokenModel,
                      //     isEnabled: true,
                      //   ),
                      // ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: InkWell(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                _selectTokenBottomSheet(context);
                              },
                              child: Row(
                                children: [
                                  _swapTokenModel.imageToken!,
                                  Text(
                                    _swapTokenModel.tokenName!,
                                    style: GoogleFonts.robotoCondensed(
                                      textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontStyle: FontStyle.italic,  
                                        fontWeight: FontWeight.w700
                                      )
                                    ),
                                  ),
                                  const Icon(Icons.arrow_drop_down_sharp, color: Colors.black, size: 30),
                                ],
                              ),
                            ),
                          ),
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(''),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: InkWell(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                _selectTokenBottomSheet(context);
                              },
                              child: Row(
                                children: [
                                  _swapTokenModel.imageToken!,
                                  Text(
                                    _swapTokenModel.tokenName!,
                                    style: GoogleFonts.robotoCondensed(
                                      textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontStyle: FontStyle.italic,  
                                        fontWeight: FontWeight.w700
                                      )
                                    ),
                                  ),
                                  const Icon(Icons.arrow_drop_down_sharp, color: Colors.black, size: 30),
                                ],
                              ),
                            ),
                          ),
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

  void _selectTokenBottomSheet(BuildContext context) {

    showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(25)),
      ),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 2,
          // width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20.0),
          child: ListView.builder(
            itemCount: _swapTokenModelList.length,
            itemBuilder: (BuildContext context, int i) {  
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: primaryColor.withOpacity(0.8), width: 1.5),
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                  ),
                  leading: _swapTokenModelList[i].imageToken!,
                  title: Text(
                    _swapTokenModelList[i].tokenName!, 
                    style: GoogleFonts.robotoCondensed(
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700
                      )
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    setState(() {
                      _swapTokenModel = _swapTokenModelList[i];
                    });
                  },
                ),
              );
            },
          )
        );
      }
    );
  }

}