import 'package:appp/featurees/Auth/presenatation/views/longin/presentation/views/login_view.dart';
import 'package:appp/featurees/main_screens/change_account/presentation/views/change_account_view.dart';
import 'package:appp/featurees/main_screens/complaintsubmission/presentation/views/complaint_submission_view.dart';
import 'package:appp/featurees/main_screens/contact_us/presentation/views/contact_us_view.dart';
import 'package:appp/featurees/main_screens/home/presentation/views/presentation_layer.dart';
import 'package:appp/featurees/main_screens/languages_settings/presentation/views/languages_view.dart';
import 'package:appp/featurees/main_screens/personal/presentation/views/personal_view.dart';
import 'package:appp/featurees/main_screens/profile/domain/entities/user_entity.dart';
import 'package:appp/featurees/main_screens/profile/presentation/cubit/profile_cubit.dart';
import 'package:appp/featurees/main_screens/profile/presentation/widgets/developer_credit_widget.dart';
import 'package:appp/featurees/main_screens/profile/presentation/widgets/profile_menu_item.dart';
import 'package:appp/featurees/main_screens/theme/presentation/views/theme_view.dart';
import 'package:appp/generated/l10n.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// lib/featurees/main_screens/profile/presentation/views/widgets/profile_menu_list.dart

/// قائمة خيارات الملف الشخصي

/// قائمة خيارات الملف الشخصي
/// Profile menu list widget
class ProfileMenuList extends StatelessWidget {
  final bool isGuest;
  final UserEntity user;

  const ProfileMenuList({super.key, required this.isGuest, required this.user});

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);

    if (isGuest) {
      return _buildGuestMenu(context, lang);
    }

    // تنسيق الاسم: يتم تطبيق capitalize فقط إذا كان الاسم إنجليزياً (يحتوي على أحرف لاتينية فقط)
    // Format name: apply capitalize only if the name is English (contains only Latin letters)
    String displayName = user.name;
    if (RegExp(r'^[a-zA-Z\s]+$').hasMatch(user.name)) {
      displayName = capitalize(user.name);
    }

    return _buildUserMenu(context, lang, displayName, user.email);
  }

  /// بناء قائمة الزوار
  /// Build guest menu
  Column _buildGuestMenu(BuildContext context, dynamic lang) {
    return Column(
      children: [
        Text(lang.guest, style: AppStyles.titleLora18),
        const SizedBox(height: 8),
        Text(
          'مرحباً بك في التطبيق',
          style: TextStyle(color: AppColors.GrayIconColor),
        ),
        const SizedBox(height: 15),

        // أزرار متاحة للجميع / Public options
        ProfileMenuItem(
          icon: Icons.language,
          text: lang.language,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LanguageView()),
          ),
        ),
        ProfileMenuItem(
          icon: Icons.report_problem_outlined,
          text: lang.contactUs,
          onTap: () => _handleContactUs(context),
        ),
        ProfileMenuItem(
          icon: Icons.house_siding_rounded,
          text: lang.branches,
          onTap: () {
            // TODO: التنقل لصفحة الفروع / Navigate to branches page
          },
        ),
        ProfileMenuItem(
          icon: Icons.color_lens_outlined,
          text: lang.theme,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ThemeView()),
          ),
        ),

        // زر تسجيل الدخول للزوار / Login button for guests
        ProfileMenuItem(
          icon: Icons.login,
          text: 'تسجيل الدخول',
          color: AppColors.primaryColor,
          isLogout: false,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LoginView()),
          ),
        ),

        // const DeveloperCreditWidget(),
      ],
    );
  }

  /// بناء قائمة المستخدمين المسجلين
  /// Build registered user menu
  Column _buildUserMenu(
    BuildContext context,
    dynamic lang,
    String displayName,
    String email,
  ) {
    return Column(
      children: [
        Text(displayName, style: AppStyles.titleLora18),
        const SizedBox(height: 8),
        Text(email, style: TextStyle(color: AppColors.GrayIconColor)),
        const SizedBox(height: 15),

        // أزرار تتطلب تسجيل دخول / Options requiring login
        ProfileMenuItem(
          icon: Icons.person_outline,
          text: lang.personal,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PersonalView(
                userData: {
                  'user_name': user.name,
                  'user_email': user.email,
                  'phone': '', // يمكن إضافة رقم الهاتف إذا كان متاحاً
                },
                uid: user.uid, // تمرير uid
              ),
            ),
          ),
        ),
        ProfileMenuItem(
          icon: Icons.swap_horiz,
          text: lang.changeAccount,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ChangeAccountView()),
          ),
        ),
        ProfileMenuItem(
          icon: Icons.message_outlined,
          text: lang.complaintSubmission,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  ComplaintSubmissionView(uid: user.uid, email: user.email),
            ),
          ),
        ),

        // أزرار متاحة للجميع / Public options
        ProfileMenuItem(
          icon: Icons.language,
          text: lang.language,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LanguageView()),
          ),
        ),
        ProfileMenuItem(
          icon: Icons.report_problem_outlined,
          text: lang.contactUs,
          onTap: () => _handleContactUs(context),
        ),
        ProfileMenuItem(
          icon: Icons.house_siding_rounded,
          text: lang.branches,
          onTap: () {},
        ),
        ProfileMenuItem(
          icon: Icons.color_lens_outlined,
          text: lang.theme,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ThemeView()),
          ),
        ),

        // زر تسجيل الخروج / Logout button
        ProfileMenuItem(
          icon: Icons.logout,
          text: lang.logout,
          color: Colors.red,
          isLogout: true,
          onTap: () => context.read<ProfileCubit>().logout(),
        ),

        // const DeveloperCreditWidget(),
      ],
    );
  }

  /// معالجة الضغط على زر "تواصل معنا"
  /// Handle "Contact Us" button press
  void _handleContactUs(BuildContext context) {
    final activeBranch = context.read<HomeCubit>().state.selectedBranch;
    if (activeBranch != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ContactUsView(selectedBranch: activeBranch),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('الرجاء اختيار فرع أولاً')));
    }
  }
}
// class ProfileMenuList extends StatelessWidget {
//   final bool isGuest;
//   final UserEntity user;

//   const ProfileMenuList({super.key, required this.isGuest, required this.user});

//   @override
//   Widget build(BuildContext context) {
//     final lang = S.of(context);

//     if (isGuest) {
//       return _buildGuestMenu(context, lang);
//     }

//     // تنسيق الاسم للإنجليزية
//     String displayName = user.name;
//     if (Localizations.localeOf(context).languageCode == 'en') {
//       displayName = capitalize(user.name);
//     }

//     return _buildUserMenu(context, lang, displayName, user.email);
//   }

//   Column _buildGuestMenu(BuildContext context, dynamic lang) {
//     return Column(
//       children: [
//         Text(lang.guest, style: AppStyles.titleLora18),
//         const SizedBox(height: 8),
//         Text(
//           'مرحباً بك في التطبيق',
//           style: TextStyle(color: AppColors.GrayIconColor),
//         ),
//         const SizedBox(height: 15),

//         // أزرار متاحة للجميع
//         ProfileMenuItem(
//           icon: Icons.language,
//           text: lang.language,
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const LanguageView()),
//           ),
//         ),
//         ProfileMenuItem(
//           icon: Icons.report_problem_outlined,
//           text: lang.contactUs,
//           onTap: () => _handleContactUs(context), // ✅ تمرير context
//         ),
//         ProfileMenuItem(
//           icon: Icons.house_siding_rounded,
//           text: lang.branches,
//           onTap: () {
//             // TODO: التنقل لصفحة الفروع
//           },
//         ),
//         ProfileMenuItem(
//           icon: Icons.color_lens_outlined,
//           text: lang.theme,
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const ThemeView()),
//           ),
//         ),

//         // زر تسجيل الدخول
//         ProfileMenuItem(
//           icon: Icons.login,
//           text: 'تسجيل الدخول',
//           color: Colors.green.withOpacity(0.6),
//           isLogout: false,
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const LoginView()),
//           ),
//         ),

//         // const DeveloperCreditWidget(),
//       ],
//     );
//   }

//   Column _buildUserMenu(
//     BuildContext context,
//     dynamic lang,
//     String displayName,
//     String email,
//   ) {
//     return Column(
//       children: [
//         Text(displayName, style: AppStyles.titleLora18),
//         const SizedBox(height: 8),
//         Text(email, style: TextStyle(color: AppColors.GrayIconColor)),
//         const SizedBox(height: 15),

//         // أزرار تتطلب تسجيل دخول
//         ProfileMenuItem(
//           icon: Icons.person_outline,
//           text: lang.personal,
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => PersonalView(
//                 userData: {
//                   'user_name': user.name,
//                   'user_email': user.email,
//                   'phone':
//                       '', // يمكن إضافة رقم الهاتف إذا كان متاحًا في UserEntity
//                 },
//                 uid: user.uid, // ✅ تمرير uid من UserEntity
//               ),
//             ),
//           ),
//         ),
//         // ProfileMenuItem(
//         //   icon: Icons.person_outline,
//         //   text: lang.personal,
//         //   onTap: () => Navigator.push(
//         //     context,
//         //     MaterialPageRoute(
//         //       builder: (_) => PersonalView(
//         //         userData: {'user_name': user.name, 'user_email': user.email},
//         //       ),
//         //     ),
//         //   ),
//         // ),
//         ProfileMenuItem(
//           icon: Icons.swap_horiz,
//           text: lang.changeAccount,
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const ChangeAccountView()),
//           ),
//         ),
//         ProfileMenuItem(
//           icon: Icons.message_outlined,
//           text: lang.complaintSubmission,
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) =>
//                   ComplaintSubmissionView(uid: user.uid, email: user.email),
//             ),
//           ),
//         ),

//         // أزرار متاحة للجميع
//         ProfileMenuItem(
//           icon: Icons.language,
//           text: lang.language,
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const LanguageView()),
//           ),
//         ),
//         ProfileMenuItem(
//           icon: Icons.report_problem_outlined,
//           text: lang.contactUs,
//           onTap: () => _handleContactUs(context), // ✅ تمرير context
//         ),
//         ProfileMenuItem(
//           icon: Icons.house_siding_rounded,
//           text: lang.branches,
//           onTap: () {},
//         ),
//         ProfileMenuItem(
//           icon: Icons.color_lens_outlined,
//           text: lang.theme,
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const ThemeView()),
//           ),
//         ),

//         // زر تسجيل الخروج
//         ProfileMenuItem(
//           icon: Icons.logout,
//           text: lang.logout,
//           color: Colors.red,
//           isLogout: true,
//           onTap: () {
//             context.read<ProfileCubit>().logout();
//             // إعادة التوجيه إلى شاشة تسجيل الدخول مع مسح كل الصفحات السابقة
//             Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(builder: (_) => const LoginView()),
//               (route) => false,
//             );
//           },
//         ),

//         // const DeveloperCreditWidget(),
//       ],
//     );
//   }

//   // ✅ دالة معالجة الضغط على زر "تواصل معنا" - تستقبل context كمعامل
//   void _handleContactUs(BuildContext context) {
//     final activeBranch = context.read<HomeCubit>().state.selectedBranch;
//     if (activeBranch != null) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => ContactUsView(selectedBranch: activeBranch),
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('الرجاء اختيار فرع أولاً')));
//     }
//   }
// }
