// import 'package:koompi_hotspot/all_export.dart';

// class BodyScaffold extends StatelessWidget {
//   final double left, top, right, bottom;
//   final Widget child;
//   final double? width;
//   final double? height;

//   const BodyScaffold({
//     Key? key,
//     this.left = 0,
//     this.top = 0,
//     this.right = 0,
//     this.bottom = 16,
//     required this.child,
//     this.height,
//     this.width,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//         child: Container(
//       width: MediaQuery.of(context).size.width,
//       height: height,
//       padding: EdgeInsets.fromLTRB(left, top, right, bottom),
//       child: SafeArea(child: child),
//     ));
//   }
// }
