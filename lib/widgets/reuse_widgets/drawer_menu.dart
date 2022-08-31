import 'package:koompi_hotspot/all_export.dart';
import 'package:koompi_hotspot/screens/map/location.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizeService.of(context);
    return Drawer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: UserProfile(onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: const MyAccount(),
                ),
              );
            }),
          ),
          buildDivider(),
          DrawerListTile(
            title: "Home",
            iconSrc: Iconsax.home_1,
            press: () {
              Navigator.pushAndRemoveUntil(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: const Navbar(0),
                ),
                ModalRoute.withName('/navbar'),
              );
            },
          ),
          DrawerListTile(
            title: "Fi Wallet",
            iconSrc: Iconsax.wallet_2,
            press: () {
              Navigator.pushAndRemoveUntil(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: const Navbar(1),
                ),
                ModalRoute.withName('/navbar'),
              );
            },
          ),
          DrawerListTile(
            title: "Fi-Fi Maps",
            iconSrc: Iconsax.map,
            press: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: const LocationView(),
                ),
              );
            },
          ),
          DrawerListTile(
            title: "Wi-Fi",
            iconSrc: Iconsax.wifi,
            press: () {
              Navigator.pushAndRemoveUntil(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: const Navbar(2),
                ),
                ModalRoute.withName('/navbar'),
              );
            },
          ),
          DrawerListTile(
            title: "More",
            iconSrc: Iconsax.menu_1,
            press: () {
              Navigator.pushAndRemoveUntil(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: const Navbar(3),
                ),
                ModalRoute.withName('/navbar'),
              );
            },
          ),
          DrawerListTile(
            title: "Sign Out",
            iconSrc: Iconsax.logout_1,
            iconColor: Colors.red,
            press: () async {
              await Components.dialogSignOut(
                context,
                Text(lang.translate('sign_out_warn'),
                    textAlign: TextAlign.center),
                Text(
                  lang.translate('warning'),
                  style: const TextStyle(fontFamily: 'Poppins-Bold'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    this.title,
    this.iconSrc,
    this.iconColor,
    this.press,
  }) : super(key: key);

  final String? title;
  final IconData? iconSrc;
  final Color? iconColor;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (press),
      horizontalTitleGap: 0.0,
      leading: Icon(
        iconSrc,
        color: iconColor,
      ),
      title: Text(
        title!,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
class UserProfile extends StatelessWidget {
  const UserProfile({
    @required this.onPressed,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                _buildImage(),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildName(),
                      _buildPhone(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return CircleAvatar(
      radius: 25,
      backgroundImage: mData.image == null
                      ? const AssetImage('assets/images/avatar.png')
                      : NetworkImage("${ApiService.getAvatar}/${mData.image}") as ImageProvider<Object>,
    );
  }

  Widget _buildName() {
    return Text(
      mData.fullname ?? 'Guest',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPhone() {
    return Text(
      mData.phone!,
      style: const TextStyle(
        fontWeight: FontWeight.w300,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
