import 'package:koompi_hotspot/all_export.dart';

class RenewOption extends StatefulWidget {
  const RenewOption({Key? key}) : super(key: key);

  @override
  RenewOptionState createState() => RenewOptionState();
}

class RenewOptionState extends State<RenewOption>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  String? lang;
  bool? renewOption = mPlan.automatically;

  @override
  void initState() {
    super.initState();
    AppServices.noInternetConnection(globalKey);
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  changeIndex(bool index) {
    setState(() {
      renewOption = index;
    });
  }

  Future<void> renewPlanOption() async {
    var lang = AppLocalizeService.of(context);

    dialogLoading(context);
    var response = await PostRequest().renewOption(
      renewOption!,
    );
    var responseJson = json.decode(response.body);

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (kDebugMode) {
          print('Internet connected');
        }
        if (response.statusCode == 200) {
          if (!mounted) return;
          await Provider.of<GetPlanProvider>(context, listen: false).fetchHotspotPlan();

          if (!mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
              type: PageTransitionType.bottomToTop,
              child: const Navbar(0),
            ),
            ModalRoute.withName('/navbar'),
          );
        } else {

          if (!mounted) return;
          await Components.dialog(
            context,
            textAlignCenter(text: responseJson['message']),
            warningTitleDialog()
          );

          if (!mounted) return;
          Navigator.of(context).pop();
        }
      }
    } on SocketException catch (_) {
      if (!mounted) return;
      await Components.dialog(
        context,
        textAlignCenter(text: lang.translate('no_internet_message')),
        warningTitleDialog()
      );
      
      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizeService.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      key: globalKey,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(lang.translate('renew_option'),
          style: GoogleFonts.robotoCondensed(
            textStyle: const TextStyle(
              color: Colors.black,
              fontStyle: FontStyle.italic,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            )
          ),
        ),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
              icon: const Icon(
                Iconsax.arrow_left_2,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              });
        }),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: GestureDetector(
              child: IconButton(
                icon: const Icon(
                  Icons.check,
                  color: Colors.blueAccent,
                ),
                onPressed: () async {
                  setState(() {
                    renewPlanOption();
                  });
                },
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                elevation: 4.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => setState(() => changeIndex(true)),
                      child: ListTile(
                          leading: Icon(Icons.autorenew, color: primaryColor),
                          title: Text(lang.translate('auto')),
                          trailing: renewOption == true
                              ? Icon(
                                  Icons.check_circle,
                                  color: Colors.blue[700],
                                )
                              : const Icon(
                                  Icons.check_circle,
                                  color: Colors.transparent,
                                ),
                          onTap: () {
                            setState(() => changeIndex(true));
                            changeIndex(true) == true
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.blue[700],
                                  )
                                : const Icon(
                                    Icons.check_circle,
                                    color: Colors.transparent,
                                  );
                          }),
                    ),
                    _buildDivider(),
                    GestureDetector(
                        onTap: () => setState(() => changeIndex(false)),
                        child: ListTile(
                            leading: Icon(Icons.touch_app_sharp,
                                color: primaryColor),
                            trailing: renewOption == false
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.blue[700],
                                  )
                                : const Icon(
                                    Icons.check_circle,
                                    color: Colors.transparent,
                                  ),
                            title: Text(lang.translate('manual')),
                            onTap: () {
                              setState(() => changeIndex(false));
                              changeIndex(false) == false
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Colors.blue[700],
                                    )
                                  : const Icon(
                                      Icons.check_circle,
                                      color: Colors.transparent,
                                    );
                            }))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }
}
