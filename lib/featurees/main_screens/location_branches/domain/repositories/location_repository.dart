// lib/featurees/main_screens/location/domain/repositories/location_repository.dart

import 'package:appp/featurees/main_screens/home/presentation/views/domain_layer.dart';

/// واجهة Location Repository - تحدد العقود التي يجب تنفيذها في طبقة البيانات
abstract class LocationRepository {
  /// جلب جميع الفروع
  Future<List<BranchEntity>> getAllBranches();
}
