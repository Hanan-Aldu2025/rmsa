import 'package:appp/featurees/dash_bord/presentation/views/dash_bord.dart';
import 'package:appp/featurees/language/presentation/views/language_selection_view.dart';
import 'package:appp/featurees/Auth/presenatation/views/longin/presentation/views/login_view.dart';
import 'package:appp/featurees/Auth/presenatation/views/signUp/presentation/views/signup_view.dart';
import 'package:appp/featurees/main_Screens/product_screen/dummy_proudect.dart';
import 'package:appp/featurees/mobile_app/presentation/views/mobile.dart';
import 'package:appp/featurees/on_boarding/presentation/views/on_boarding_view.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/views/cart_view.dart';
import 'package:appp/featurees/splash/presentation/view/splash_view.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      //____________________________________________________________

      case DashBorad.routeName:
        return MaterialPageRoute(builder: (_) => const DashBorad());

      //____________________________________________________________
      case MobileApp.routeName:
        return MaterialPageRoute(builder: (_) => const MobileApp());
      //____________________________________________________________

      case SplashView.routeName:
        return MaterialPageRoute(builder: (_) => const SplashView());
      //____________________________________________________________
      case LanguageSelectionView.routeName:
        return MaterialPageRoute(builder: (_) => const LanguageSelectionView());
      //____________________________________________________________

      case OnBoardingView.routeName:
        return MaterialPageRoute(builder: (_) => const OnBoardingView());
      //____________________________________________________________

      case LoginView.routeName:
        return MaterialPageRoute(builder: (_) => const LoginView());
      //____________________________________________________________

      case SignupView.routeName:
        return MaterialPageRoute(builder: (_) => const SignupView());
      //____________________________________________________________

      case FakeProductsPage.routeName:
        return MaterialPageRoute(builder: (_) => const FakeProductsPage());
      //____________________________________________________________

      //_________________________payment___________________________________
      
 case CartView.routeName:
        return MaterialPageRoute(builder: (_) => const CartView());
        //______________________________________________________________
        
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}
