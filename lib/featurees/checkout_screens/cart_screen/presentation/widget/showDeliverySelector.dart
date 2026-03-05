import 'package:appp/core/services/get_it_services.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/domain/entity/delivery_options_entity_and_model.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/cubit/cart_cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appp/utils/app_style.dart';
import 'package:appp/utils/app_colors.dart';

void showDeliverySelector(BuildContext context, List<DeliveryOption> options) {
  final cubit = getIt<CartCubit>();

  print("🟡 showDeliverySelector called");

  // ===================== فلترة الخيارات لإخفاء "fast" =====================
  final filteredOptions = options
      .where((option) => option.type != 'fast')
      .toList();
  print("🟣 FILTERED OPTIONS LENGTH = ${filteredOptions.length}");

  if (filteredOptions.isEmpty) {
    print("❌ لا يوجد خيارات بعد الفلترة — filteredOptions list is EMPTY");
    return;
  }

  // الحصول على الخيار المختار حاليًا من الـ Cubit
  DeliveryOption? selectedOption;

  if (cubit.deliveryMethod != null) {
    final matches = cubit.deliveryOptions
        .where((opt) => opt.name == cubit.deliveryMethod)
        .toList();

    if (matches.isNotEmpty) {
      selectedOption = matches.first;
    }
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      final screenHeight = MediaQuery.of(context).size.height;
      final screenWidth = MediaQuery.of(context).size.width;

      return Center(
        child: Container(
          width: screenWidth * 0.8,
          height: screenHeight * 0.22,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: filteredOptions.map((option) {
                  // 🔹 هنا تحققي إذا الدليفري مشغول
                  final isBusy = option.type == "standard" && !option.isActive;

                  // اختيار أيقونة حسب النوع
                  IconData iconData;
                  if (option.type == 'standard') {
                    iconData = Icons.directions_car;
                  } else {
                    iconData = Icons.store;
                  }

                  final isSelected =
                      selectedOption != null && selectedOption.id == option.id;

                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: isBusy
                        ? null
                        : () {
                            cubit.selectDeliveryOption(option);
                            Navigator.pop(context);
                          },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 1.5,
                        ),
                        color: isSelected
                            ? AppColors.backgroundSceenColor
                            : AppColors.whiteColor,
                      ),
                      child: Opacity(
                        opacity: isBusy ? 0.5 : 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(iconData, color: AppColors.primaryColor),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isBusy ? "ديليفري مشغول" : option.name,
                                      style: AppStyles.textLora16,
                                    ),
                                    if (option.estimatedTime.isNotEmpty)
                                      Text(
                                        option.estimatedTime,
                                        style: AppStyles.InriaSerif_14,
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            if (option.extraPrice > 0)
                              Text(
                                "\$${option.extraPrice.toStringAsFixed(2)}",
                                style: AppStyles.textLora16,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      );
    },
  );
}
