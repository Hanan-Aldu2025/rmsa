// lib/featurees/main_screens/contact_us/data/repositories/contact_repository_impl.dart

import 'package:appp/core/services/url_launcher_service.dart';
import 'package:appp/featurees/main_screens/contact_us/domain/repositories/contact_repository.dart';

/// تنفيذ ContactRepository - يستخدم LinkLauncherService لفتح الروابط
class ContactRepositoryImpl implements ContactRepository {
  final LinkLauncherService _launcher;

  ContactRepositoryImpl(this._launcher);

  @override
  Future<void> launchUrl(String url) => _launcher.openUrl(url);

  @override
  Future<void> makePhoneCall(String phone) => _launcher.makePhoneCall(phone);
}
