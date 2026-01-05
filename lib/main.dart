import 'package:appp/core/app.dart';
import 'package:appp/core/services/custom_bloc_observer.dart';
import 'package:appp/core/services/get_it_services.dart';
import 'package:appp/core/services/shared_preverences_singleton.dart';

import 'package:appp/featurees/splash/view_model/splash_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPrefs.init();
  await Firebase.initializeApp();
  setupGetIt();
  Bloc.observer = AppBlocObserver();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SplashViewModel())],
      child: const AppBootstrap(),
    ),
  );
}
