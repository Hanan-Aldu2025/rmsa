// lib/featurees/main_screens/contact_us/presentation/views/widgets/contact_social_buttons.dart

import 'package:appp/featurees/main_screens/contact_us/presentation/cubit/contact_us_cubit.dart';
import 'package:appp/featurees/main_screens/contact_us/presentation/widgets/social_media_button.dart';
import 'package:appp/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// مجموعة أزرار التواصل الاجتماعي
class ContactSocialButtons extends StatelessWidget {
  const ContactSocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ContactCubit>();
    final lang = S.of(context);

    return Wrap(
      spacing: 20,
      runSpacing: 20,
      alignment: WrapAlignment.center,
      children: [
        // تيك توك
        SocialMediaButton(
          icon: FontAwesomeIcons.tiktok,
          onPressed: () =>
              cubit.launchSocial(cubit.branch.tiktokUrl, lang.errorTikTok),
        ),

        // إنستغرام
        SocialMediaButton(
          icon: LucideIcons.instagram,
          onPressed: () => cubit.launchSocial(
            cubit.branch.instagramUrl,
            lang.errorInstagram,
          ),
        ),

        // واتساب
        SocialMediaButton(
          icon: FontAwesomeIcons.whatsapp,
          onPressed: () =>
              cubit.launchSocial(cubit.branch.whatsAppUrl, lang.errorWhatsApp),
        ),

        // اتصال هاتفي
        SocialMediaButton(
          icon: LucideIcons.phone,
          onPressed: () => cubit.callBranch(),
        ),
      ],
    );
  }
}
