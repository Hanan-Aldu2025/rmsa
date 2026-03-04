// lib/featurees/main_screens/location/presentation/views/widgets/branch_details_section.dart

import 'dart:io';
import 'dart:ui';

import 'package:appp/featurees/main_screens/home/presentation/views/domain_layer.dart';
import 'package:appp/featurees/main_screens/location_branches/presentation/widgets/branch_info_row.dart';
import 'package:appp/generated/l10n.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

/// قسم تفاصيل الفرع
class BranchDetailsSection extends StatefulWidget {
  final BranchEntity branch;

  const BranchDetailsSection({super.key, required this.branch});

  @override
  State<BranchDetailsSection> createState() => _BranchDetailsSectionState();
}

class _BranchDetailsSectionState extends State<BranchDetailsSection> {
  // int _currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8, initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// تنسيق الوقت
  String _formatTime(String time, BuildContext context) {
    if (time.isEmpty) return "";

    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    try {
      final parts = time.split(':');
      int hour = int.parse(parts[0]);
      final minute = parts[1];

      String period;
      if (isAr) {
        period = hour >= 12 ? "م" : "ص";
      } else {
        period = hour >= 12 ? "PM" : "AM";
      }

      if (hour > 12) hour -= 12;
      if (hour == 0) hour = 12;

      return "$hour:$minute $period";
    } catch (e) {
      return time;
    }
  }

  /// عرض الصورة كاملة الشاشة
  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => Navigator.pop(context),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.black.withOpacity(0.4),
            child: Center(
              child: Hero(
                tag: imageUrl,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.contain,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(color: Colors.white),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.broken_image, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// فتح الخريطة للاتجاهات
  Future<void> _launchMaps(double lat, double lng) async {
    final googleMapsUrl =
        "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving";
    final appleMapsUrl = "https://maps.apple.com/?daddr=$lat,$lng";

    try {
      if (Platform.isIOS) {
        if (await canLaunchUrl(Uri.parse(appleMapsUrl))) {
          await launchUrl(
            Uri.parse(appleMapsUrl),
            mode: LaunchMode.externalApplication,
          );
        }
      } else {
        if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
          await launchUrl(
            Uri.parse(googleMapsUrl),
            mode: LaunchMode.externalApplication,
          );
        } else {
          throw 'Could not open the map.';
        }
      }
    } catch (e) {
      await launchUrl(
        Uri.parse(googleMapsUrl),
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    final lang = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // سلايدر الصور
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.branch.images.length,
            itemBuilder: (context, index) {
              final imgUrl = widget.branch.images[index];
              return GestureDetector(
                onTap: () => _showFullScreenImage(context, imgUrl),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Hero(
                    tag: imgUrl,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: imgUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Container(color: Colors.grey[200]),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 20),

        // اسم الفرع
        Text(widget.branch.getName(langCode), style: AppStyles.titleLora18),

        const Divider(height: 25),

        // معلومات الفرع
        BranchInfoRow(
          icon: Icons.location_on_outlined,
          text: widget.branch.getAddress(langCode),
        ),
        BranchInfoRow(icon: Icons.phone_outlined, text: widget.branch.phone),
        BranchInfoRow(
          icon: Icons.email_outlined,
          text: widget.branch.email.isNotEmpty
              ? widget.branch.email
              : "info@cafe.com",
        ),
        BranchInfoRow(
          icon: Icons.access_time,
          text:
              "${lang.open}: ${_formatTime(widget.branch.openTime, context)} - ${lang.close}: ${_formatTime(widget.branch.closeTime, context)}",
        ),

        const SizedBox(height: 20),

        // زر الاتجاهات
        ElevatedButton.icon(
          icon: const Icon(Icons.directions, color: Colors.white),
          label: Text(
            lang.getDirections,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => _launchMaps(widget.branch.lat, widget.branch.lng),
        ),

        const SizedBox(height: 30),
      ],
    );
  }
}
