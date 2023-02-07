import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/widgets.dart';

class DynamicLinkService {
  static Future<Uri> createDynamicLink() async {
    final DynamicLinkParameters dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse('https://cozy.page.link.com?screen=VerifyEmailScreen'),
      uriPrefix: 'https://cozy.page.link',
      androidParameters: const AndroidParameters(
          packageName: 'com.cozy_social_media', minimumVersion: 1),
    );
    final dynamicLink =
    await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
    final Uri shortUrl = dynamicLink.shortUrl;
    return shortUrl;
  }

  static Future<void> initDynamicLink(BuildContext context) async {
    final PendingDynamicLinkData? initialLink =
    await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink != null) {
      // handle when terminated
      final Uri deepLink = initialLink.link;

      Navigator.of(context).pushReplacementNamed(deepLink.queryParameters.values.first);
    }
    // print('initDynamicLink called');
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      // handle when foreground and background
      final Uri deepLink = dynamicLinkData.link;

      Navigator.of(context).pushReplacementNamed(deepLink.queryParameters.values.first);

    }).onError((error) {
      // Handle errors
      print('error dynamic link $error');
    });
  }

}
