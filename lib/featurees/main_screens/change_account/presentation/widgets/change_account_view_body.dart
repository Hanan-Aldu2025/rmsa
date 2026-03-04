// lib/featurees/main_screens/change_account/presentation/views/change_account_view_body.dart

import 'package:appp/core/constans/constans_kword.dart';
import 'package:appp/core/widget/custom_button.dart';
import 'package:appp/featurees/main_screens/change_account/presentation/cubit/change_account_cubit.dart';
import 'package:appp/featurees/main_screens/change_account/presentation/widgets/role_card.dart';
import 'package:appp/generated/l10n.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// جسم صفحة تبديل الحساب
class ChangeAccountViewBody extends StatelessWidget {
  const ChangeAccountViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final cubit = context.read<ChangeAccountCubit>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kHorizintalPadding,
          vertical: 30,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // نص التوجيه
            Text(
              lang.chooseAccountType,
              style: AppStyles.InriaSerif_14.copyWith(
                color: AppColors.GrayIconColor,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // قائمة الأدوار
            ...cubit.roles.map((role) => RoleCard(role: role)),

            const SizedBox(height: 40),

            // زر الحفظ
            CustomButton(
              text: lang.saveChanges,
              onpressed: () => cubit.confirmSwitch(context),
            ),
          ],
        ),
      ),
    );
  }
}
