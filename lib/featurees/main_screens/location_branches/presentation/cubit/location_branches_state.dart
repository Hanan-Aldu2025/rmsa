import 'package:appp/featurees/main_screens/home/presentation/views/domain_layer.dart';
import 'package:equatable/equatable.dart';

/// حالات صفحة المواقع
abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

/// حالة التحميل
class LocationLoading extends LocationState {}

/// حالة تحميل البيانات بنجاح
class LocationLoaded extends LocationState {
  final List<BranchEntity> allBranches; // جميع الفروع
  final List<BranchEntity> filteredBranches; // الفروع بعد الفلترة
  final BranchEntity? selectedBranch; // الفرع المختار
  final bool isSearching; // هل المستخدم يبحث؟

  const LocationLoaded({
    required this.allBranches,
    required this.filteredBranches,
    this.selectedBranch,
    this.isSearching = false,
  });

  /// إنشاء نسخة جديدة مع تحديث بعض الحقول
  LocationLoaded copyWith({
    List<BranchEntity>? allBranches,
    List<BranchEntity>? filteredBranches,
    BranchEntity? selectedBranch,
    bool? isSearching,
  }) {
    return LocationLoaded(
      allBranches: allBranches ?? this.allBranches,
      filteredBranches: filteredBranches ?? this.filteredBranches,
      selectedBranch: selectedBranch ?? this.selectedBranch,
      isSearching: isSearching ?? this.isSearching,
    );
  }

  @override
  List<Object?> get props => [
    allBranches,
    filteredBranches,
    selectedBranch,
    isSearching,
  ];
}

/// حالة الخطأ
class LocationError extends LocationState {
  final String message;

  const LocationError(this.message);

  @override
  List<Object?> get props => [message];
}
