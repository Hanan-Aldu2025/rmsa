import 'package:appp/utils/app_style.dart';
import 'package:flutter/material.dart';

class OnBoardingItems extends StatelessWidget {
  const OnBoardingItems({
    super.key,
    required this.title,
    required this.backgroundimage,
    required this.bkgroundcolor,
  });
  final String title, backgroundimage;
  final Color bkgroundcolor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bkgroundcolor,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(backgroundimage, fit: BoxFit.cover),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(right: 30, left: 30),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.35,
                decoration: BoxDecoration(
                  color: bkgroundcolor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 80, right: 5, left: 5),
                  child: Center(
                    child: Text(
                      title,
                      style: AppStyles.titleLora18.copyWith(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
