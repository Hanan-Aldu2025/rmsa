import 'package:appp/generated/l10n.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';
import 'package:flutter/material.dart';

/// 📝 ويدجت مخصص لحقل الإدخال (TextFormField)
/// - يقبل كونترولر للتحكم بالقيمة
/// - يقبل نوع الإدخال (email, password, text)
/// - يقبل Validator خارجي مع Validator داخلي افتراضي
/// - يدعم إخفاء النص (للباسورد)
class CustomTextFormFiled extends StatelessWidget {
  final String hinttext;
  final TextEditingController? controller;
  final TextInputType textInputType;
  final Widget? suffixIcon;
  final void Function(String?)? onSaved;
  final bool obscureText;
  final String? Function(String?)? validator;

  const CustomTextFormFiled({
    super.key,
    required this.hinttext,
    required this.textInputType,
    this.suffixIcon,
    this.onSaved,
    this.obscureText = false,
    this.validator,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      onSaved: onSaved,
      validator: (value) {
        // ✅ إذا البريد اختياري، نفحصه فقط إذا فيه قيمة
        if (hinttext.toLowerCase().contains("email")) {
          if (value != null && value.isNotEmpty) {
            // تحقق من صحة البريد بصيغة بسيطة
            final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
            if (!emailRegex.hasMatch(value)) {
              return S.of(context).invalidEmail; // أضف رسالة في ملفات الترجمة
            }
          }
          return null; // فارغ مسموح به
        }

        // ✅ فحص الحقول الأخرى الفارغة
        if (value == null || value.isEmpty) {
          return _getEmptyMessage(context);
        }

        // ✅ إذا في Validator خارجي يتم استدعاؤه
        if (validator != null) {
          return validator!(value);
        }
        return null;
      },
      keyboardType: textInputType,
      decoration: InputDecoration(
        hintText: hinttext,
        hintStyle: AppStyles.textLora12Gray,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.backgroundSceenColor,
        border: buildOutlineInputBorder(),
        enabledBorder: buildOutlineInputBorder(),
        focusedBorder: buildOutlineInputBorder(),
      ),
    );
  }

  /// ✅ توليد البوردر الموحد للحقل
  OutlineInputBorder buildOutlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: AppColors.primaryColor, width: 0.1),
    );
  }

  /// ✅ رسالة افتراضية عند كون الحقل فارغ
  String _getEmptyMessage(BuildContext context) {
    if (hinttext.toLowerCase().contains("email")) {
      return S.of(context).enterEmail;
    } else if (hinttext.toLowerCase().contains("password")) {
      return S.of(context).enterPassword;
    } else if (hinttext.toLowerCase().contains("name")) {
      return S.of(context).enterFullName;
    }
    return S.of(context).fillAllFields;
  }
}
