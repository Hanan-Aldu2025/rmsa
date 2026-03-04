// lib/featurees/main_screens/contact_us/presentation/views/widgets/contact_details_card.dart

import 'package:appp/featurees/main_screens/contact_us/presentation/cubit/contact_us_cubit.dart';
import 'package:appp/featurees/main_screens/contact_us/presentation/widgets/contact_info_row.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// بطاقة تفاصيل التواصل للفرع
class ContactDetailsCard extends StatelessWidget {
  const ContactDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final branch = context.read<ContactCubit>().branch;
    final langCode = Localizations.localeOf(context).languageCode;

    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.borderColor.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // اسم الفرع
          Text(branch.getName(langCode), style: AppStyles.titleLora18),

          const SizedBox(height: 25),

          // العنوان
          ContactInfoRow(
            icon: LucideIcons.mapPin,
            label: branch.getAddress(langCode),
          ),

          const SizedBox(height: 20),

          // رقم الهاتف
          ContactInfoRow(icon: LucideIcons.phone, label: branch.phone),

          const SizedBox(height: 20),

          // البريد الإلكتروني
          ContactInfoRow(
            icon: LucideIcons.mail,
            label: branch.email.isNotEmpty ? branch.email : "info@cafe.com",
          ),
        ],
      ),
    );
  }
}
