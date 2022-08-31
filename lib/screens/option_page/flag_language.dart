import 'package:koompi_hotspot/all_export.dart';

class LanguageView extends StatefulWidget {
  const LanguageView({Key? key}) : super(key: key);

  @override
  LanguageViewState createState() => LanguageViewState();
}

class LanguageViewState extends State<LanguageView>{

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<LangProvider>(context);
    var lang = AppLocalizeService.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(lang.translate('language'),
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
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                elevation: 8.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Image.asset(
                        'assets/images/kh_flag.png',
                        height: 50,
                        width: 50,
                      ),
                      title: Text(lang.translate('khmer')),
                      trailing: Consumer<LangProvider>(
                        builder: (context, value, child) => value.lang == 'KH'
                            ? Icon(
                                Icons.check_circle,
                                color: Colors.blue[700],
                              )
                            : const Icon(
                                Icons.check_circle,
                                color: Colors.transparent,
                              ),
                      ),
                      onTap: () async {
                        data.setLocal('KH', context);
                      },
                    ),
                    _buildDivider(),
                    ListTile(
                        leading: Image.asset(
                          'assets/images/eng_flag.png',
                          width: 50,
                          height: 50,
                        ),
                        trailing: Consumer<LangProvider>(
                          builder: (context, value, child) =>
                              value.lang == 'EN' || value.lang == null
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Colors.blue[700],
                                    )
                                  : const Icon(
                                      Icons.check_circle,
                                      color: Colors.transparent,
                                    ),
                        ),
                        title: Text(lang.translate('english')),
                        onTap: () async {
                          data.setLocal('EN', context);
                        }),
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
