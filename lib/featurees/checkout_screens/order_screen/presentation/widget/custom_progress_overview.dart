import 'package:appp/core/widget/custom_border_container.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:appp/featurees/checkout_screens/order_screen/presentation/cubit/order_tracking_cubit/order_tracking_cubit.dart';
import 'package:appp/featurees/checkout_screens/order_screen/presentation/cubit/order_tracking_cubit/order_tracking_states.dart';

class CustomOrderProgressOverview extends StatelessWidget {
  const CustomOrderProgressOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderTrackingCubit, OrderTrackingState>(
      builder: (context, state) {
        // ✅ إذا لم يتم تحميل الطلب بعد، لا نعرض أي شيء
        if (state is! OrderTrackingLoaded) return const SizedBox.shrink();

        // ✅ الحالة تأتي مباشرة من قاعدة البيانات
        final currentState = state.order.orderStatus;
        //
        return CustomBorderContainer(
          mychild: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _StepItem(
                    icon: LucideIcons.checkCircle,
                    label: "Confirmed",
                    active: _isActive(currentState, "confirmed"),
                  ),
                  _Line(active: _isActive(currentState, "preparing")),
                  _StepItem(
                    icon: LucideIcons.coffee,
                    label: "Preparing",
                    active: _isActive(currentState, "preparing"),
                  ),
                  _Line(active: _isActive(currentState, "on_the_way")),
                  _StepItem(
                    icon: LucideIcons.truck,
                    label: "On the Way",
                    active: _isActive(currentState, "on_the_way"),
                  ),
                  _Line(active: _isActive(currentState, "delivered")),
                  _StepItem(
                    icon: LucideIcons.checkCircle,
                    label: "Delivered",
                    active: _isActive(currentState, "delivered"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool _isActive(String? currentState, String step) {
    if (currentState == null) return false;

    const orderFlow = ["confirmed", "preparing", "on_the_way", "delivered"];
    return orderFlow.indexOf(currentState) >= orderFlow.indexOf(step);
  }
}

class _StepItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _StepItem({
    required this.icon,
    required this.label,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    final circleColor = active
        ? AppColors.primaryColor
        : AppColors.GrayIconColor;
    final textColor = active ? AppColors.primaryColor : AppColors.GrayIconColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: circleColor,
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: AppStyles.InriaSerif_14.copyWith(
            color: textColor,
            fontWeight: active ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class _Line extends StatelessWidget {
  final bool active;

  const _Line({required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: active ? AppColors.primaryColor : AppColors.GrayIconColor,
    );
  }
}
