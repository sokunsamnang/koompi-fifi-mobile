import 'package:easy_localization/easy_localization.dart';
import 'package:koompi_hotspot/all_export.dart';

class TrxHistory extends StatefulWidget {
  const TrxHistory({Key? key}) : super(key: key);

  @override
  _TrxHistoryState createState() => _TrxHistoryState();
}

class _TrxHistoryState extends State<TrxHistory> {

  @override
  void initState(){
    super.initState();
  }

  @override 
  void dispose(){
    super.dispose();
  }

  Widget trxHistory(BuildContext context) {
    DateTime now = DateTime.now();
    String? prevDay;
    String today = DateFormat("EEEE, d MMMM, y").format(now.toLocal());
    String yesterday = DateFormat("EEEE, d MMMM, y").format(now.toLocal().add(const Duration(days: -1)));

    var _lang = AppLocalizeService.of(context);

    List<Widget> _buildList(List<TrxHistoryModel> history, BuildContext context, String userWallet) {
      List<Widget> listItems = [];
      
      for (int i = 0; i < history.length; i++) {
        DateTime date = DateTime.parse(history[i].datetime!);
        String dateString = DateFormat("EEEE, d MMMM, y").format(date.toLocal());

        if (today == dateString) {
          dateString = "Today";
        } else if (yesterday == dateString) {
          dateString = "Yesterday";
        }

        bool showHeader = prevDay != dateString;
        prevDay = dateString;

        listItems.add(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              showHeader
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 7),
                      child: Text(
                        dateString,
                        style: GoogleFonts.nunito(
                            textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w700)),
                      ),
                    )
                  : const Offstage(),
              GestureDetector(
                onTap: () async {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.bottomToTop,
                          child: TransactionDetail(
                            history: history,
                            index: i,
                          )));
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 0.0),
                  height: 80.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            history[i].memo ==
                                        'Subscribed Fi-Fi Plan 30 Days' ||
                                    history[i].memo ==
                                        'Subscribed Fi-Fi Plan 365 Days' ||
                                    history[i].memo ==
                                        'Automatically Renewed Fi-Fi Plan 30 Days' ||
                                    history[i].memo ==
                                        'Automatically Renewed Fi-Fi Plan 365 Days' ||
                                    history[i].memo ==
                                        'Renewed Fi-Fi Plan 30 Days' ||
                                    history[i].memo ==
                                        'Renewed Fi-Fi Plan 365 Days' ||
                                    history[i].memo ==
                                        'Changed Subscribe Fi-Fi Plan To 30 Days' ||
                                    history[i].memo ==
                                        'Changed Subscribe Fi-Fi Plan To 365 Days'
                                ? Image.asset(
                                    'assets/images/Koompi-WiFi-Icon.png',
                                    scale: 39)
                                : history[i].symbol == 'SEL'
                                    ? Image.asset(
                                        'assets/images/sel-coin-icon.png',
                                        width: 27)
                                    : Image.asset(
                                        'assets/images/rise-coin-icon.png',
                                        width: 27),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                history[i].memo ==
                                            'Subscribed Fi-Fi Plan 30 Days' ||
                                        history[i].memo ==
                                            'Subscribed Fi-Fi Plan 365 Days' ||
                                        history[i].memo ==
                                            'Automatically Renewed Fi-Fi Plan 30 Days' ||
                                        history[i].memo ==
                                            'Automatically Renewed Fi-Fi Plan 365 Days' ||
                                        history[i].memo ==
                                            'Renewed Fi-Fi Plan 30 Days' ||
                                        history[i].memo ==
                                            'Renewed Fi-Fi Plan 365 Days' ||
                                        history[i].memo ==
                                            'Changed Subscribe Fi-Fi Plan To 30 Days' ||
                                        history[i].memo ==
                                            'Changed Subscribe Fi-Fi Plan To 365 Days'
                                    ? Text(
                                        'KOOMPI Fi-Fi',
                                        style: GoogleFonts.nunito(
                                            textStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700)),
                                      )
                                    : Text(
                                        userWallet == history[i].destination
                                            ? _lang.translate('recieved')
                                            : _lang.translate('sent'),
                                        style: GoogleFonts.nunito(
                                            textStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700)),
                                      ),
                                Text(
                                  AppUtils.timeStampToDateTime(
                                      history[i].datetime!),
                                  style: GoogleFonts.nunito(
                                      textStyle: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w400)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        userWallet == history[i].destination
                            ? Text(
                                '+ ${history[i].amount} ${history[i].symbol}',
                                style: GoogleFonts.nunito(
                                    textStyle: const TextStyle(
                                        color: Colors.green,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                              )
                            : Text(
                                '- ${history[i].amount} ${history[i].symbol}',
                                style: GoogleFonts.nunito(
                                    textStyle: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                              )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
        );
      }
      return listItems;
    }

    var history = Provider.of<TrxHistoryProvider>(context);
    return Scaffold(
      // Have No History
      backgroundColor: Colors.white,
      body: history.trxHistoryList.isEmpty
          ? SafeArea(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/images/undraw_wallet.svg',
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.height * 0.2,
                        placeholderBuilder: (context) => const Center(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
                        "No Activity",
                        style: GoogleFonts.nunito(
                            textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
            )

          // Display Loading
          : history.trxHistoryList.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              // Display History List
              : SafeArea(
                  child: Scrollbar(
                    thickness: 7,
                    thumbVisibility: true,
                    interactive: true,
                    radius: const Radius.circular(50),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: CustomScrollView(
                        // cacheExtent: double.maxFinite,
                        // shrinkWrap: true,
                        slivers: [
                          SliverList(
                            delegate: SliverChildListDelegate(
                              _buildList(history.trxHistoryList, context, mData.wallet!),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        automaticallyImplyLeading: true,
        title: Text(
          'Transaction History',
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
      body: RefreshIndicator(
          onRefresh: () async {
            if(mounted){
              await Provider.of<TrxHistoryProvider>(context, listen: false).fetchTrxHistory();
            }
          },
          child: trxHistory(context)));
  }
}
