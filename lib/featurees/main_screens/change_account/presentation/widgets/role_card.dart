// lib/featurees/main_screens/change_account/presentation/views/widgets/role_card.dart

import 'package:appp/featurees/main_screens/change_account/domain/entities/role_entity.dart';
import 'package:appp/featurees/main_screens/change_account/presentation/cubit/change_account_cubit.dart';
import 'package:appp/featurees/main_screens/change_account/presentation/cubit/change_account_state.dart';
import 'package:appp/featurees/main_screens/change_account/presentation/widgets/role_icon.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// بطاقة عرض الدور
class RoleCard extends StatelessWidget {
  final RoleEntity role;

  const RoleCard({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangeAccountCubit, ChangeAccountState>(
      builder: (context, state) {
        final isSelected = state.selectedRole == role.role;

        return GestureDetector(
          onTap: () => context.read<ChangeAccountCubit>().selectRole(role.role),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryColor.withOpacity(0.05)
                  : AppColors.backgroundGraybutton,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.borderColor,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // أيقونة الدور
                RoleIcon(icon: role.icon, isSelected: isSelected),

                const SizedBox(width: 15),

                // نص الدور
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        role.title,
                        style: AppStyles.InriaSerif_14.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        role.subtitle,
                        style: AppStyles.titleLora14.copyWith(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? AppColors.primaryColor.withOpacity(0.5)
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                // علامة الاختيار
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: AppColors.primaryColor,
                    size: 24,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
