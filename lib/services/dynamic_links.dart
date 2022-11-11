// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

// class DynamicLinkService {
//   Future<Uri> createDynamicLink() async {
//     final DynamicLinkParameters parameters = DynamicLinkParameters(
//       uriPrefix: 'https://bountybay.page.link/iGuj',
//       link: Uri.parse('https://your.url.com'),
//       androidParameters: AndroidParameters(
//         packageName: 'your_android_package_name',
//         minimumVersion: 12,
//       ),
//       iosParameters: IOSParameters(
//         bundleId: 'your_ios_bundle_identifier',
//         minimumVersion: '1',
//         appStoreId: 'your_app_store_id',
//       ),
//     );
//     var dynamicUrl = await parameters.buildShortLink();
//     final Uri shortUrl = shortDynamicLink.shortUrl;
//     return shortUrl;
//   }
// }
