import 'package:appp/featurees/checkout_screens/cart_screen/domain/entity/delivery_options_entity_and_model.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/cubit/cart_cubit/cart_cubit.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/cubit/cart_cubit/cart_state.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/widget/showDeliverySelector.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class CustomChooseDeliveryOption extends StatelessWidget {
  const CustomChooseDeliveryOption({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final cubit = context.read<CartCubit>();

        // نص الزر يبقى مثل ما هو عندك
        final buttonText =
            cubit.deliveryMethod ?? "اختر طريقة التوصيل";

        final allOptions =
            state is CartUpdated ? state.deliveryOptions : cubit.deliveryOptions;

        // نجيب Pick Up دائمًا
        final pickUpOption = allOptions.firstWhere(
          (opt) => opt.name == "Pick Up",
          orElse: () => DeliveryOption(
            id: 'pick_up',
            name: 'Pick Up',
            extraPrice: 0,
            isActive: true,
            type: 'Pick Up',
            estimatedTime: 'Ready now',
          ),
        );

        // 🔥 المهم هنا:
        // لا نحذف الدليفري لو مشغول
        final deliveryOptions = allOptions
            .where((opt) => opt.name != "Pick Up")
            .toList();

        final optionsToShow = [pickUpOption, ...deliveryOptions];

        return  SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: optionsToShow.isEmpty
        ? null
        : () async {
            await cubit.fetchDeliveryOptions();
            showDeliverySelector(
              context,
              cubit.deliveryOptions,
            );
          },
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
      backgroundColor: AppColors.backgroundSceenColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    child: Text(
      buttonText,
      style: AppStyles.titleLora18.copyWith(
        color: AppColors.primaryColor,
      ),
    ),
  ),
);
      },
    );
  }
}