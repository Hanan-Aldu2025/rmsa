// lib/featurees/main_screens/location/presentation/cubit/location_state.dart

import 'dart:io';
import 'dart:ui';

import 'package:appp/core/constans/constans_kword.dart';
import 'package:appp/featurees/main_screens/home/presentation/views/domain_layer.dart';
import 'package:appp/featurees/main_screens/home/presentation/views/presentation_layer.dart';
import 'package:appp/featurees/main_screens/location_branches/presentation/views/location_data_layer.dart';
import 'package:appp/featurees/main_screens/location_branches/presentation/views/location_domain_layer.dart';
import 'package:appp/generated/l10n.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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

// lib/featurees/main_screens/location/presentation/cubit/location_cubit.dart

/// Cubit المسؤول عن منطق صفحة المواقع
class LocationCubit extends Cubit<LocationState> {
  final LocationRepository repository;
  final TextEditingController searchController = TextEditingController();

  List<BranchEntity> _allBranches = [];

  LocationCubit({required this.repository}) : super(LocationLoading());

  @override
  Future<void> close() {
    searchController.dispose();
    return super.close();
  }

  /// جلب جميع الفروع
  Future<void> fetchBranches({BranchEntity? homeSelectedBranch}) async {
    try {
      if (isClosed) return;
      emit(LocationLoading());

      _allBranches = await repository.getAllBranches();

      if (isClosed) return;

      emit(
        LocationLoaded(
          allBranches: _allBranches,
          filteredBranches: [],
          selectedBranch:
              homeSelectedBranch ??
              (_allBranches.isNotEmpty ? _allBranches.first : null),
          isSearching: false,
        ),
      );
    } catch (e) {
      if (!isClosed) emit(LocationError(e.toString()));
    }
  }

  /// البحث في الفروع
  void searchBranches(String query) {
    if (isClosed || state is! LocationLoaded) return;

    final currentState = state as LocationLoaded;

    if (query.isEmpty) {
      emit(currentState.copyWith(filteredBranches: [], isSearching: false));
      return;
    }

    final filtered = _allBranches
        .where(
          (b) =>
              b.name.toLowerCase().contains(query.toLowerCase()) ||
              b.nameAr.contains(query),
        )
        .toList();

    emit(currentState.copyWith(filteredBranches: filtered, isSearching: true));
  }

  /// مسح البحث
  void clearSearch() {
    searchController.clear();
    if (state is LocationLoaded) {
      emit(
        (state as LocationLoaded).copyWith(
          filteredBranches: [],
          isSearching: false,
        ),
      );
    }
  }

  /// اختيار فرع معين
  void selectBranch(BranchEntity branch) {
    if (isClosed || state is! LocationLoaded) return;

    emit(
      (state as LocationLoaded).copyWith(
        selectedBranch: branch,
        isSearching: false,
        filteredBranches: [],
      ),
    );
  }
}

// lib/featurees/main_screens/location/presentation/views/location_view.dart

/// صفحة المواقع - نقطة الدخول
class LocationView extends StatelessWidget {
  const LocationView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeSelectedBranch = context.read<HomeCubit>().state.selectedBranch;

    return BlocProvider(
      create: (context) => LocationCubit(
        repository: LocationRepositoryImpl(
          remoteDataSource: LocationRemoteDataSource(),
        ),
      )..fetchBranches(homeSelectedBranch: homeSelectedBranch),
      child: BlocListener<HomeCubit, HomeState>(
        listenWhen: (previous, current) =>
            previous.selectedBranch != current.selectedBranch,
        listener: (context, homeState) {
          if (homeState.selectedBranch != null) {
            context.read<LocationCubit>().selectBranch(
              homeState.selectedBranch!,
            );
          }
        },
        child: const LocationViewConsumer(),
      ),
    );
  }
}

// lib/featurees/main_screens/location/presentation/views/location_view_consumer.dart

/// المستهلك - يتفاعل مع تغييرات الحالة
class LocationViewConsumer extends StatelessWidget {
  const LocationViewConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        if (state is LocationLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            ),
          );
        } else if (state is LocationError) {
          return Scaffold(body: Center(child: Text(state.message)));
        } else if (state is LocationLoaded) {
          return LocationViewBody(state: state);
        }
        return const SizedBox();
      },
    );
  }
}
// lib/featurees/main_screens/location/presentation/views/location_view_body.dart

/// جسم صفحة المواقع
class LocationViewBody extends StatelessWidget {
  final LocationLoaded state;

  const LocationViewBody({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kHorizintalPadding),
          child: Column(
            children: [
              const SizedBox(height: 8),
              const LocationSearchField(),
              const SizedBox(height: 5),
              Expanded(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          BranchMapSection(
                            allBranches: state.allBranches,
                            selectedBranch: state.selectedBranch,
                          ),
                          if (state.selectedBranch != null)
                            BranchDetailsSection(branch: state.selectedBranch!),
                        ],
                      ),
                    ),
                    if (state.isSearching && state.filteredBranches.isNotEmpty)
                      SearchResultsOverlay(
                        filteredBranches: state.filteredBranches,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// lib/featurees/main_screens/location/presentation/views/widgets/location_search_field.dart

/// حقل البحث في صفحة المواقع
class LocationSearchField extends StatelessWidget {
  const LocationSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);

    return AppSearchField(
      hintText: lang.searchBranch,
      controller: context.read<LocationCubit>().searchController,
      onChanged: (value) {
        context.read<LocationCubit>().searchBranches(value);
      },
    );
  }
}

// lib/featurees/main_screens/location/presentation/views/widgets/search_results_overlay.dart

/// طبقة نتائج البحث المنبثقة
class SearchResultsOverlay extends StatelessWidget {
  final List<BranchEntity> filteredBranches;

  const SearchResultsOverlay({super.key, required this.filteredBranches});

  @override
  Widget build(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;

    return Positioned(
      top: 0,
      left: 16,
      right: 16,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 300),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
          ],
        ),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: filteredBranches.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final branch = filteredBranches[index];
            return ListTile(
              title: Text(branch.getName(langCode)),
              subtitle: Text(branch.getAddress(langCode)),
              onTap: () {
                context.read<LocationCubit>().selectBranch(branch);
                FocusScope.of(context).unfocus();
              },
            );
          },
        ),
      ),
    );
  }
}

// lib/featurees/main_screens/location/presentation/views/widgets/branch_map_section.dart

/// قسم الخريطة لعرض مواقع الفروع
class BranchMapSection extends StatefulWidget {
  final List<BranchEntity> allBranches;
  final BranchEntity? selectedBranch;

  const BranchMapSection({
    super.key,
    required this.allBranches,
    this.selectedBranch,
  });

  @override
  State<BranchMapSection> createState() => _BranchMapSectionState();
}

class _BranchMapSectionState extends State<BranchMapSection> {
  GoogleMapController? _mapController;

  /// تكبير الخريطة لتشمل جميع الماركرز
  void _zoomToFitAll(List<BranchEntity> branches) {
    if (branches.isEmpty || _mapController == null) return;

    double minLat = branches.first.lat;
    double maxLat = branches.first.lat;
    double minLng = branches.first.lng;
    double maxLng = branches.first.lng;

    for (var b in branches) {
      if (b.lat < minLat) minLat = b.lat;
      if (b.lat > maxLat) maxLat = b.lat;
      if (b.lng < minLng) minLng = b.lng;
      if (b.lng > maxLng) maxLng = b.lng;
    }

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        50,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        child: GoogleMap(
          gestureRecognizers: const {},
          rotateGesturesEnabled: true,
          scrollGesturesEnabled: true,
          tiltGesturesEnabled: true,
          zoomGesturesEnabled: true,
          initialCameraPosition: CameraPosition(
            target: widget.selectedBranch != null
                ? LatLng(widget.selectedBranch!.lat, widget.selectedBranch!.lng)
                : const LatLng(15.350, 44.200),
            zoom: 10,
          ),
          onMapCreated: (controller) {
            _mapController = controller;
            _zoomToFitAll(widget.allBranches);
          },
          markers: widget.allBranches.map((branch) {
            final isSelected = branch.id == widget.selectedBranch?.id;
            final langCode = Localizations.localeOf(context).languageCode;

            return Marker(
              markerId: MarkerId(branch.id),
              position: LatLng(branch.lat, branch.lng),
              infoWindow: InfoWindow(
                title: branch.getName(langCode),
                snippet: branch.getAddress(langCode),
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                isSelected
                    ? BitmapDescriptor.hueOrange
                    : BitmapDescriptor.hueRed,
              ),
              onTap: () {
                context.read<LocationCubit>().selectBranch(branch);
                _mapController?.animateCamera(
                  CameraUpdate.newLatLng(LatLng(branch.lat, branch.lng)),
                );
              },
            );
          }).toSet(),
        ),
      ),
    );
  }
}

// lib/featurees/main_screens/location/presentation/views/widgets/branch_info_row.dart

/// صف معلومات الفرع (أيقونة + نص)
class BranchInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const BranchInfoRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primaryColor),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}

// lib/featurees/main_screens/location/presentation/views/widgets/branch_details_section.dart

/// قسم تفاصيل الفرع
class BranchDetailsSection extends StatefulWidget {
  final BranchEntity branch;

  const BranchDetailsSection({super.key, required this.branch});

  @override
  State<BranchDetailsSection> createState() => _BranchDetailsSectionState();
}

class _BranchDetailsSectionState extends State<BranchDetailsSection> {
  int _currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8, initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// تنسيق الوقت
  String _formatTime(String time, BuildContext context) {
    if (time.isEmpty) return "";

    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    try {
      final parts = time.split(':');
      int hour = int.parse(parts[0]);
      final minute = parts[1];

      String period;
      if (isAr) {
        period = hour >= 12 ? "م" : "ص";
      } else {
        period = hour >= 12 ? "PM" : "AM";
      }

      if (hour > 12) hour -= 12;
      if (hour == 0) hour = 12;

      return "$hour:$minute $period";
    } catch (e) {
      return time;
    }
  }

  /// عرض الصورة كاملة الشاشة
  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => Navigator.pop(context),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.black.withOpacity(0.4),
            child: Center(
              child: Hero(
                tag: imageUrl,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.contain,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(color: Colors.white),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.broken_image, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// فتح الخريطة للاتجاهات
  Future<void> _launchMaps(double lat, double lng) async {
    final googleMapsUrl =
        "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving";
    final appleMapsUrl = "https://maps.apple.com/?daddr=$lat,$lng";

    try {
      if (Platform.isIOS) {
        if (await canLaunchUrl(Uri.parse(appleMapsUrl))) {
          await launchUrl(
            Uri.parse(appleMapsUrl),
            mode: LaunchMode.externalApplication,
          );
        }
      } else {
        if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
          await launchUrl(
            Uri.parse(googleMapsUrl),
            mode: LaunchMode.externalApplication,
          );
        } else {
          throw 'Could not open the map.';
        }
      }
    } catch (e) {
      await launchUrl(
        Uri.parse(googleMapsUrl),
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    final lang = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // سلايدر الصور
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.branch.images.length,
            itemBuilder: (context, index) {
              final imgUrl = widget.branch.images[index];
              return GestureDetector(
                onTap: () => _showFullScreenImage(context, imgUrl),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Hero(
                    tag: imgUrl,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: imgUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Container(color: Colors.grey[200]),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 20),

        // اسم الفرع
        Text(widget.branch.getName(langCode), style: AppStyles.titleLora18),

        const Divider(height: 25),

        // معلومات الفرع
        BranchInfoRow(
          icon: Icons.location_on_outlined,
          text: widget.branch.getAddress(langCode),
        ),
        BranchInfoRow(icon: Icons.phone_outlined, text: widget.branch.phone),
        BranchInfoRow(
          icon: Icons.email_outlined,
          text: widget.branch.email.isNotEmpty
              ? widget.branch.email
              : "info@cafe.com",
        ),
        BranchInfoRow(
          icon: Icons.access_time,
          text:
              "${lang.open}: ${_formatTime(widget.branch.openTime, context)} - ${lang.close}: ${_formatTime(widget.branch.closeTime, context)}",
        ),

        const SizedBox(height: 20),

        // زر الاتجاهات
        ElevatedButton.icon(
          icon: const Icon(Icons.directions, color: Colors.white),
          label: Text(
            lang.getDirections,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => _launchMaps(widget.branch.lat, widget.branch.lng),
        ),

        const SizedBox(height: 30),
      ],
    );
  }
}
