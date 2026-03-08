import 'package:appp/core/helper_fauniction/on_generate_router.dart';
import 'package:appp/core/services/auth_listener_account.dart';
import 'package:appp/core/services/shared_preverences_singleton.dart';
import 'package:appp/featurees/Auth/presenatation/views/longin/presentation/views/login_view.dart';
import 'package:appp/featurees/main_screens/bottom_nav_view/presentation/views/bottom_nav_view.dart';
import 'package:appp/generated/l10n.dart';
import 'package:appp/utils/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:timeago/timeago.dart' as timeago;

class AppBootstrap extends StatefulWidget {
  const AppBootstrap({super.key});

  @override
  State<AppBootstrap> createState() => _AppBootstrapState();

  // تغيير اللغة داخل التطبيق
  static void setLocale(BuildContext context, Locale newLocale) {
    _AppBootstrapState? state = context
        .findAncestorStateOfType<_AppBootstrapState>();
    state?.setLocale(newLocale);
  }

  // وأضيفي هذه الدالة لتغيير الثيم (مثل دالة اللغة تماماً)
  static void setTheme(BuildContext context, bool isDark) {
    _AppBootstrapState? state = context
        .findAncestorStateOfType<_AppBootstrapState>();
    state?.setState(() {
      state._themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
    AppPrefs.setBool('isDark', isDark);
  }
}

// class _AppBootstrapState extends State<AppBootstrap> {
//   final authListener = AuthListener();

//   // القيمة الافتراضية يتم جلبها من التخزين المؤقت
//   Locale _locale = Locale(
//     AppPrefs.getString('lang').isEmpty ? 'en' : AppPrefs.getString('lang'),
//   );
//   // أضيفي هذا المتغير في الحالة (State)
//   ThemeMode _themeMode = AppPrefs.getBool('isDark')
//       ? ThemeMode.dark
//       : ThemeMode.light;

//   @override
//   void initState() {
//     super.initState();
//     authListener.startListening();
//     // داخل دالة main بعد ensureInitialized
//     timeago.setLocaleMessages('ar', timeago.ArMessages());
//     timeago.setLocaleMessages('en', timeago.EnMessages());
//   }

//   // هذه الدالة ستقوم بتحديث الواجهة وحفظ اللغة في الجهاز
//   void setLocale(Locale locale) {
//     setState(() {
//       _locale = locale;
//     });
//     // حفظ الرمز (ar أو en) في الجهاز
//     AppPrefs.setString('lang', locale.languageCode);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       locale: _locale,
//       themeMode: _themeMode,
//       theme: AppTheme.lightTheme,
//       darkTheme: AppTheme.darkTheme,
//       supportedLocales: S.delegate.supportedLocales,
//       localizationsDelegates: const [
//         S.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       debugShowCheckedModeBanner: false,
//       title: 'Ramsa Cafe',

//       // ✅ التعديل الذكي: التحقق إذا كان المستخدم مسجلاً أصلاً
//       home: const BottomNavView(),

//       // FirebaseAuth.instance.currentUser == null
//       //     ? const LoginView()
//       //     : const BottomNavView(),
//       onGenerateRoute: AppRouter.onGenerateRoute,
//     );
//   }
class _AppBootstrapState extends State<AppBootstrap> {
  final authListener = AuthListener();

  // القيمة الافتراضية يتم جلبها من التخزين المؤقت
  Locale _locale = Locale(
    AppPrefs.getString('lang').isEmpty ? 'ar' : AppPrefs.getString('lang'),
  );

  ThemeMode _themeMode = AppPrefs.getBool('isDark')
      ? ThemeMode.dark
      : ThemeMode.light;

  @override
  void initState() {
    super.initState();
    authListener.startListening();
    timeago.setLocaleMessages('ar', timeago.ArMessages());
    timeago.setLocaleMessages('en', timeago.EnMessages());
  }

  // تحديث اللغة
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
    AppPrefs.setString('lang', locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      themeMode: _themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      title: 'Ramsa Cafe',

      // ✅ دائماً اذهب إلى BottomNavView (سواء كان مسجل أو زائر)
      home: BottomNavView(),
      // FirebaseAuth.instance.currentUser == null
      // ? const LoginView()
      // : const BottomNavView(),
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     locale: _locale, // سيستخدم القيمة المحدثة دائماً
  //     //ThemeMode يعتمد على المتغير الذي تم تحديثه من خلال setTheme
  //     themeMode: _themeMode,
  //     theme: AppTheme.lightTheme,
  //     darkTheme: AppTheme.darkTheme,
  //     supportedLocales: S.delegate.supportedLocales,
  //     localizationsDelegates: const [
  //       S.delegate,
  //       GlobalMaterialLocalizations.delegate,
  //       GlobalWidgetsLocalizations.delegate,
  //       GlobalCupertinoLocalizations.delegate,
  //     ],
  //     // ... باقي الكود كما هو
  //     debugShowCheckedModeBanner: false,
  //     title: 'Ramsa Cafe',
  //     home: LoginView(),
  //     // home: ProductsManagerView(),
  //     // home: AddProductView(),
  //     // home: AddCategoryView(),
  //     // home: CategoriesManagerView(),

  //     // 🔗 الموجه العام للتنقل بين الصفحات
  //     onGenerateRoute: AppRouter.onGenerateRoute,
  //     // ),
  //   );

// }