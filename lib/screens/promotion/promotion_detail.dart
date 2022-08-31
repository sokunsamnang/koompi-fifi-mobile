import 'package:koompi_hotspot/all_export.dart';

class PromotionScreen extends StatefulWidget {
  final NotificationModel promotion;
  final int index;

  const PromotionScreen(
      {Key? key, required this.promotion, required this.index})
      : super(key: key);

  @override
  PromotionScreenState createState() => PromotionScreenState();
}

class PromotionScreenState extends State<PromotionScreen> {
  bool isUpVoted = false;
  bool isDownVoted = false;

  final Backend _backend = Backend();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _onSubmitUpVoteAdsPost() async {
    var lang = AppLocalizeService.of(context);

    dialogLoading(context);
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (kDebugMode) {
          print('Internet connected');
        }
        _backend.response =
            await PostRequest().upVoteAdsPost(widget.promotion.id.toString());
        var responseJson = json.decode(_backend.response!.body);
        if (_backend.response!.statusCode == 200) {
          if (!mounted) return;
          await Provider.of<VoteResultProvider>(context, listen: false).fetchVoteResult(widget.promotion.id!);

          if (!mounted) return;
          await Provider.of<NotificationProvider>(context, listen: false).fetchNotification();
          
          if (!mounted) return;
          Navigator.of(context).pop();
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
      await Components.dialog(
        context,
        textAlignCenter(text: lang.translate('no_internet_message')),
        warningTitleDialog()
      );
      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

  Future<void> _onSubmitDownVoteAdsPost() async {
    var lang = AppLocalizeService.of(context);

    dialogLoading(context);
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (kDebugMode) {
          print('Internet connected');
        }
        _backend.response =
            await PostRequest().downVoteAdsPost(widget.promotion.id.toString());
        var responseJson = json.decode(_backend.response!.body);
        if (_backend.response!.statusCode == 200) {
          if (!mounted) return;
          await Provider.of<VoteResultProvider>(context, listen: false).fetchVoteResult(widget.promotion.id!);
          
          if (!mounted) return;
          await Provider.of<NotificationProvider>(context, listen: false).fetchNotification();
          
          if (!mounted) return;
          Navigator.of(context).pop();
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
      await Components.dialog(
        context,
        textAlignCenter(text: lang.translate('no_internet_message')),
        warningTitleDialog()
      );
      
      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

  Future<void> _onSubmitUnVoteAdsPut() async {
    var lang = AppLocalizeService.of(context);
    dialogLoading(context);
    // dialogLoading(context);
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (kDebugMode) {
          print('Internet connected');
        }
        _backend.response =
            await PostRequest().unVoteAdsPut(widget.promotion.id.toString());
        var responseJson = json.decode(_backend.response!.body);
        if (_backend.response!.statusCode == 200) {
          if (!mounted) return;
          await Provider.of<VoteResultProvider>(context, listen: false).fetchVoteResult(widget.promotion.id!);

          if (!mounted) return;
          await Provider.of<NotificationProvider>(context, listen: false).fetchNotification();

          if (!mounted) return;
          Navigator.of(context).pop();
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
    var notification = Provider.of<NotificationProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(lang.translate('promotion'),
          style: GoogleFonts.robotoCondensed(
            textStyle: const TextStyle(
              color: Colors.black,
              fontStyle: FontStyle.italic,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            )
          ),
        ),
        leading: IconButton(
            icon: const Icon(Iconsax.arrow_left_2, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Hero(
                      tag:
                          "${ApiService.notiImage}/${notification.notificationList[widget.index].image}",
                      child: ClipRRect(
                        // borderRadius: BorderRadius.circular(12.0),
                        child: Image(
                          image: NetworkImage(
                              "${ApiService.notiImage}/${notification.notificationList[widget.index].image}"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            voteResult.votedType != "Voted Up" ||
                                    voteResult.votedType == null
                                ? Container(
                                    alignment: Alignment.center,
                                    child: IconButton(
                                      highlightColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      icon: Image.asset(
                                          'assets/images/up-vote-grey.png'),
                                      onPressed: () async {
                                        await Provider.of<NotificationProvider>(
                                                context,
                                                listen: false)
                                            .fetchNotification();
                                        setState(() {
                                          voteResult.votedType = "Voted Up";
                                          _onSubmitUpVoteAdsPost();
                                        });
                                      },
                                    ),
                                  )
                                : Container(
                                    alignment: Alignment.center,
                                    child: IconButton(
                                      highlightColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      icon: Image.asset(
                                          'assets/images/up-vote-blue.png'),
                                      onPressed: () async {
                                        await Provider.of<NotificationProvider>(
                                                context,
                                                listen: false)
                                            .fetchNotification();
                                        setState(() {
                                          voteResult.votedType = null;
                                          _onSubmitUnVoteAdsPut();
                                        });
                                      },
                                    ),
                                  ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                                notification
                                    .notificationList[widget.index].vote
                                    .toString(),
                                style: const TextStyle(color: Colors.grey)),
                            const SizedBox(
                              width: 5,
                            ),
                            voteResult.votedType != "Voted Down" ||
                                    voteResult.votedType == null
                                ? Container(
                                    alignment: Alignment.center,
                                    child: IconButton(
                                      highlightColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      icon: Image.asset(
                                          'assets/images/down-vote-grey.png'),
                                      onPressed: () async {
                                        await Provider.of<NotificationProvider>(
                                                context,
                                                listen: false)
                                            .fetchNotification();
                                        setState(() {
                                          voteResult.votedType = "Voted Down";
                                          _onSubmitDownVoteAdsPost();
                                        });
                                      },
                                    ),
                                  )
                                : Container(
                                    alignment: Alignment.center,
                                    child: IconButton(
                                      highlightColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      icon: Image.asset(
                                          'assets/images/down-vote-blue.png'),
                                      onPressed: () async {
                                        await Provider.of<NotificationProvider>(
                                                context,
                                                listen: false)
                                            .fetchNotification();
                                        setState(() {
                                          voteResult.votedType = null;
                                          _onSubmitUnVoteAdsPut();
                                        });
                                      },
                                    ),
                                  ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            ElevatedButton.icon(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        primaryColor),
                                shadowColor: MaterialStateProperty.all<Color>(
                                    Colors.transparent),
                              ),
                              icon: const Icon(Iconsax.share, color: Colors.white),
                              label: const MyText(text: 'Share'),
                              onPressed: () {
                                Share.share('https://koompi.com',
                                    subject: 'HOT Promotion!');
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        AppUtils.timeStampToDate(widget.promotion.date!),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.promotion.title!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 19.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          const Icon(
                            Icons.info,
                            size: 12.5,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 5.0),
                          Text(
                            widget.promotion.category!,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Linkable(
                      text: widget.promotion.description!,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Poppins-Regular')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
