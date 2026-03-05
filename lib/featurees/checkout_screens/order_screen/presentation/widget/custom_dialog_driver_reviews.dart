import 'package:appp/core/services/get_it_services.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/models/driver_model.dart';
import '../../domain/entity/order_entity.dart';
import '../../data/repo_imp/driver_repo_imp.dart';

class DriverRatingDialog extends StatelessWidget {
  final DriverModel driver;
  final OrderEntity order;

  const DriverRatingDialog({
    super.key,
    required this.driver,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    int rating = 0;
    final commentController = TextEditingController();

    return AlertDialog(
      backgroundColor: Colors.white,
      // title: const Text("تقييم السائق"),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ⭐ النجوم
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 28,
                    ),
                    onPressed: () {
                      setState(() => rating = index + 1);
                    },
                  );
                }),
              ),
              const SizedBox(height: 8),
              // ✏️ تعليق
              TextField(
                controller: commentController,
                decoration: const InputDecoration(
                  hintText: "أضف تعليقك (اختياري)" ,
                  // border: OutlineInputBorder(),
                  // isDense: true,
                ),
              ),
            ],
          );
        },
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            "إلغاء",
            style: AppStyles.InriaSerif_14.copyWith(color: Colors.white),
          ),
        ),
        SizedBox(width: 0.004),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () async {
            if (rating == 0) return;

            final user = FirebaseAuth.instance.currentUser;
            if (user == null) return;

            final repo = getIt<DriverRepository>();
            await repo.submitDriverReview(
              driverId: driver.id,
              orderId: order.id,
              userId: user.uid,
              rating: rating,
              comment: commentController.text,
            );

            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("تم إرسال التقييم بنجاح")),
            );
          },
          child: Text(
            "تقييم السائق",
            style: AppStyles.InriaSerif_14.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
