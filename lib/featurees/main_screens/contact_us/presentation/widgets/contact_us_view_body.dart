// lib/featurees/main_screens/contact_us/presentation/views/contact_us_view_body.dart

import 'package:appp/featurees/main_screens/contact_us/presentation/widgets/contact_details_card.dart';
import 'package:appp/featurees/main_screens/contact_us/presentation/widgets/contact_social_buttons.dart';
import 'package:flutter/material.dart';

/// جسم صفحة تواصل معنا
class ContactUsViewBody extends StatelessWidget {
  const ContactUsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
      child: Column(
        children: [
          // بطاقة تفاصيل الفرع
          const ContactDetailsCard(),

          const SizedBox(height: 35),

          // أزرار التواصل الاجتماعي
          const ContactSocialButtons(),
        ],
      ),
    );
  }
}
