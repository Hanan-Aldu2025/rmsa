// import 'package:appp/utils/app_colors.dart';
// import 'package:appp/utils/app_style.dart';
// import 'package:flutter/material.dart';
// import 'package:lucide_icons/lucide_icons.dart';

// class AppSearchField extends StatefulWidget {
//   final String hintText;
//   final ValueChanged<String>? onChanged;
//   final TextEditingController? controller;
//   final EdgeInsetsGeometry? margin;

//   const AppSearchField({
//     super.key,
//     required this.hintText,
//     this.onChanged,
//     this.controller,
//     this.margin,
//   });

//   @override
//   State<AppSearchField> createState() => _AppSearchFieldState();
// }

// class _AppSearchFieldState extends State<AppSearchField> {
//   late TextEditingController _internalController;

//   @override
//   void initState() {
//     super.initState();
//     _internalController = widget.controller ?? TextEditingController();
//     _internalController.addListener(() {
//       if (mounted) setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 45,
//       margin: widget.margin ?? const EdgeInsets.symmetric(vertical: 6),
//       padding: const EdgeInsets.symmetric(
//         horizontal: 12,
//       ), // رجعنا البادينج كما كان
//       decoration: BoxDecoration(
//         color: AppColors.backgroundGraybutton,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: AppColors.borderColor),
//       ),
//       child: Row(
//         children: [
//           const Icon(
//             LucideIcons.search,
//             color: AppColors.GrayIconColor,
//             size: 18,
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: TextField(
//               controller: _internalController,
//               style: AppStyles.InriaSerif_14.copyWith(color: Colors.black),
//               decoration: InputDecoration(
//                 hintText: widget.hintText,
//                 hintStyle: AppStyles.InriaSerif_14,
//                 border: InputBorder.none,
//                 isDense: true,
//                 contentPadding: const EdgeInsets.symmetric(
//                   vertical: 10,
//                 ), // رجعنا الارتفاع الأصلي للنص
//               ),
//               onChanged: widget.onChanged,
//             ),
//           ),
//           // زر المسح: حافظنا على الشكل تماماً مع تكبير منطقة اللمس برمجياً
//           if (_internalController.text.isNotEmpty)
//             GestureDetector(
//               // الـ behavior يضمن أن اللمس يتم التقاطه بدقة
//               behavior: HitTestBehavior.opaque,
//               onTap: () {
//                 _internalController.clear();
//                 if (widget.onChanged != null) widget.onChanged!("");
//               },
//               child: Container(
//                 // أضفنا مساحة لمس (Padding) داخلية للأيقونة دون التأثير على شكل الـ Row
//                 padding: const EdgeInsets.only(
//                   left: 10,
//                   right: 5,
//                   top: 10,
//                   bottom: 10,
//                 ),
//                 child: const Icon(
//                   Icons.close, // نفس الأيقونة السابقة
//                   color: Colors.grey,
//                   size: 18,
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
