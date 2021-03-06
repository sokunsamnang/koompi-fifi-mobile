import 'package:koompi_hotspot/all_export.dart';

class PromotionCarousel extends StatelessWidget {
  const PromotionCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var notification = Provider.of<NotificationProvider>(context);

    return Column(
      children: <Widget>[
        SizedBox(
          height: 200.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: notification.notificationList.length,
            itemBuilder: (BuildContext context, int index) {
              NotificationModel promotion =
                  notification.notificationList[index];
              return notification.notificationList[index].category ==
                      'Promotion'
                  ? GestureDetector(
                      onTap: () async {
                        dialogLoading(context);
                        await Provider.of<VoteResultProvider>(context,
                                listen: false)
                            .fetchVoteResult(promotion.id!);
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PromotionScreen(
                              promotion: promotion,
                              index: index,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        // width: 150.0,
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0.0, 2.0),
                                    blurRadius: 6.0,
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Hero(
                                    tag:
                                        "${ApiService.notiImage}/${notification.notificationList[index].image}",
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: Image(
                                        height: 180.0,
                                        width: 180.0,
                                        image: NetworkImage(
                                            "${ApiService.notiImage}/${notification.notificationList[index].image}"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : Container();
            },
          ),
        ),
      ],
    );
  }
}
