import 'package:koompi_hotspot/all_export.dart';

class MyAppBar extends StatelessWidget {
  final double pLeft;
  final double pTop;
  final double pRight;
  final double pBottom;
  final EdgeInsetsGeometry margin;
  final String? title;
  final Function onPressed;

  const MyAppBar(
      {Key? key,
      this.pLeft = 0,
      this.pTop = 0,
      this.pRight = 0,
      this.pBottom = 0,
      this.margin = const EdgeInsets.fromLTRB(0, 0, 0, 0),
      @required this.title,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        // height: 65.0,
        width: MediaQuery.of(context).size.width,
        margin: margin,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              /* Menu Icon */
              alignment: Alignment.center,
              iconSize: 40.0,
              icon: const Icon(Iconsax.arrow_left_2, color: Colors.black, size: 30),
              onPressed: onPressed(),
            ),
            MyText(
              color: "#000000",
              text: title!,
              left: 15,
              fontSize: 22,
            )
          ],
        ));
  }
}
