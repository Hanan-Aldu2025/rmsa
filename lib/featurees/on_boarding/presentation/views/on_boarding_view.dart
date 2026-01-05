import 'package:appp/featurees/on_boarding/presentation/widget/on_bording_view_body.dart';
import 'package:flutter/material.dart';

class OnBoardingView extends StatelessWidget {

  const OnBoardingView({super.key});
  static const routeName = "OnBoardingView";
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: OnBordingViewBody());
  }
}
