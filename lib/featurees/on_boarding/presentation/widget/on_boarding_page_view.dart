import 'package:appp/featurees/on_boarding/presentation/widget/on_boarding_items.dart';
import 'package:appp/generated/l10n.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_images.dart';
import 'package:flutter/material.dart';

class OnBoardingPageView extends StatelessWidget {
  const OnBoardingPageView({super.key, required this.pageController});
  final PageController pageController;
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      children: [
        OnBoardingItems(
          title: S.of(context).onBoardingTitle1,
          backgroundimage: Assets.imagesOneboarding,
          bkgroundcolor: AppColors.primaryColor,
        ),
        OnBoardingItems(
          title: S.of(context).onBoardingTitle2,
          backgroundimage: Assets.imagesTwoboarding,
          bkgroundcolor: AppColors.primaryColor,
        ),
        OnBoardingItems(
          title: S.of(context).onBoardingTitle3,
          backgroundimage: Assets.imagesThreeboarding,
          bkgroundcolor: AppColors.primaryColor,
        ),
      ],
    );
  }
}
