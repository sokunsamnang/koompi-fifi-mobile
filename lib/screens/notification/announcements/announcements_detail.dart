import 'package:koompi_hotspot/all_export.dart';

class AnnouncementsDetail extends StatefulWidget {
  final List<NotificationModel> notification;
  final int index;
  const AnnouncementsDetail(
      {Key? key, required this.notification, required this.index})
      : super(key: key);

  @override
  _AnnouncementsDetailState createState() => _AnnouncementsDetailState();
}

class _AnnouncementsDetailState extends State<AnnouncementsDetail> {
  bool isUpVoted = false;
  bool isDownVoted = false;

  final Backend _backend = Backend();

  @override
  void initState() {
    super.initState();
    getVoteResult();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future getVoteResult() async {
    await Provider.of<VoteResultProvider>(context, listen: false)
        .fetchVoteResult(widget.notification[widget.index].id!);
    await Provider.of<NotificationProvider>(context, listen: false)
        .fetchNotification();
  }

  Future<void> _onSubmitUpVoteAdsPost() async {
    var _lang = AppLocalizeService.of(context);

    dialogLoading(context);
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (kDebugMode) {
          print('Internet connected');
        }
        _backend.response = await PostRequest()
            .upVoteAdsPost(widget.notification[widget.index].id.toString());
        var responseJson = json.decode(_backend.response!.body);
        if (_backend.response!.statusCode == 200) {
          await Provider.of<VoteResultProvider>(context, listen: false)
              .fetchVoteResult(widget.notification[widget.index].id!);
          await Provider.of<NotificationProvider>(context, listen: false)
              .fetchNotification();
          Navigator.of(context).pop();
        } else {
          await Components.dialog(
              context,
              textAlignCenter(text: responseJson['message']),
              warningTitleDialog());
          Navigator.of(context).pop();
        }
      }
    } on SocketException catch (_) {
      await Components.dialog(
          context,
          textAlignCenter(text: _lang.translate('no_internet_message')),
          warningTitleDialog());
      Navigator.of(context).pop();
    }
  }

  Future<void> _onSubmitDownVoteAdsPost() async {
    var _lang = AppLocalizeService.of(context);

    dialogLoading(context);
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (kDebugMode) {
          print('Internet connected');
        }
        _backend.response = await PostRequest()
            .downVoteAdsPost(widget.notification[widget.index].id.toString());
        var responseJson = json.decode(_backend.response!.body);
        if (_backend.response!.statusCode == 200) {
          await Provider.of<VoteResultProvider>(context, listen: false)
              .fetchVoteResult(widget.notification[widget.index].id!);
          await Provider.of<NotificationProvider>(context, listen: false)
              .fetchNotification();
          Navigator.of(context).pop();
        } else {
          await Components.dialog(
              context,
              textAlignCenter(text: responseJson['message']),
              warningTitleDialog());
          Navigator.of(context).pop();
        }
      }
    } on SocketException catch (_) {
      await Components.dialog(
          context,
          textAlignCenter(text: _lang.translate('no_internet_message')),
          warningTitleDialog());
      Navigator.of(context).pop();
    }
  }

  Future<void> _onSubmitUnVoteAdsPut() async {
    var _lang = AppLocalizeService.of(context);
    dialogLoading(context);
    // dialogLoading(context);
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (kDebugMode) {
          print('Internet connected');
        }
        _backend.response = await PostRequest()
            .unVoteAdsPut(widget.notification[widget.index].id.toString());
        var responseJson = json.decode(_backend.response!.body);
        if (_backend.response!.statusCode == 200) {
          await Provider.of<VoteResultProvider>(context, listen: false)
              .fetchVoteResult(widget.notification[widget.index].id!);
          await Provider.of<NotificationProvider>(context, listen: false)
              .fetchNotification();
          Navigator.of(context).pop();
        } else {
          await Components.dialog(
              context,
              textAlignCenter(text: responseJson['message']),
              warningTitleDialog());
          Navigator.of(context).pop();
        }
      }
    } on SocketException catch (_) {
      await Components.dialog(
          context,
          textAlignCenter(text: _lang.translate('no_internet_message')),
          warningTitleDialog());
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    var _lang = AppLocalizeService.of(context);

    var _notification = Provider.of<NotificationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(_lang.translate('announcements'),
            style: const TextStyle(color: Colors.black, fontFamily: 'Medium')),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
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
                Center(
                  child: Image(
                      fit: BoxFit.contain,
                      image: NetworkImage(
                          "${ApiService.notiImage}/${widget.notification[widget.index].image}")),
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
                                _notification
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
                              icon: const Icon(Icons.share_outlined),
                              label: const Text('Share'),
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
                        AppUtils.timeStampToDate(
                            widget.notification[widget.index].date!),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    widget.notification[widget.index].title!,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 19.0,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: <Widget>[
                      const Icon(
                        FontAwesomeIcons.info,
                        size: 12.5,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 5.0),
                      Text(
                        widget.notification[widget.index].category!,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Linkable(
                      text: widget.notification[widget.index].description!,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Poppins-Regular')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
