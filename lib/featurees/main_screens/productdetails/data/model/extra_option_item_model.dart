// lib/featurees/main_screens/product_details/presentation/cubit/extra_option_item_model.dart

import 'package:flutter/material.dart';

/// موديل الخيارات الإضافية للتفاعل مع واجهة المستخدم
class ExtraOptionItemModel {
  final String label;
  final double price;
  final ValueNotifier<bool> isChecked;

  ExtraOptionItemModel({required this.label, required this.price})
    : isChecked = ValueNotifier(false);

  @override
  String toString() => 'ExtraOptionItemModel(label: $label, price: $price)';
}
