import 'package:koompi_hotspot/all_export.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({Key? key}) : super(key: key);

  @override
  AnnouncementsScreenState createState() => AnnouncementsScreenState();
}

class AnnouncementsScreenState extends State<AnnouncementsScreen> {
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
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          if(mounted) {
            await Provider.of<NotificationProvider>(context, listen: false).fetchNotification();
          }
        },
        child: Container(
          child: announcementsList(context),
        ),
      ),
    );
  }
}
