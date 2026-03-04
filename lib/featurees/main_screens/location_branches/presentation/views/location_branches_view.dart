// import 'dart:io';
// import 'dart:ui';
// import 'package:appp/core/constans/constans_kword.dart';
// import 'package:appp/featurees/main_screens/home/app_search_field.dart';
// import 'package:appp/featurees/main_screens/home/data/models/branch_model.dart';
// import 'package:appp/featurees/main_screens/home/presentation/views/presentation_layer.dart';
// import 'package:appp/generated/l10n.dart';
// import 'package:appp/utils/app_colors.dart';
// import 'package:appp/utils/app_style.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';

// class LocationView extends StatelessWidget {
//   const LocationView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final homeSelectedBranch = context.read<HomeCubit>().state.selectedBranch;

//     return BlocProvider(
//       create: (context) =>
//           LocationCubit(BranchRepository())
//             ..fetchBranches(homeSelectedBranch: homeSelectedBranch),
//       child: BlocListener<HomeCubit, HomeState>(
//         listenWhen: (previous, current) =>
//             previous.selectedBranch != current.selectedBranch,
//         listener: (context, homeState) {
//           if (homeState.selectedBranch != null) {
//             context.read<LocationCubit>().selectBranch(
//               homeState.selectedBranch!,
//             );
//           }
//         },
//         child: const LocationViewConsumer(),
//       ),
//     );
//   }
// }

// class LocationViewConsumer extends StatelessWidget {
//   const LocationViewConsumer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LocationCubit, LocationState>(
//       builder: (context, state) {
//         if (state is LocationLoading) {
//           return const Scaffold(
//             body: Center(
//               child: CircularProgressIndicator(color: AppColors.primaryColor),
//             ),
//           );
//         } else if (state is LocationError) {
//           return Scaffold(body: Center(child: Text(state.message)));
//         } else if (state is LocationLoaded) {
//           return LocationViewBody(state: state);
//         }
//         return const SizedBox();
//       },
//     );
//   }
// }

// // --- ملف الـ Body ---
// class LocationViewBody extends StatelessWidget {
//   final LocationLoaded state;
//   const LocationViewBody({super.key, required this.state});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: kHorizintalPadding),
//           child: Column(
//             children: [
//               SizedBox(height: 8),
//               const BranchSearchField(),
//               SizedBox(height: 5),
//               Expanded(
//                 child: Stack(
//                   children: [
//                     SingleChildScrollView(
//                       child: Column(
//                         children: [
//                           BranchMapSection(
//                             allBranches: state.allBranches,
//                             selectedBranch: state.selectedBranch,
//                           ),
//                           if (state.selectedBranch != null)
//                             BranchDetailsSection(branch: state.selectedBranch!),
//                         ],
//                       ),
//                     ),
//                     if (state.isSearching && state.filteredBranches.isNotEmpty)
//                       SearchResultsOverlay(
//                         filteredBranches: state.filteredBranches,
//                       ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // // --- ويدجت البحث (BranchSearchField) ---
// class BranchSearchField extends StatelessWidget {
//   const BranchSearchField({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final lang = S.of(context);
//     return AppSearchField(
//       hintText: lang.searchBranch,
//       controller: context.read<LocationCubit>().searchController,
//       // تنفيذ عملية البحث عبر الكيوبيت مباشرة
//       onChanged: (value) {
//         context.read<LocationCubit>().searchBranches(value);
//       },
//     );
//   }
// }

// // --- ويدجت نتائج البحث (SearchResultsOverlay) ---
// class SearchResultsOverlay extends StatelessWidget {
//   final List<BranchModel> filteredBranches;
//   const SearchResultsOverlay({super.key, required this.filteredBranches});

//   @override
//   Widget build(BuildContext context) {
//     String langCode = Localizations.localeOf(context).languageCode;

//     return Positioned(
//       top: 0,
//       left: 16,
//       right: 16,
//       child: Container(
//         constraints: const BoxConstraints(maxHeight: 300),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
//           ],
//         ),
//         child: ListView.separated(
//           shrinkWrap: true,
//           itemCount: filteredBranches.length,
//           separatorBuilder: (context, index) => const Divider(height: 1),
//           itemBuilder: (context, index) {
//             final branch = filteredBranches[index];
//             return ListTile(
//               title: Text(branch.getName(langCode)), // عرض الاسم حسب اللغة
//               subtitle: Text(
//                 branch.getAddress(langCode),
//               ), // عرض العنوان حسب اللغة
//               onTap: () {
//                 context.read<LocationCubit>().selectBranch(branch);
//                 FocusScope.of(context).unfocus();
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// // // --- ويدجت تفاصيل الفرع (BranchDetailsSection) ---
// class BranchDetailsSection extends StatefulWidget {
//   final BranchModel branch;
//   const BranchDetailsSection({super.key, required this.branch});

//   @override
//   State<BranchDetailsSection> createState() => _BranchDetailsSectionState();
// }

// class _BranchDetailsSectionState extends State<BranchDetailsSection> {
//   int _currentPage = 0;
//   late PageController _pageController;

//   @override
//   void initState() {
//     super.initState();
//     // العودة للنمط الأصلي: الصورة الأساسية 80% والباقي للصور الجانبية
//     _pageController = PageController(viewportFraction: 0.8, initialPage: 0);
//   }

//   @override
//   void dispose() {
//     context
//         .read<LocationCubit>()
//         .searchController
//         .dispose(); // تأكد من تنظيف الـ Controller
//     _pageController.dispose();
//     super.dispose();
//   }

//   // تعديل ويدجت BranchDetailsSection
//   @override
//   Widget build(BuildContext context) {
//     String langCode = Localizations.localeOf(context).languageCode;
//     final lang = S.of(context);

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // سلايدر الصور مع تحسين السرعة
//         SizedBox(
//           height: 160,
//           child: PageView.builder(
//             controller: _pageController,
//             itemCount: widget.branch.images.length,
//             itemBuilder: (context, index) {
//               final imgUrl = widget.branch.images[index];
//               return GestureDetector(
//                 onTap: () => _showFullScreenImage(context, imgUrl),

//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                   child: Hero(
//                     tag: imgUrl, // الوسم لعمل الأنيميشن
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: CachedNetworkImage(
//                         // استخدام الكاش للسرعة
//                         imageUrl: imgUrl,
//                         fit: BoxFit.cover,
//                         placeholder: (context, url) =>
//                             Container(color: Colors.grey[200]),
//                         errorWidget: (context, url, error) =>
//                             const Icon(Icons.broken_image),
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),

//         const SizedBox(height: 20),
//         Text(widget.branch.getName(langCode), style: AppStyles.titleLora18),

//         const Divider(height: 25), // الخط الفاصل
//         // المعلومات تحت الخط حسب طلبك
//         _infoRow(
//           Icons.location_on_outlined,
//           widget.branch.getAddress(langCode),
//         ),
//         _infoRow(Icons.phone_outlined, widget.branch.phone),
//         _infoRow(
//           Icons.email_outlined,
//           widget.branch.email ?? "info@cafe.com",
//         ), // إضافة الإيميل
//         _infoRow(
//           Icons.access_time,
//           "${lang.open}: ${_formatTime(widget.branch.openTime, context)} - ${lang.close}: ${_formatTime(widget.branch.closeTime, context)}",
//         ),

//         const SizedBox(height: 20),
//         // --- زر الاتجاهات باللون الموحد ---
//         ElevatedButton.icon(
//           icon: const Icon(Icons.directions, color: Colors.white),
//           label: Text(
//             lang.getDirections,
//             style: const TextStyle(color: Colors.white, fontSize: 16),
//           ),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: AppColors.primaryColor,
//             minimumSize: const Size(double.infinity, 55),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//           onPressed: () => _launchMaps(widget.branch.lat, widget.branch.lng),
//         ),
//         const SizedBox(height: 30),
//       ],
//     );
//   }
//   // دالة مساعدة لتحويل الوقت (ضعها داخل الكلاس أو في ملف Utils)
//   String _formatTime(String time, BuildContext context) {
//     if (time.isEmpty) return "";
//     final isAr = Localizations.localeOf(context).languageCode == 'ar';

//     // نفترض أن الوقت يأتي من Firebase بصيغة "08:00"
//     try {
//       final parts = time.split(':');
//       int hour = int.parse(parts[0]);
//       String minute = parts[1];

//       String period;
//       if (isAr) {
//         period = hour >= 12 ? "م" : "ص";
//       } else {
//         period = hour >= 12 ? "PM" : "AM";
//       }

//       if (hour > 12) hour -= 12;
//       if (hour == 0) hour = 12;

//       return "$hour:$minute $period";
//     } catch (e) {
//       return time; // العودة للقيمة الأصلية في حال الخطأ
//     }
//   }
//   void _showFullScreenImage(BuildContext context, String imageUrl) {
//     showDialog(
//       context: context,
//       builder: (context) => GestureDetector(
//         onTap: () => Navigator.pop(context), // العودة عند الضغط في أي مكان
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // قوة التغبيش
//           child: Container(
//             color: Colors.black.withOpacity(0.4), // تعتيم خفيف للخلفية
//             child: Center(
//               child: Hero(
//                 tag: imageUrl,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(15),
//                     child: CachedNetworkImage(
//                       imageUrl: imageUrl,
//                       fit: BoxFit.contain,
//                       placeholder: (context, url) =>
//                           const CircularProgressIndicator(color: Colors.white),
//                       errorWidget: (context, url, error) =>
//                           const Icon(Icons.broken_image, color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _infoRow(IconData icon, String text) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           Icon(icon, size: 20, color: AppColors.primaryColor),
//           const SizedBox(width: 12),
//           Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
//         ],
//       ),
//     );
//   }

//   Future<void> _launchMaps(double lat, double lng) async {
//     // هذا الرابط يخبر جوجل ماب بأن يفتح وضع "الملاحة" من الموقع الحالي إلى إحداثيات الفرع
//     final String googleMapsUrl =
//         "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving";
//     final String appleMapsUrl = "https://maps.apple.com/?daddr=$lat,$lng";

//     try {
//       if (Platform.isIOS) {
//         if (await canLaunchUrl(Uri.parse(appleMapsUrl))) {
//           await launchUrl(
//             Uri.parse(appleMapsUrl),
//             mode: LaunchMode.externalApplication,
//           );
//         }
//       } else {
//         if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
//           await launchUrl(
//             Uri.parse(googleMapsUrl),
//             mode: LaunchMode.externalApplication,
//           );
//         } else {
//           throw 'Could not open the map.';
//         }
//       }
//     } catch (e) {
//       // إذا فشل فتح التطبيق، نفتحه في المتصفح كحل احتياطي
//       await launchUrl(
//         Uri.parse(googleMapsUrl),
//         mode: LaunchMode.externalApplication,
//       );
//     }
//   }
// }

// class BranchMapSection extends StatefulWidget {
//   final List<BranchModel> allBranches;
//   final BranchModel? selectedBranch;

//   const BranchMapSection({
//     super.key,
//     required this.allBranches,
//     this.selectedBranch,
//   });

//   @override
//   State<BranchMapSection> createState() => _BranchMapSectionState();
// }

// class _BranchMapSectionState extends State<BranchMapSection> {
//   GoogleMapController? _mapController;

//   // دالة لعمل زوم يشمل جميع الماركرز
//   void _zoomToFitAll(List<BranchModel> branches) {
//     if (branches.isEmpty || _mapController == null) return;

//     double minLat = branches.first.lat;
//     double maxLat = branches.first.lat;
//     double minLng = branches.first.lng;
//     double maxLng = branches.first.lng;

//     for (var b in branches) {
//       if (b.lat < minLat) minLat = b.lat;
//       if (b.lat > maxLat) maxLat = b.lat;
//       if (b.lng < minLng) minLng = b.lng;
//       if (b.lng > maxLng) maxLng = b.lng;
//     }

//     _mapController!.animateCamera(
//       CameraUpdate.newLatLngBounds(
//         LatLngBounds(
//           southwest: LatLng(minLat, minLng),
//           northeast: LatLng(maxLat, maxLng),
//         ),
//         50, // Padding حول الماركرز
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 280,
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(15),
//           bottomRight: Radius.circular(15),
//         ),
//         boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(15),
//           bottomRight: Radius.circular(15),
//         ),
//         child: GoogleMap(
//           gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
//             Factory<OneSequenceGestureRecognizer>(
//               () => EagerGestureRecognizer(),
//             ),
//           },
//           // تفعيل إيماءات الحركة لضمان سهولة التحريك يميناً ويساراً
//           rotateGesturesEnabled: true,
//           scrollGesturesEnabled: true,
//           tiltGesturesEnabled: true,
//           zoomGesturesEnabled: true,

//           initialCameraPosition: CameraPosition(
//             target: widget.selectedBranch != null
//                 ? LatLng(widget.selectedBranch!.lat, widget.selectedBranch!.lng)
//                 : const LatLng(15.350, 44.200),
//             zoom: 10, //12, // تقليل الزوم الابتدائي ليشمل منطقة أوسع
//           ),
//           onMapCreated: (controller) {
//             _mapController = controller;
//             // أول ما تفتح الخريطة، سوي زوم يشمل الكل
//             _zoomToFitAll(widget.allBranches);
//           },
//           markers: widget.allBranches.map((branch) {
//             bool isSelected = branch.id == widget.selectedBranch?.id;
//             String langCode = Localizations.localeOf(context).languageCode;

//             return Marker(
//               markerId: MarkerId(branch.id),
//               position: LatLng(branch.lat, branch.lng),
//               infoWindow: InfoWindow(
//                 title: branch.getName(langCode),
//                 snippet: branch.getAddress(langCode),
//               ),
//               icon: BitmapDescriptor.defaultMarkerWithHue(
//                 isSelected
//                     ? BitmapDescriptor.hueOrange
//                     : BitmapDescriptor.hueRed,
//               ),
//               onTap: () {
//                 context.read<LocationCubit>().selectBranch(branch);
//                 // عند الضغط على ماركر، نركز الكاميرا عليه
//                 _mapController?.animateCamera(
//                   CameraUpdate.newLatLng(LatLng(branch.lat, branch.lng)),
//                 );
//               },
//             );
//           }).toSet(),
//         ),
//       ),
//     );
//   }
// }

// class BranchRepository {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // جلب جميع الفروع من كولكشن branches
//   Future<List<BranchModel>> getAllBranches() async {
//     try {
//       // جلب البيانات مع ترتيبها حسب الاسم مثلاً
//       final QuerySnapshot snapshot = await _firestore
//           .collection('branches')
//           .orderBy('name')
//           .get();

//       if (snapshot.docs.isEmpty) {
//         return [];
//       }

//       return snapshot.docs.map((doc) => BranchModel.fromDoc(doc)).toList();
//     } on FirebaseException catch (e) {
//       // معالجة أخطاء الفايربيس تحديداً
//       throw Exception("فشل الاتصال بقاعدة البيانات: ${e.message}");
//     } catch (e) {
//       // معالجة أي خطأ غير متوقع
//       throw Exception("حدث خطأ غير متوقع: $e");
//     }
//   }
// }

// abstract class LocationState {}

// class LocationLoading extends LocationState {}

// class LocationLoaded extends LocationState {
//   final List<BranchModel> allBranches;
//   final List<BranchModel> filteredBranches;
//   final BranchModel? selectedBranch;
//   final bool isSearching;

//   LocationLoaded({
//     required this.allBranches,
//     required this.filteredBranches,
//     this.selectedBranch,
//     this.isSearching = false,
//   });
// }

// class LocationError extends LocationState {
//   final String message;
//   LocationError(this.message);
// }

// class LocationCubit extends Cubit<LocationState> {
//   final BranchRepository repository;
//   final TextEditingController searchController =
//       TextEditingController(); // تعريفها في الأعلى

//   LocationCubit(this.repository) : super(LocationLoading());

//   List<BranchModel> _allBranches = [];

//   @override
//   Future<void> close() {
//     searchController.dispose();
//     return super.close();
//   }

//   void fetchBranches({BranchModel? homeSelectedBranch}) async {
//     try {
//       if (isClosed) return; // حماية أولية
//       emit(LocationLoading());

//       _allBranches = await repository.getAllBranches();

//       if (isClosed) return; // حماية بعد جلب البيانات من الإنترنت

//       emit(
//         LocationLoaded(
//           allBranches: _allBranches,
//           filteredBranches: [],
//           selectedBranch:
//               homeSelectedBranch ??
//               (_allBranches.isNotEmpty ? _allBranches.first : null),
//           isSearching: false,
//         ),
//       );
//     } catch (e) {
//       if (!isClosed) emit(LocationError(e.toString()));
//     }
//   }

//   void searchBranches(String query) {
//     if (isClosed || state is! LocationLoaded) return; // حماية

//     final currentState = state as LocationLoaded;
//     if (query.isEmpty) {
//       emit(currentState.copyWith(filteredBranches: [], isSearching: false));
//       return;
//     }
//     final filtered = _allBranches
//         .where(
//           (b) =>
//               b.name.toLowerCase().contains(query.toLowerCase()) ||
//               b.nameAr.contains(query),
//         )
//         .toList();

//     emit(currentState.copyWith(filteredBranches: filtered, isSearching: true));
//   }

//   void clearSearch() {
//     searchController.clear();
//     // إعادة الحالة لوضعها الطبيعي بدون بحث
//     if (state is LocationLoaded) {
//       emit(
//         (state as LocationLoaded).copyWith(
//           filteredBranches: [],
//           isSearching: false,
//         ),
//       );
//     }
//   }

//   void selectBranch(BranchModel branch) {
//     if (isClosed || state is! LocationLoaded) return;
//     emit(
//       (state as LocationLoaded).copyWith(
//         selectedBranch: branch,
//         isSearching: false,
//         filteredBranches: [],
//       ),
//     );
//   }
// }

// // إضافة دالة copyWith للـ LocationLoaded لتسهيل التحديث
// extension LocationLoadedX on LocationLoaded {
//   LocationLoaded copyWith({
//     List<BranchModel>? allBranches,
//     List<BranchModel>? filteredBranches,
//     BranchModel? selectedBranch,
//     bool? isSearching,
//   }) {
//     return LocationLoaded(
//       allBranches: allBranches ?? this.allBranches,
//       filteredBranches: filteredBranches ?? this.filteredBranches,
//       selectedBranch: selectedBranch ?? this.selectedBranch,
//       isSearching: isSearching ?? this.isSearching,
//     );
//   }
// }
