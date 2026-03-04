// lib/featurees/main_screens/contact_us/domain/repositories/contact_repository.dart

/// واجهة Contact Repository - تحدد العقود للتعامل مع الروابط الخارجية
abstract class ContactRepository {
  /// فتح رابط خارجي (URL)
  Future<void> launchUrl(String url);

  /// إجراء مكالمة هاتفية
  Future<void> makePhoneCall(String phone);
}
