import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appp/core/widget/custom_border_container.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';
import 'package:appp/utils/app_images.dart';
import 'package:appp/featurees/checkout_screens/order_screen/presentation/cubit/order_tracking_cubit/order_tracking_cubit.dart';
import 'package:appp/featurees/checkout_screens/order_screen/presentation/cubit/order_tracking_cubit/order_tracking_states.dart';
import 'package:appp/featurees/checkout_screens/order_screen/presentation/widget/custom_dialog_driver_reviews.dart';
import 'package:appp/core/services/get_it_services.dart';
import 'package:appp/featurees/checkout_screens/order_screen/data/repo_imp/driver_repo_imp.dart';

class DeliveryDriverCard extends StatefulWidget {
  const DeliveryDriverCard({super.key});

  @override
  State<DeliveryDriverCard> createState() => _DeliveryDriverCardState();
}

class _DeliveryDriverCardState extends State<DeliveryDriverCard> {
  int selectedRating = 0;
  TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<OrderTrackingCubit, OrderTrackingState>(
      buildWhen: (prev, curr) => curr is OrderTrackingLoaded,
      builder: (context, state) {
        if (state is! OrderTrackingLoaded) return const SizedBox.shrink();

        final order = state.order;
        final driver = order.driver;
        if (driver == null) return const SizedBox.shrink();

        final etaMinutes = state.etaMinutes; // ⬅ الوقت المتوقع بالدقائق

        return CustomBorderContainer(
          mychild: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= حالة الطلب =================
              Text(
                _getOrderStatusText(order.orderStatus ?? "created"),
                style: AppStyles.textLora16.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // ================= وقت التوصيل (ETA) =================
              Row(
                children: [
                  const Icon(Icons.access_time, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "الوقت المتوقع للتوصيل: $etaMinutes دقيقة",
                      style: AppStyles.InriaSerif_14,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ================= كرت السائق =================
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ---------- صورة السائق ----------
                  CircleAvatar(
                    radius: screenWidth * 0.05,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: (driver.imageUrl != null &&
                            driver.imageUrl!.isNotEmpty)
                        ? NetworkImage(driver.imageUrl!)
                        : const AssetImage(Assets.imagesUser) as ImageProvider,
                    child: (driver.imageUrl == null || driver.imageUrl!.isEmpty)
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
                  ),

                  SizedBox(width: screenWidth * 0.03),

// ---------- اسم السائق + Rating ----------
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          driver.name,
                          style: AppStyles.titleLora14,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => DriverRatingDialog(
                                driver: driver,
                                order: order,
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "Rating ${driver.rating.toStringAsFixed(1)}",
                              style: AppStyles.textLora12Gray.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ---------- زر الاتصال بالواتساب ----------
                  OutlinedButton(
                    onPressed: () {
                      if (driver.phone.isNotEmpty) {
                        try {
                          getIt<DriverRepository>().contactDriverWhatsApp(
                            driver.phone,
                            message: "مرحباً! بخصوص طلبك.",
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text("تعذر الاتصال بالواتساب: $e"),
                            ),
                          );
                        }
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                        vertical: screenHeight * 0.008,
                      ),
                    ),
                    child: Text(
                      "Contact Driver",
                      style: AppStyles.InriaSerif_16.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _getOrderStatusText(String orderStatus) {
    switch (orderStatus) {
      case 'confirmed':
        return "Confirmed";
      case 'preparing':
        return "Preparing";
      case 'on_the_way':
        return "On the Way!";
      case 'delivered':
        return "Delivered";
      default:
        return "Pending";
    }
  }
}