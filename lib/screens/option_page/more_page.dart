import 'package:koompi_hotspot/all_export.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';

class MorePage extends StatefulWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ExpansionTileCardState> cardAccountSettings = GlobalKey();
  final GlobalKey<ExpansionTileCardState> cardFiFi = GlobalKey();
  final GlobalKey<ExpansionTileCardState> cardReward = GlobalKey();

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
      backgroundColor: Colors.white,
      key: globalKey,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 10.0),
                child: ListTile(
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
                ),
              ),
              buildDivider(),
              const SizedBox(height: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // ==================== Account Settings ====================
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: ExpansionTileCard(
                      key: cardAccountSettings,
                      borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                      leading: Icon(Icons.settings, color: primaryColor),
                      title: Text('Account Settings', 
                      style: GoogleFonts.robotoCondensed(
                          fontSize: 20.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w700
                        )
                      ),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: primaryColor.withOpacity(0.8), width: 1.5),
                              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                            ),
                            leading: Icon(Icons.people_alt_outlined, color: primaryColor),
                            title: const Text('Edit Profile'),
                            trailing: const Icon(LineIcons.angleRight),
                            onTap: () async {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: const MyAccount(),
                                ),
                              );
                            }
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 10.0, left: 10.0),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: primaryColor.withOpacity(0.8), width: 1.5),
                              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
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
                            }
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 10.0, left: 10.0),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: primaryColor.withOpacity(0.8), width: 1.5),
                              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                            ),
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
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  // ==================== Fi-Fi ====================
                  buildDivider(),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: ExpansionTileCard(
                      key: cardFiFi,
                      borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                      leading: Icon(Icons.network_wifi_outlined, color: primaryColor),
                      title: Text('Fi-Fi', 
                      style: GoogleFonts.robotoCondensed(
                          fontSize: 20.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w700
                        )
                      ),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 10.0, left: 10.0),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: primaryColor.withOpacity(0.8), width: 1.5),
                              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                            ),
                            leading: Icon(LineIcons.connectDevelop, color: primaryColor),
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
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 10.0, left: 10.0),
                        //   child: ListTile(
                        //     shape: RoundedRectangleBorder(
                        //       side: BorderSide(color: primaryColor.withOpacity(0.8), width: 1.5),
                        //       borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                        //     ),
                        //     leading: Icon(Icons.devices_outlined, color: primaryColor),
                        //     title: Text('Devices'),
                        //     trailing: const Icon(LineIcons.angleRight),
                        //     onTap: () async {

                        //     },
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 10.0, left: 10.0),
                        //   child: ListTile(
                        //     shape: RoundedRectangleBorder(
                        //       side: BorderSide(color: primaryColor.withOpacity(0.8), width: 1.5),
                        //       borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                        //     ),
                        //     leading: Icon(LineIcons.mapAlt, color: primaryColor),
                        //     title: Text('Fi-Fi Map'),
                        //     trailing: const Icon(LineIcons.angleRight),
                        //     onTap: () async {
                        //       Navigator.push(
                        //         context,
                        //         PageTransition(
                        //             type: PageTransitionType.rightToLeft,
                        //             child: const MyLocationView()),
                        //       );
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),

                  // ==================== Rewards ====================                
                  // buildDivider(),
                  // const SizedBox(height: 10.0),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  //   child: ExpansionTileCard(
                  //     key: cardReward,
                  //     borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                  //     leading: Icon(Icons.wallet_giftcard_outlined, color: primaryColor),
                  //     title: Text('Rewards', 
                  //     style: GoogleFonts.robotoCondensed(
                  //         fontSize: 20.0,
                  //         color: Colors.black,
                  //         fontWeight: FontWeight.w700
                  //       )
                  //     ),
                  //     children: <Widget>[
                  //       Padding(
                  //         padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 10.0, left: 10.0),
                  //         child: ListTile(
                  //           shape: RoundedRectangleBorder(
                  //             side: BorderSide(color: primaryColor.withOpacity(0.8), width: 1.5),
                  //             borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                  //           ),
                  //           leading: Icon(LineIcons.gifts, color: primaryColor),
                  //           title: const Text('Rewards'),
                  //           trailing: const Icon(LineIcons.angleRight),
                  //           onTap: () async {
                              
                  //           },
                  //         ),
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 10.0, left: 10.0),
                  //         child: ListTile(
                  //           shape: RoundedRectangleBorder(
                  //             side: BorderSide(color: primaryColor.withOpacity(0.8), width: 1.5),
                  //             borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                  //           ),
                  //           leading: Icon(Icons.mail_outline_outlined, color: primaryColor),
                  //           title: const Text('Earn a referral'),
                  //           trailing: const Icon(LineIcons.angleRight),
                  //           onTap: () async {

                  //           },
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(height: 10.0),


                  buildDivider(),
                  // const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(LineIcons.alternateSignOut, color: Colors.red),
                            TextButton(
                              onPressed: () async {
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
                              child: Text(_lang.translate('sign_out'),
                                style: GoogleFonts.roboto(
                                  fontSize: 20.0,
                                  color: Colors.red,
                                )
                              ),

                            ),
                          ],
                        ),
                        _infoApp('KOOMPI Fi-Fi: ', _packageInfo.version)
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
