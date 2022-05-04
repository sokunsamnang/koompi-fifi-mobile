import 'package:koompi_hotspot/all_export.dart';

class TransactionDetail extends StatefulWidget {
  final List<TrxHistoryModel> history;
  final int index;
  const TransactionDetail(
      {Key? key, required this.history, required this.index})
      : super(key: key);
  @override
  _TransactionDetailState createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {
  final double circleRadius = 100.0;
  final double circleBorderWidth = 8.0;

  @override
  Widget build(BuildContext context) {
    var history = widget.history;
    var i = widget.index;
    var _lang = AppLocalizeService.of(context);

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Text('Transaction Details',
          style: GoogleFonts.robotoCondensed(
            textStyle: const TextStyle(
              color: Colors.white,
              fontStyle: FontStyle.italic,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            )
          ),
        ),
        backgroundColor: primaryColor.withOpacity(0.8),
        centerTitle: true,
        elevation: 0,
        shadowColor: primaryColor.withOpacity(0.8),
        automaticallyImplyLeading: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                // background image and bottom contents
                Column(
                  children: <Widget>[
                    Container(
                      height: 75.0,
                      color: primaryColor.withOpacity(0.8),
                    ),
                    Container(
                      color: Colors.white,
                    ),
                    const SizedBox(
                      height: 45.0,
                    ),
                    mData.wallet == history[i].destination
                        ? Text(
                            _lang.translate('recieved'),
                            style: GoogleFonts.nunito(
                                textStyle: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w700)),
                          )
                        : Text(
                            _lang.translate('sent'),
                            style: GoogleFonts.nunito(
                                textStyle: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700)),
                          ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 25.0, left: 25.0, bottom: 38),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 30.0,
                          ),

                          //========= Date & Time Transaction =========
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Date',
                                    style: GoogleFonts.nunito(
                                        textStyle: TextStyle(
                                            color: HexColor('0CACDA'),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  Text(
                                    AppUtils.timeStampToDate(
                                        history[i].datetime!),
                                    style: GoogleFonts.nunito(
                                        textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Time',
                                    style: GoogleFonts.nunito(
                                        textStyle: TextStyle(
                                            color: HexColor('0CACDA'),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  Text(
                                    AppUtils.timeStampToTime(
                                        history[i].datetime!),
                                    style: GoogleFonts.nunito(
                                        textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Divider(
                            thickness: 1.5,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(
                            height: 15,
                          ),

                          //========= Amount Transaction =========
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Amount (${history[i].symbol})',
                                style: GoogleFonts.nunito(
                                    textStyle: TextStyle(
                                        color: HexColor('0CACDA'),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                              ),
                              Row(
                                children: [
                                  history[i].symbol == 'SEL'
                                      ? Image.asset(
                                          'assets/images/sel-coin-icon.png',
                                          width: 22)
                                      : Image.asset(
                                          'assets/images/rise-coin-icon.png',
                                          width: 22),
                                  const SizedBox(width: 5),
                                  Text(
                                    '${history[i].amount} ${history[i].symbol}',
                                    style: GoogleFonts.nunito(
                                        textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ],
                              )
                            ],
                          ),

                          // SizedBox(
                          //   height: 15,
                          // ),
                          // //========= Fee Transaction =========
                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   children: [
                          //     Text(
                          //       'Fee (SEL)',
                          //       style: GoogleFonts.nunito(
                          //       textStyle: TextStyle(color: HexColor('0CACDA'), fontSize: 15, fontWeight: FontWeight.w600)
                          //       ),
                          //     ),
                          //     Row(
                          //       children: [
                          //         Image.asset('assets/images/sld.png', width: 15,),
                          //         SizedBox(width: 5),
                          //         Text(
                          //           history[i].fee+ " SEL",
                          //           style: GoogleFonts.nunito(
                          //           textStyle: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400)
                          //           ),
                          //         ),
                          //       ]
                          //     )
                          //   ],
                          // ),

                          const SizedBox(
                            height: 5,
                          ),
                          Divider(
                            thickness: 1.5,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(
                            height: 15,
                          ),

                          //========= Transaction ID =========
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Transaction Hash ID',
                                style: GoogleFonts.nunito(
                                    textStyle: TextStyle(
                                        color: HexColor('0CACDA'),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                              ),
                              Text(
                                history[i].hash!,
                                style: GoogleFonts.nunito(
                                    textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 15,
                          ),
                          //========= Sender ID =========
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'From',
                                style: GoogleFonts.nunito(
                                    textStyle: TextStyle(
                                        color: HexColor('0CACDA'),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                              ),
                              Text(
                                history[i].sender! +
                                    (history[i].from != null
                                        ? ' (${history[i].from})'
                                        : ''),
                                style: GoogleFonts.nunito(
                                    textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          //========= Reciever ID =========
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'To',
                                style: GoogleFonts.nunito(
                                    textStyle: TextStyle(
                                        color: HexColor('0CACDA'),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                              ),
                              Text(
                                history[i].destination! +
                                    (history[i].to != null
                                        ? ' (${history[i].to})'
                                        : ''),
                                style: GoogleFonts.nunito(
                                    textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ],
                          ),

                          history[i].memo != ""
                              ? const SizedBox(
                                  height: 15,
                                )
                              : Container(),
                          // Memo
                          history[i].memo != ""
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Memo',
                                      style: GoogleFonts.nunito(
                                          textStyle: TextStyle(
                                              color: HexColor('0CACDA'),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                    Text(
                                      history[i].memo!,
                                      style: GoogleFonts.nunito(
                                          textStyle: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                  ],
                                )
                              : Container(),

                          const SizedBox(
                            height: 25,
                          ),
                          //========= Repeat or Return Button =========
                          // mData.wallet == history[i].destination
                          //     ? SizedBox(
                          //         width: MediaQuery.of(context).size.width,
                          //         child: ElevatedButton(
                          //           style: ElevatedButton.styleFrom(
                          //             onPrimary: Colors.white,
                          //             primary: HexColor('0CACDA'),
                          //             elevation: 2.5,
                          //             shape: const RoundedRectangleBorder(
                          //               borderRadius: BorderRadius.all(
                          //                   Radius.circular(12)),
                          //             ),
                          //           ),
                          //           onPressed: () {
                          //             Navigator.push(
                          //               context,
                          //               PageTransition(
                          //                 type: PageTransitionType.bottomToTop,
                          //                 child: SendRequest(
                          //                     history[i].sender!,
                          //                     history[i].symbol!,
                          //                     history[i].amount.toString()),
                          //               ),
                          //             );
                          //           },
                          //           child: Padding(
                          //             padding: const EdgeInsets.symmetric(
                          //                 horizontal: 30, vertical: 15),
                          //             child: Text(
                          //               'RETURN',
                          //               style: GoogleFonts.nunito(
                          //                   textStyle: const TextStyle(
                          //                       color: Colors.white,
                          //                       fontSize: 16,
                          //                       fontWeight: FontWeight.w600)),
                          //             ),
                          //           ),
                          //         ),
                          //       )
                          //     : SizedBox(
                          //         width: MediaQuery.of(context).size.width,
                          //         child: ElevatedButton(
                          //           style: ElevatedButton.styleFrom(
                          //             onPrimary: Colors.white,
                          //             primary: HexColor('0CACDA'),
                          //             elevation: 2.5,
                          //             shape: const RoundedRectangleBorder(
                          //               borderRadius: BorderRadius.all(
                          //                   Radius.circular(12)),
                          //             ),
                          //           ),
                          //           onPressed: () {
                          //             Navigator.push(
                          //               context,
                          //               PageTransition(
                          //                 type: PageTransitionType.bottomToTop,
                          //                 child: SendRequest(
                          //                     history[i].destination!,
                          //                     history[i].symbol!,
                          //                     history[i].amount!.toString()),
                          //               ),
                          //             );
                          //           },
                          //           child: Padding(
                          //             padding: const EdgeInsets.symmetric(
                          //                 horizontal: 30, vertical: 15),
                          //             child: Text(
                          //               'REPEAT',
                          //               style: GoogleFonts.nunito(
                          //                   textStyle: const TextStyle(
                          //                       color: Colors.white,
                          //                       fontSize: 16,
                          //                       fontWeight: FontWeight.w600)),
                          //             ),
                          //           ),
                          //         ),
                          //       ),

                          mData.wallet == history[i].destination ? Center(
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
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType.bottomToTop,
                                          child: SendRequest(
                                              history[i].sender!,
                                              history[i].symbol!,
                                              history[i].amount.toString()),
                                        ),
                                      );
                                    },
                                    child: Center(
                                      child: Text(
                                        'RETURN',
                                        style: GoogleFonts.nunito(
                                          textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700
                                            )
                                          ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          :
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
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType.bottomToTop,
                                          child: SendRequest(
                                              history[i].destination!,
                                              history[i].symbol!,
                                              history[i].amount!.toString()),
                                        ),
                                      );
                                    },
                                    child: Center(
                                      child: Text(
                                        'REPEAT',
                                        style: GoogleFonts.roboto(
                                          textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700
                                            )
                                          ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),


                          // const SizedBox(
                          //   height: 20,
                          // ),
                          // //========= Back Button =========
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width,
                          //   child: ElevatedButton(
                          //     style: ElevatedButton.styleFrom(
                          //       onPrimary: Colors.white,
                          //       primary: HexColor('0CACDA'),
                          //       elevation: 2.5,
                          //       shape: const RoundedRectangleBorder(
                          //         borderRadius:
                          //             BorderRadius.all(Radius.circular(12)),
                          //       ),
                          //     ),
                          //     onPressed: () {
                          //       Navigator.pop(context);
                          //     },
                          //     child: Padding(
                          //       padding: const EdgeInsets.symmetric(
                          //           horizontal: 30, vertical: 15),
                          //       child: Text(
                          //         'BACK TO WALLET',
                          //         style: GoogleFonts.nunito(
                          //             textStyle: const TextStyle(
                          //                 color: Colors.black,
                          //                 fontSize: 16,
                          //                 fontWeight: FontWeight.w600)),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    )
                  ],
                ),

                //  image
                Positioned(
                  top:
                      25.0, // (background container size) - (circle height / 2)
                  child: Container(
                    height: 100.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: mData.wallet == history[i].destination
                              ? const AssetImage('assets/images/receive.png')
                              : const AssetImage('assets/images/send.png'),
                        )),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
