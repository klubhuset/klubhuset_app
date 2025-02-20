import 'package:url_launcher/url_launcher.dart';

class UrlOpener {
  static void openMobilePay() async {
    final Uri appUrl = Uri.parse(
        'https://qr.mobilepay.dk/box/74f833d8-ca7f-496c-8c2e-2302f9fbc58e/pay-in'); // Erstat med dit URL scheme
    final Uri appStoreUrl = Uri.parse(
        'https://apps.apple.com/dk/app/624499138'); // Erstat med App Store-link

    if (await canLaunchUrl(appUrl)) {
      await launchUrl(appUrl);
    } else {
      // App not installed, open App Store
      await launchUrl(appStoreUrl, mode: LaunchMode.externalApplication);
    }
  }
}
