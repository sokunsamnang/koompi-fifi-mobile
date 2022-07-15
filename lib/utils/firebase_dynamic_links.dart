// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

// class DeepLink {
//   ///Build a dynamic link firebase
//   static Future<String> buildDynamicLink() async {
//     String url = "https://koompi.page.link";
//     final DynamicLinkParameters parameters = DynamicLinkParameters(
//       uriPrefix: url,
//       link: Uri.parse('$url/startapp'),
//       androidParameters: AndroidParameters(
//         packageName: "com.koompi.hotspot",
//         minimumVersion: 0,
//       ),
//       iosParameters: IosParameters(
//         bundleId: "com.koompi.hotspot",
//         minimumVersion: '0',
//       ),
//     );
//     final ShortDynamicLink dynamicUrl = await parameters.buildShortLink();
//     return dynamicUrl.shortUrl.toString();
//   }
// }