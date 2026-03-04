// lib/core/services/url_launcher_service.dart

import 'package:url_launcher/url_launcher.dart';

/// واجهة خدمة فتح الروابط
abstract class LinkLauncherService {
  /// إجراء مكالمة هاتفية
  Future<void> makePhoneCall(String phoneNumber);

  /// فتح رابط خارجي
  Future<void> openUrl(String url);
}

/// تنفيذ خدمة فتح الروابط
class UrlLauncherServiceImpl implements LinkLauncherService {
  @override
  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri url = Uri.parse('tel:$phoneNumber');
    await _launch(url);
  }

  @override
  Future<void> openUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    await _launch(url, isExternal: true);
  }

  /// دالة مساعدة لفتح الرابط
  Future<void> _launch(Uri url, {bool isExternal = false}) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: isExternal
            ? LaunchMode.externalApplication
            : LaunchMode.platformDefault,
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
