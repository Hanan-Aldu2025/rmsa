// // lib/featurees/main_screens/profile/presentation/views/widgets/developer_credit_widget.dart
// import 'package:appp/generated/l10n.dart';
// import 'package:appp/utils/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// /// ويدجت رابط المطور

// class DeveloperCreditWidget extends StatelessWidget {
//   const DeveloperCreditWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final lang = S.of(context);

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 25, top: 20),
//       child: GestureDetector(
//         onTap: () async {
//           final emailUri = Uri(
//             scheme: 'mailto',
//             path: 'soft.devlop@gmail.com',
//             queryParameters: {'subject': 'Support Request'},
//           );
//           if (await canLaunchUrl(emailUri)) {
//             await launchUrl(emailUri);
//           }
//         },
//         child: Text.rich(
//           textAlign: TextAlign.center,
//           TextSpan(
//             text: "${lang.developedBy}: ",
//             style: TextStyle(color: AppColors.GrayIconColor, fontSize: 13),
//             children: [
//               TextSpan(
//                 text: "soft.devlop@gmail.com",
//                 style: TextStyle(
//                   color: AppColors.primaryColor,
//                   fontWeight: FontWeight.bold,
//                   decoration: TextDecoration.underline,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
