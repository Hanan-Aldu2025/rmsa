import 'dart:async';
import 'package:appp/utils/app_images.dart';
import 'package:appp/utils/app_style.dart';
import 'package:flutter/material.dart';

class AnimatedLogo extends StatefulWidget {
  final String title;
  final String subtitle;
  final double opacity;

  const AnimatedLogo({
    super.key,
    required this.title,
    required this.subtitle,
    required this.opacity,
  });

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with SingleTickerProviderStateMixin {
  String displayedTitle = '';
  String displayedSubtitle = '';
  int titleIndex = 0;
  int subtitleIndex = 0;

  late AnimationController _imageController;
  late Animation<double> _imageAnimation;

  @override
  void initState() {
    super.initState();

    // انميشن الصورة
    _imageController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _imageAnimation = Tween<double>(begin: 0, end: 1).animate(_imageController);
    _imageController.forward();

    // انميشن النصوص
    _animateTitle();
    _animateSubtitle();
  }

  void _animateTitle() {
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (titleIndex < widget.title.length) {
        setState(() {
          displayedTitle += widget.title[titleIndex];
          titleIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _animateSubtitle() {
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (subtitleIndex < widget.subtitle.length) {
        setState(() {
          displayedSubtitle += widget.subtitle[subtitleIndex];
          subtitleIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.opacity,
      duration: const Duration(milliseconds: 500),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeTransition(
            opacity: _imageAnimation,
            child: Image.asset(Assets.imagesLogo, height: 120),
          ),
          SizedBox(height: 10),
          Text(displayedTitle, style: AppStyles.titleLora24),
          const SizedBox(height: 6),
          Text(displayedSubtitle, style: AppStyles.InriaSerif_16),
        ],
      ),
    );
  }
}
