import 'dart:async';
import 'dart:math' as math;

import 'package:appp/core/constans/constans_kword.dart';
import 'package:appp/core/services/get_it_services.dart';
import 'package:appp/featurees/Auth/presenatation/views/longin/presentation/views/login_view.dart';
import 'package:appp/featurees/Auth/presenatation/views/signUp/presentation/views/signup_view.dart';
import 'package:appp/featurees/main_screens/favorite/presentation/cubit/favorites_cubit.dart';
import 'package:appp/featurees/main_screens/favorite/presentation/cubit/favorites_state.dart';
import 'package:appp/featurees/main_screens/home/presentation/views/data_layer.dart';
import 'package:appp/featurees/main_screens/home/presentation/views/domain_layer.dart';
import 'package:appp/featurees/main_screens/home/presentation/widgets/product_grid_view_item.dart';
import 'package:appp/featurees/main_screens/notification/presentation/views/notification_presentation_layer.dart';
import 'package:appp/featurees/main_screens/notification/presentation/views/notification_view.dart';
import 'package:appp/featurees/main_screens/productdetails/presentation/views/details_presentation_layer.dart';
import 'package:appp/featurees/main_screens/productdetails/presentation/views/product_details_view.dart';
import 'package:appp/generated/l10n.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

/// أنواع الترتيب المتاحة للمنتجات
enum ProductSort { none, priceLowToHigh, priceHighToLow, topRated }

/// حالة الصفحة الرئيسية - تحتوي على جميع البيانات
class HomeState extends Equatable {
  final List<BranchEntity> branches;
  final BranchEntity? selectedBranch;
  final List<CategoryEntity> categories;
  final String selectedCategoryId;
  final List<ProductEntity> products;
  final bool loading;
  final String searchQuery;
  final String? errorMessage;
  final bool isLocationLoading;
  final ProductSort sortType;

  // ✅ بيانات المستخدم (للعرض في الـ AppBar)
  final String? userImage;
  final String? userName;
  final bool isGuest;

  const HomeState({
    this.branches = const [],
    this.selectedBranch,
    this.categories = const [],
    this.selectedCategoryId = 'all',
    this.products = const [],
    this.loading = false,
    this.searchQuery = '',
    this.errorMessage,
    this.isLocationLoading = false,
    this.sortType = ProductSort.none,
    this.userImage,
    this.userName,
    this.isGuest = true, // افتراضياً يعتبر زائر حتى يثبت العكس
  });

  /// إنشاء نسخة جديدة مع تحديث بعض الحقول
  HomeState copyWith({
    List<BranchEntity>? branches,
    BranchEntity? selectedBranch,
    List<CategoryEntity>? categories,
    String? selectedCategoryId,
    List<ProductEntity>? products,
    bool? loading,
    String? searchQuery,
    String? errorMessage,
    bool? isLocationLoading,
    ProductSort? sortType,
    String? userImage,
    String? userName,
    bool? isGuest,
  }) {
    return HomeState(
      branches: branches ?? this.branches,
      selectedBranch: selectedBranch ?? this.selectedBranch,
      categories: categories ?? this.categories,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      products: products ?? this.products,
      loading: loading ?? this.loading,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
      isLocationLoading: isLocationLoading ?? this.isLocationLoading,
      sortType: sortType ?? this.sortType,
      userImage: userImage ?? this.userImage,
      userName: userName ?? this.userName,
      isGuest: isGuest ?? this.isGuest,
    );
  }

  @override
  List<Object?> get props => [
    branches,
    selectedBranch,
    categories,
    selectedCategoryId,
    products,
    loading,
    searchQuery,
    errorMessage,
    isLocationLoading,
    sortType,
    userImage,
    userName,
    isGuest,
  ];
}

// lib/presentation/cubit/home/home_cubit.dart
/// Cubit المسؤول عن منطق الصفحة الرئيسية
class HomeCubit extends Cubit<HomeState> {
  final HomeRepository repository;
  StreamSubscription<List<ProductEntity>>? _productsSub;
  final TextEditingController searchController = TextEditingController();
  StreamSubscription? _userSubscription; // للاستماع لتغييرات المستخدم

  HomeCubit({required this.repository}) : super(const HomeState()) {
    _initUserData(); // بدء مراقبة بيانات المستخدم عند إنشاء الكيوبت
  }

  /// بدء الاستماع لتغييرات بيانات المستخدم (إذا كان مسجلاً)
  void _initUserData() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // مستخدم زائر
      emit(state.copyWith(isGuest: true, userImage: null, userName: null));
      return;
    }

    // مستخدم مسجل – نستمع لتغييرات صورته واسمه
    emit(state.copyWith(isGuest: false));
    _userSubscription = FirebaseFirestore.instance
        .collection('user_information')
        .doc(user.uid)
        .snapshots()
        .listen(
          (snapshot) {
            if (!isClosed) {
              final data = snapshot.data();
              emit(
                state.copyWith(
                  userImage: data?['profile_image'] ?? '',
                  userName: data?['user_name'] ?? '',
                ),
              );
            }
          },
          onError: (error) {
            print('Error listening to user data: $error');
          },
        );
  }

  /// حفظ آخر فرع تم اختياره في SharedPreferences
  Future<void> _saveSelectedBranch(String branchId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_branch_id', branchId);
  }

  /// تحميل البيانات الأولية للصفحة
  Future<void> loadInitialData() async {
    if (isClosed) return;

    emit(state.copyWith(loading: true));

    // جلب الفروع
    final branches = await repository.fetchBranches();
    if (isClosed) return;

    if (branches.isEmpty) {
      emit(state.copyWith(loading: false));
      return;
    }

    // استرجاع آخر فرع تم اختياره
    final prefs = await SharedPreferences.getInstance();
    final savedBranchId = prefs.getString('last_branch_id');

    BranchEntity? selected;
    if (savedBranchId != null) {
      selected = branches.firstWhere(
        (b) => b.id == savedBranchId,
        orElse: () => branches.first,
      );
    } else {
      if (!isClosed) emit(state.copyWith(isLocationLoading: true));
      selected = await _findNearestBranch(branches);
      if (isClosed) return;
      emit(state.copyWith(isLocationLoading: false));

      if (selected != null) {
        await prefs.setString('last_branch_id', selected.id);
      }
    }

    // جلب الأقسام للفرع المختار
    final categories = await repository.fetchCategoriesForBranch(selected!.id);
    if (isClosed) return;

    emit(
      state.copyWith(
        branches: branches,
        selectedBranch: selected,
        categories: categories,
        loading: false,
      ),
    );

    _listenProducts();
  }

  /// إيجاد أقرب فرع بناءً على موقع المستخدم
  Future<BranchEntity?> _findNearestBranch(List<BranchEntity> branches) async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition();

        BranchEntity nearest = branches.first;
        double minDistance = double.maxFinite;

        for (var branch in branches) {
          double distance = Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            branch.lat,
            branch.lng,
          );

          if (distance < minDistance) {
            minDistance = distance;
            nearest = branch;
          }
        }
        return nearest;
      }
    } catch (e) {
      print("Error getting location: $e");
    }
    return branches.first;
  }

  /// اختيار فرع معين
  Future<void> selectBranch(BranchEntity branch) async {
    if (isClosed) return;

    emit(state.copyWith(loading: true));

    final categories = await repository.fetchCategoriesForBranch(branch.id);
    if (isClosed) return;

    emit(
      state.copyWith(
        selectedBranch: branch,
        categories: categories,
        selectedCategoryId: 'all',
        loading: false,
      ),
    );

    await _saveSelectedBranch(branch.id);
    _listenProducts();
  }

  /// الاستماع للتحديثات المباشرة للمنتجات
  void _listenProducts() {
    _productsSub?.cancel();

    _productsSub = repository
        .watchProducts(
          branchId: state.selectedBranch!.id,
          categoryId: state.selectedCategoryId,
        )
        .listen(
          (products) {
            if (!isClosed) {
              emit(state.copyWith(products: products, loading: false));
            }
          },
          onError: (error) {
            if (!isClosed) {
              emit(state.copyWith(errorMessage: error.toString()));
            }
          },
        );
  }

  /// اختيار قسم معين
  void selectCategory(String id) {
    if (state.selectedCategoryId == id) return;
    emit(state.copyWith(selectedCategoryId: id, products: []));
    _listenProducts();
  }

  /// البحث في المنتجات
  Future<void> search(String query) async {
    if (isClosed) return;

    emit(state.copyWith(searchQuery: query));

    if (query.trim().isEmpty) {
      _listenProducts();
      return;
    }

    _productsSub?.cancel();

    try {
      final result = await repository.searchProducts(
        branchId: state.selectedBranch!.id,
        queryText: query,
      );

      if (!isClosed) {
        emit(state.copyWith(products: result, loading: false));
      }
    } catch (e) {
      print("Search Error: $e");
    }
  }

  /// مسح البحث
  void clearSearch() {
    searchController.clear();
    search("");
  }

  /// ترتيب المنتجات
  void sortProducts(ProductSort sort) {
    if (isClosed) return;

    emit(state.copyWith(sortType: sort));

    List<ProductEntity> sortedList = List.from(state.products);

    switch (sort) {
      case ProductSort.priceLowToHigh:
        sortedList.sort((a, b) => a.price.compareTo(b.price));
        break;
      case ProductSort.priceHighToLow:
        sortedList.sort((a, b) => b.price.compareTo(a.price));
        break;
      case ProductSort.topRated:
        // يمكن إضافة ترتيب حسب التقييم لاحقاً
        break;
      default:
        _listenProducts();
        return;
    }

    emit(state.copyWith(products: sortedList));
  }

  @override
  Future<void> close() {
    searchController.dispose();
    _productsSub?.cancel();
    _userSubscription?.cancel(); // إلغاء الاشتراك
    return super.close();
  }
}

// lib/featurees/main_screens/home/presentation/views/home_view.dart

/// الصفحة الرئيسية - نقطة الدخول
class HomeView extends StatelessWidget {
  final String? uid; // ✅ اختيارية

  const HomeView({super.key, this.uid}); // ✅ اختيارية

  @override
  Widget build(BuildContext context) {
    // ✅ إذا كان المستخدم مسجل، شغّل الإشعارات (بدون force unwrap)
    if (uid != null) {
      try {
        final notificationsCubit = getIt<NotificationsCubit>();
        notificationsCubit.startListening(uid!);
      } catch (e) {
        print('Error starting notifications: $e');
      }
    }

    // ✅ استخدام BlocProvider.value فقط إذا كان uid موجود
    if (uid != null) {
      try {
        final notificationsCubit = getIt<NotificationsCubit>();
        return BlocProvider.value(
          value: notificationsCubit,
          child: SafeArea(child: HomeViewConsumer(uid: uid)),
        );
      } catch (e) {
        print('Error providing notifications: $e');
        // إذا فشل، نعرض بدون NotificationsCubit
        return SafeArea(child: HomeViewConsumer(uid: uid));
      }
    }

    // ✅ للزوار، نعرض بدون NotificationsCubit
    return SafeArea(child: HomeViewConsumer(uid: uid));
  }
}
// lib/featurees/main_screens/home/presentation/views/home_view_consumer.dart

/// المستهلك - يتفاعل مع تغييرات الحالة
class HomeViewConsumer extends StatelessWidget {
  final String? uid; // ✅ اختيارية

  const HomeViewConsumer({super.key, this.uid}); // ✅ اختيارية

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          // يمكن إضافة SnackBar هنا لعرض الخطأ
        }
      },
      builder: (context, state) {
        // ModalProgressHUD يظهر فقط عند التحميل الكلي (أول مرة)
        return ModalProgressHUD(
          inAsyncCall: state.loading && state.products.isEmpty,
          child: HomeViewBody(uid: uid),
        );
      },
    );
  }
}

// lib/featurees/main_screens/home/presentation/views/home_view_body.dart

/// جسم الصفحة الرئيسية
class HomeViewBody extends StatelessWidget {
  final String? uid; // ✅ اختيارية

  const HomeViewBody({super.key, this.uid}); // ✅ اختيارية

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    final lang = S.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kHorizintalPadding),
      child: CustomScrollView(
        slivers: [
          // الهيدر الثابت
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              minHeight: 60.0,
              maxHeight: 60.0,
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: HomeAppBar(
                  title: lang.ramsaCafe,
                  uid: uid,
                ), // ✅ تمرير uid
              ),
            ),
          ),

          // البحث واختيار الفرع
          SliverToBoxAdapter(
            child: Column(
              children: [
                const BranchSelectorDropdown(),
                const SizedBox(height: 5),
                AppSearchWithFilter(
                  controller: cubit.searchController,
                  onChanged: cubit.search,
                ),
                HomeSectionTitle(title: lang.exploreCategories),
              ],
            ),
          ),

          // قائمة الأقسام (ثابتة عند الرفع)
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              minHeight: 55.0,
              maxHeight: 55.0,
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: const CategoryListView(),
              ),
            ),
          ),

          // المنتجات
          SliverToBoxAdapter(
            child: HomeSectionTitle(title: lang.featuredProducts),
          ),

          // شبكة المنتجات
          const SliverPadding(
            padding: EdgeInsets.only(bottom: 20),
            sliver: ProductGridViewItem(),
          ),
        ],
      ),
    );
  }
}

// lib/featurees/main_screens/home/presentation/views/widgets/home_app_bar.dart
/// شريط التطبيق العلوي
/// Top app bar widget
class HomeAppBar extends StatelessWidget {
  final String title;
  final String? uid; // معرف المستخدم (قد يكون null للزوار)

  const HomeAppBar({super.key, required this.title, this.uid});

  @override
  Widget build(BuildContext context) {
    // final lang = S.of(context);
    final isGuest = uid == null; // زائر إذا لم يوجد uid

    return Container(
      height: 60,
      padding: const EdgeInsets.only(top: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // عنوان الكافيه في المنتصف
          Center(child: Text(title, style: AppStyles.titleLora18)),

          // الأيقونات على اليسار (أو اليمين حسب اللغة)
          PositionedDirectional(
            end: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // أيقونة الإشعارات - تظهر فقط للمسجلين
                if (!isGuest) const NotificationBadgeIcon(),

                if (!isGuest) const SizedBox(width: 8),

                // صورة الملف الشخصي (تعتمد على isGuest والبيانات من HomeCubit)
                _buildProfileAvatar(context, isGuest),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// بناء الصورة الرمزية للمستخدم
  Widget _buildProfileAvatar(BuildContext context, bool isGuest) {
    if (isGuest) {
      // زائر: نعرض الصورة الافتراضية وتؤدي إلى صفحة التسجيل عند الضغط
      return GestureDetector(
        onTap: () => _showGuestDialog(context),
        child: _buildDefaultAvatar(),
      );
    }

    // مستخدم مسجل: نعرض الصورة من الحالة (إن وجدت) وإلا الافتراضية
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final imageUrl = state.userImage;
        if (imageUrl != null && imageUrl.isNotEmpty) {
          return _buildNetworkAvatar(imageUrl);
        } else {
          return _buildDefaultAvatar();
        }
      },
    );
  }

  /// الصورة الافتراضية (للزوار أو عند عدم وجود صورة)
  Widget _buildDefaultAvatar() {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 1.0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const CircleAvatar(
        radius: 16,
        backgroundColor: Colors.grey,
        backgroundImage: NetworkImage(
          'https://th.bing.com/th/id/R.b2b34517339101a111716be1c203f354?rik=e5WHTShSpipi3Q&pid=ImgRaw&r=0',
        ),
      ),
    );
  }

  /// صورة من الشبكة باستخدام CachedNetworkImage
  Widget _buildNetworkAvatar(String imageUrl) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 1.0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: CircleAvatar(
        radius: 16,
        backgroundColor: Colors.grey[200],
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            width: 32,
            height: 32,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) =>
                const Icon(Icons.person, size: 20, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  /// عرض حوار للزائر لتشجيعه على التسجيل
  void _showGuestDialog(BuildContext context) {
    final lang = S.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(lang.profile),
        content: Text(lang.guestProfileMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(lang.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SignupView()),
              );
            },
            child: Text(lang.signUp),
          ),
        ],
      ),
    );
  }
}

/// كلاس مساعد لجعل أي Widget تلتصق في الأعلى
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

// lib/presentation/views/home/widgets/notification_badge_icon.dart

/// أيقونة الإشعارات مع العداد
class NotificationBadgeIcon extends StatelessWidget {
  const NotificationBadgeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ التحقق من وجود NotificationsCubit
    try {
      final cubit = context.read<NotificationsCubit>();

      return BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          return Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, size: 28),
                color: AppColors.blackColor,
                onPressed: () {
                  final notifCubit = context.read<NotificationsCubit>();

                  FocusManager.instance.primaryFocus?.unfocus();
                  context.read<HomeCubit>().clearSearch();

                  // الانتقال لصفحة الإشعارات
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: notifCubit,
                        child: const NotificationsView(),
                      ),
                    ),
                  );
                },
              ),

              // النقطة الحمراء مع العداد
              if (state.unreadCount > 0)
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${state.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          );
        },
      );
    } catch (e) {
      // ✅ إذا كان المستخدم زائر (لا يوجد NotificationsCubit)، اعرض أيقونة تؤدي للتسجيل
      return IconButton(
        icon: const Icon(Icons.notifications_none, size: 28),
        color: AppColors.blackColor,
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          context.read<HomeCubit>().clearSearch();

          // ✅ توجيه الزائر إلى صفحة التسجيل
          _showGuestDialog(context);
        },
      );
    }
  }

  /// عرض رسالة للزائر وتوجيهه للتسجيل
  void _showGuestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).notifications),
        content: Text(
          'للوصول إلى الإشعارات، الرجاء تسجيل الدخول أو إنشاء حساب جديد',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.of(context).cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SignupView()),
              );
            },
            child: Text(S.of(context).signUp),
          ),
        ],
      ),
    );
  }
}

// lib/presentation/views/home/widgets/branch_selector_dropdown.dart

/// قائمة منسدلة لاختيار الفرع
class BranchSelectorDropdown extends StatelessWidget {
  const BranchSelectorDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final branches = state.branches;
        final selected = state.selectedBranch;

        // الحصول على رمز اللغة الحالي
        final String langCode = Localizations.localeOf(context).languageCode;
        final lang = S.of(context);

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.backgroundGraybutton,
            border: Border.all(color: AppColors.borderColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Icon(
                  LucideIcons.mapPin,
                  color: AppColors.GrayIconColor,
                  size: 16,
                ),
              ),
              Expanded(
                flex: 10,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<BranchEntity>(
                    isExpanded: true,
                    value: selected,
                    hint: Text(lang.selectBranch),
                    dropdownColor: AppColors.whiteColor,
                    items: branches.map((b) {
                      final isOnline = b.status == 'online';
                      return DropdownMenuItem(
                        value: b,
                        child: Text(
                          b.getName(langCode),
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.InriaSerif_14.copyWith(
                            color: isOnline ? Colors.green : Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                    selectedItemBuilder: (context) => branches.map((b) {
                      final isSelected = selected?.id == b.id;
                      return Align(
                        alignment: langCode == 'ar'
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Text(
                          b.getName(langCode),
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.InriaSerif_14.copyWith(
                            color: isSelected
                                ? (b.status == 'online'
                                      ? Colors.green
                                      : Colors.red)
                                : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (b) {
                      if (b != null) {
                        context.read<HomeCubit>().selectBranch(b);
                      }
                    },
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.GrayIconColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () async {
                  if (selected?.phone != null && selected!.phone.isNotEmpty) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    context.read<HomeCubit>().clearSearch();

                    final Uri launchUri = Uri(
                      scheme: 'tel',
                      path: selected.phone,
                    );

                    if (await canLaunchUrl(launchUri)) {
                      await launchUrl(launchUri);
                    }
                  }
                },
                child: Icon(
                  LucideIcons.phoneCall,
                  size: 16,
                  color: selected?.status == 'online'
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// lib/presentation/views/home/widgets/search_with_filter.dart

/// حقل البحث مع زر الفلتر
class AppSearchWithFilter extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const AppSearchWithFilter({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Row(
      children: [
        Expanded(
          child: AppSearchField(
            controller: controller,
            hintText: S.of(context).searchHint,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(width: 10),
        Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: PopupMenuButton<ProductSort>(
            constraints: const BoxConstraints(minWidth: 220, maxWidth: 250),
            padding: EdgeInsets.zero,
            position: PopupMenuPosition.under,
            offset: const Offset(0, 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: AppColors.borderColor.withOpacity(0.5)),
            ),
            color: Colors.white,
            elevation: 8,
            icon: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.tune, color: Colors.white, size: 20),
            ),
            onSelected: (ProductSort sort) => cubit.sortProducts(sort),
            itemBuilder: (context) => [
              _buildPopupItem(
                context,
                value: ProductSort.priceLowToHigh,
                icon: LucideIcons.arrowUpNarrowWide,
                title: isAr ? "السعر: من الأقل للأعلى" : "Price: Low to High",
              ),
              PopupMenuDivider(height: 1),
              _buildPopupItem(
                context,
                value: ProductSort.priceHighToLow,
                icon: LucideIcons.arrowDownWideNarrow,
                title: isAr ? "السعر: من الأعلى للأقل" : "Price: High to Low",
              ),
              const PopupMenuDivider(height: 1),
              _buildPopupItem(
                context,
                value: ProductSort.none,
                icon: Icons.restart_alt_rounded,
                title: isAr ? "إعادة الضبط" : "Reset Filter",
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// بناء عنصر القائمة المنبثقة
  PopupMenuItem<ProductSort> _buildPopupItem(
    BuildContext context, {
    required ProductSort value,
    required IconData icon,
    required String title,
  }) {
    return PopupMenuItem<ProductSort>(
      value: value,
      height: 50,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primaryColor, size: 18),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: AppStyles.InriaSerif_14.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// lib/presentation/views/home/widgets/app_search_field.dart

/// حقل البحث المخصص
class AppSearchField extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final EdgeInsetsGeometry? margin;

  const AppSearchField({
    super.key,
    required this.hintText,
    this.onChanged,
    this.controller,
    this.margin,
  });

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  late TextEditingController _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = widget.controller ?? TextEditingController();
    _internalController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      margin: widget.margin ?? const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundGraybutton,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          const Icon(
            LucideIcons.search,
            color: AppColors.GrayIconColor,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _internalController,
              style: AppStyles.InriaSerif_14.copyWith(color: Colors.black),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: AppStyles.InriaSerif_14,
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
              onChanged: widget.onChanged,
            ),
          ),
          if (_internalController.text.isNotEmpty)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                _internalController.clear();
                if (widget.onChanged != null) widget.onChanged!("");
              },
              child: Container(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 5,
                  top: 10,
                  bottom: 10,
                ),
                child: const Icon(Icons.close, color: Colors.grey, size: 18),
              ),
            ),
        ],
      ),
    );
  }
}

/// عنوان القسم في الصفحة الرئيسية
class HomeSectionTitle extends StatelessWidget {
  final String title;

  const HomeSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 10),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(title, style: AppStyles.titleLora18),
      ),
    );
  }
}

// lib/presentation/views/home/widgets/category_list_view.dart

/// قائمة الأقسام الأفقية
class CategoryListView extends StatelessWidget {
  const CategoryListView({super.key});

  /// دالة ذكية لاختيار الأيقونة بناءً على اسم القسم
  IconData _getCategoryIcon(String name) {
    final lowerName = name.toLowerCase();

    if (lowerName.contains('all') || lowerName.contains('الكل')) {
      return LucideIcons.layers;
    } else if (lowerName.contains('hot') ||
        lowerName.contains('حارة') ||
        lowerName.contains('coffee')) {
      return LucideIcons.coffee;
    } else if (lowerName.contains('cold') || lowerName.contains('باردة')) {
      return LucideIcons.glassWater;
    } else if (lowerName.contains('dessert') || lowerName.contains('حلويات')) {
      return LucideIcons.cake;
    } else if (lowerName.contains('sandwiches') ||
        lowerName.contains('سندوتشات')) {
      return LucideIcons.sandwich;
    } else if (lowerName.contains('baked') || lowerName.contains('مخبوزات')) {
      return LucideIcons.croissant;
    } else if (lowerName.contains('drip') || lowerName.contains('مقطرة')) {
      return LucideIcons.droplets;
    } else {
      return LucideIcons.utensils;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final lang = S.of(context);
        final isAr = Localizations.localeOf(context).languageCode == 'ar';
        final cats = state.categories;
        final selected = state.selectedCategoryId;

        final items = [
          {'id': 'all', 'name': lang.all},
          ...cats.map((c) => {'id': c.id, 'name': isAr ? c.nameAr : c.name}),
        ];

        return SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final item = items[index];
              final String itemName = item['name'] as String;
              final bool isSelected = item['id'] == selected;

              return GestureDetector(
                onTap: () {
                  context.read<HomeCubit>().selectCategory(
                    item['id'] as String,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryColor
                        : AppColors.backgroundGraybutton,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getCategoryIcon(itemName),
                        color: isSelected ? Colors.white : AppColors.blackColor,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isAr ? itemName : capitalize(itemName),
                        style: AppStyles.InriaSerif_14.copyWith(
                          color: isSelected
                              ? Colors.white
                              : AppColors.blackColor,
                          height: 2,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
// lib/featurees/main_screens/home/presentation/views/widgets/product_grid_view_item.dart

/// شبكة عرض المنتجات
class ProductGridViewItem extends StatelessWidget {
  const ProductGridViewItem({super.key});

  @override
  Widget build(BuildContext context) {
    // الحصول على الـ UID من مكان أعلى
    final String? currentUid = (context
        .findAncestorWidgetOfExactType<HomeViewBody>()
        ?.uid);
    final lang = S.of(context);

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final products = state.products;

        if (state.loading && state.products.isEmpty) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (products.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Text(lang.noProductsFound, style: AppStyles.titleLora18),
              ),
            ),
          );
        }

        final deviceWidth = MediaQuery.of(context).size.width;
        final crossAxisCount = deviceWidth < 600 ? 2 : 3;

        return SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 0.78,
          ),
          delegate: SliverChildBuilderDelegate((context, index) {
            final product = products[index];
            return ProductCard(
              key: ValueKey(product.id),
              product: product,
              uid: currentUid, // ✅ تمرير uid (قد يكون null)
            );
          }, childCount: products.length),
        );
      },
    );
  }
}
// lib/featurees/main_screens/home/presentation/views/widgets/custom_product_image_and_favorite_icon.dart

/// صورة المنتج مع أيقونة المفضلة
class CustomProductImageandFavoriteIcon extends StatelessWidget {
  final ProductEntity product;
  final String? uid; // ✅ اختيارية

  const CustomProductImageandFavoriteIcon({
    super.key,
    required this.product,
    this.uid, // ✅ اختيارية
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // الصورة
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          child: product.imageUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: product.imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 130,
                    color: Colors.grey[100],
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )
              : Container(height: 130, color: AppColors.whiteColor),
        ),

        // ✅ زر المفضلة - يظهر فقط للمستخدمين المسجلين
        if (uid != null)
          Positioned(right: 8, top: 8, child: _buildFavoriteButton(context)),
      ],
    );
  }

  // زر المفضلة مع معالجة الأخطاء
  Widget _buildFavoriteButton(BuildContext context) {
    // نحاول العثور على FavoritesCubit
    try {
      // هذا السطر سينجح فقط إذا كان FavoritesCubit موجود
      context.read<FavoritesCubit>();

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _toggleFavorite(context),
        child: BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, state) {
            final isFavorite = state.favorites.any(
              (f) => f.productId == product.id,
            );

            return Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                size: 20,
                color: isFavorite
                    ? Colors.red
                    : AppColors.primaryColor.withOpacity(0.7),
              ),
            );
          },
        ),
      );
    } catch (e) {
      // إذا لم يوجد FavoritesCubit، اعرض زر يؤدي للتسجيل
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _showGuestDialog(context),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.favorite_border,
            size: 20,
            color: AppColors.primaryColor,
          ),
        ),
      );
    }
  }

  // تبديل حالة المفضلة للمستخدمين المسجلين
  void _toggleFavorite(BuildContext context) {
    try {
      context.read<FavoritesCubit>().toggleFavorite(product);
    } catch (e) {
      _showGuestDialog(context);
    }
  }

  // عرض رسالة للزائر
  void _showGuestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('المفضلة'),
        content: const Text(
          'لإضافة المنتجات إلى المفضلة، الرجاء تسجيل الدخول أو إنشاء حساب جديد',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.of(context).cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginView()),
              );
            },
            child: Text(S.of(context).login),
          ),
        ],
      ),
    );
  }
}
// lib/featurees/main_screens/home/presentation/views/widgets/product_card.dart

/// بطاقة عرض المنتج
class ProductCard extends StatefulWidget {
  final ProductEntity product;
  final String? uid; // ✅ اختيارية للزوار

  const ProductCard({
    super.key,
    required this.product,
    this.uid, // ✅ اختيارية
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  ProductSizeEntity? selectedSize;

  /// ترتيب الأحجام (S -> M -> L)
  List<ProductSizeEntity> _sortSizes(List<ProductSizeEntity> sizes) {
    const order = {'s': 1, 'm': 2, 'l': 3, 'xl': 4};
    List<ProductSizeEntity> sortedList = List.from(sizes);
    sortedList.sort((a, b) {
      int valA = order[a.size.toLowerCase()] ?? 99;
      int valB = order[b.size.toLowerCase()] ?? 99;
      return valA.compareTo(valB);
    });
    return sortedList;
  }

  /// إعداد الحجم المختار تلقائياً
  void _setupInitialSize() {
    if (widget.product.sizes.isNotEmpty) {
      final filtered = widget.product.sizes
          .where((s) => s.size.toLowerCase() != 'onesize')
          .toList();

      final sorted = _sortSizes(filtered);

      if (sorted.isNotEmpty) {
        setState(() {
          selectedSize = sorted.first;
        });
      }
    } else {
      setState(() {
        selectedSize = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _setupInitialSize();
  }

  @override
  void didUpdateWidget(covariant ProductCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.product.id != widget.product.id) {
      _setupInitialSize();
    }
  }

  @override
  Widget build(BuildContext context) {
    // تصفية وترتيب الأحجام للعرض
    final filteredSizes = widget.product.sizes
        .where((s) => s.size.toLowerCase() != 'onesize')
        .toList();

    final sortedSizes = _sortSizes(filteredSizes);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    // تحديد السعر
    final currentPrice = selectedSize != null
        ? selectedSize!.price
        : widget.product.price;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        context.read<HomeCubit>().clearSearch();

        // ✅ الانتقال لصفحة تفاصيل المنتج (متاحة للجميع)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailsView(product: widget.product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ صورة المنتج مع زر المفضلة (uid قد يكون null)
            CustomProductImageandFavoriteIcon(
              product: widget.product,
              uid: widget.uid,
            ),

            // اسم المنتج
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 6, right: 10),
              child: Text(
                capitalize(isAr ? widget.product.nameAr : widget.product.name),
                style: AppStyles.textLora16,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 5),

            // السعر
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                child: Text(
                  isAr
                      ? "${currentPrice.toStringAsFixed(2)} ر.س"
                      : "${currentPrice.toStringAsFixed(2)} SAR",
                  style: AppStyles.InriaSerif_14.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),

            // مربعات الأحجام
            if (sortedSizes.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 4,
                  children: sortedSizes.map((s) {
                    final isSelected = selectedSize == s;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedSize = s;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 30,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryColor
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          s.size.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // تنظيف أي موارد إذا لزم الأمر
    super.dispose();
  }
}

//------------------------------- دله لجعل اول حرف كبتل استخدمت باكثر من صفحه-------------------
String capitalize(String text) {
  if (text.isEmpty) return text;
  return text
      .split(' ')
      .map((word) {
        if (word.isEmpty) return word;
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      })
      .join(' ');
}
