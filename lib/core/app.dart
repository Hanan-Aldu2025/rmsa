import 'package:appp/core/helper_fauniction/on_generate_router.dart';
import 'package:appp/core/services/auth_listener_account.dart';
import 'package:appp/featurees/Auth/presenatation/views/longin/presentation/views/login_view.dart';
import 'package:appp/featurees/dash_bord/presentation/views/dash_bord.dart';
import 'package:appp/featurees/main_Screens/product_screen/dummy_proudect.dart';
import 'package:appp/featurees/on_boarding/presentation/views/on_boarding_view.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/cubit/cart_cubit/cart_cubit.dart';
import 'package:appp/generated/l10n.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// استيراد bloc و get_it
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appp/core/services/get_it_services.dart';

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
}

class _AppBootstrapState extends State<AppBootstrap> {
  final authListener = AuthListener();

  Locale _locale = const Locale("en");
  //____________________________________//
  @override
  void initState() {
    super.initState();
    // 🔄 بدء مراقبة حالة الحساب بعد تغيير اللغة
    authListener.startListening();
  }
  //____________________________________//

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }
  //____________________________________//

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // 🟤 Cubit خاص بالمنتجات
        //  BlocProvider(create: (_) => getIt<ProductCubit>()),

        // 🟤 Cubit خاص بالسلة (مشترك بين كل الصفحات)
        BlocProvider(create: (_) => getIt<CartCubit>()),
      ],

      // 🔹 MaterialApp هو الجذر للتطبيق كله
      child: MaterialApp(
        locale: _locale,
        supportedLocales: S.delegate.supportedLocales,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        debugShowCheckedModeBanner: false,
        title: 'Ramsa Cafe',

        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.backgroundSceenColor,
          ),
        ),

        // 📍 الصفحة التي يبدأ منها التطبيق (صفحة المنتجات التجريبية)
        initialRoute: LoginView.routeName,
        //FakeProductsPage.routeName,

        // 🔗 الموجه العام للتنقل بين الصفحات
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
