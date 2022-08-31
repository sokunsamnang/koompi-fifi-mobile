import 'package:koompi_hotspot/all_export.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  NotificationsState createState() => NotificationsState();
}

class NotificationsState extends State<Notifications>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizeService.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          }
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          lang.translate('notifications'),
          style: GoogleFonts.robotoCondensed(
            textStyle: const TextStyle(
              color: Colors.black,
              fontStyle: FontStyle.italic,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            )
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        bottom: TabBar(
          unselectedLabelColor: Colors.grey,
          labelColor: primaryColor,
          tabs: [
            Tab(
              child: Text(lang.translate('transactions'),
                  style: GoogleFonts.nunito(
                      fontSize: 14, fontWeight: FontWeight.w600)),
            ),
            Tab(
              child: Text(lang.translate('announcements'),
                  style: GoogleFonts.nunito(
                      fontSize: 14, fontWeight: FontWeight.w600)),
            ),
          ],
          controller: _tabController,
          indicatorColor: primaryColor,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        bottomOpacity: 1,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(child: transaction(context)),
          const Center(child: AnnouncementsScreen()),
        ],
      ),
    );
  }
}
