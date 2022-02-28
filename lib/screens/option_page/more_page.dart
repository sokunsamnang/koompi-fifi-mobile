import 'package:koompi_hotspot/all_export.dart';

class MorePage extends StatefulWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  String? name = mData.fullname;

  PackageInfo _packageInfo = PackageInfo(
    appName: '',
    packageName: '',
    version: '',
    buildNumber: '',
  );

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Widget _infoApp(String title, String subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title),
        Text(subtitle),
      ],
    );
  }

  @override
  void initState() {
    _initPackageInfo();
    AppServices.noInternetConnection(globalKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _lang = AppLocalizeService.of(context);
    return Scaffold(
      key: globalKey,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin: const EdgeInsets.all(8.0),
                color: Colors.white,
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  onTap: () async {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: const MyAccount(),
                      ),
                    );
                  },
                  title: Text(
                    name ?? 'KOOMPI',
                    style: const TextStyle(
                        color: Colors.black, fontFamily: "Poppins-Bold"),
                  ),
                  leading: CircleAvatar(
                    backgroundImage: mData.image == null
                        ? const AssetImage('assets/images/avatar.png')
                        : NetworkImage("${ApiService.getAvatar}/${mData.image}")
                            as ImageProvider<Object>,
                  ),
                  trailing: const Icon(LineIcons.edit),
                ),
              ),
              const SizedBox(height: 10.0),
              Card(
                elevation: 4.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Column(
                  children: <Widget>[
                    ListTile(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10)),
                        ),
                        leading: Icon(LineIcons.key, color: primaryColor),
                        title: Text(_lang.translate('change_password')),
                        trailing: const Icon(LineIcons.angleRight),
                        onTap: () async {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: const ChangePassword(),
                            ),
                          );
                        }),
                    buildDivider(),
                    ListTile(
                      leading: Icon(LineIcons.language, color: primaryColor),
                      title: Text(_lang.translate('language')),
                      trailing: const Icon(LineIcons.angleRight),
                      onTap: () async {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: const LanguageView(),
                          ),
                        );
                      },
                    ),
                    buildDivider(),
                    ListTile(
                      leading: Icon(LineIcons.wifi, color: primaryColor),
                      title: Text(_lang.translate('login_hotspot')),
                      trailing: const Icon(LineIcons.angleRight),
                      onTap: () async {
                        Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: const CaptivePortalWeb()),
                        );
                      },
                    ),
                    buildDivider(),
                    ListTile(
                      leading: const Icon(LineIcons.alternateSignOut,
                          color: Colors.red),
                      title: Text(_lang.translate('sign_out')),
                      onTap: () async {
                        await Components.dialogSignOut(
                          context,
                          Text(_lang.translate('sign_out_warn'),
                              textAlign: TextAlign.center),
                          Text(
                            _lang.translate('warning'),
                            style: const TextStyle(fontFamily: 'Poppins-Bold'),
                          ),
                        );
                      },
                    ),
                    buildDivider(),
                    Center(
                        child:
                            _infoApp('KOOMPI Fi-Fi: ', _packageInfo.version)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
