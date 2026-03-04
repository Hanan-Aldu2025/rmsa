import 'package:appp/featurees/Auth/presenatation/views/longin/presentation/views/login_view.dart';
import 'package:appp/featurees/main_screens/profile/presentation/cubit/profile_cubit.dart';
import 'package:appp/featurees/main_screens/profile/presentation/cubit/profile_state.dart';
import 'package:appp/featurees/main_screens/profile/presentation/widgets/profile_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// lib/featurees/main_screens/profile/presentation/views/profile_view_consumer.dart

/// المستهلك - يتفاعل مع تغييرات الحالة

class ProfileViewConsumer extends StatelessWidget {
  const ProfileViewConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    // final lang = S.of(context);

    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLogoutSuccess) {
          // التنقل إلى صفحة تسجيل الدخول ومسح كل الصفحات السابقة
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginView()),
            (route) => false,
          );
        } else if (state is ProfileSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is ProfileFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProfileLoaded) {
          return ProfileViewBody(user: state.user, isGuest: state.isGuest);
        } else if (state is ProfileFailure) {
          return Center(child: Text(state.errorMessage));
        }
        return const SizedBox.shrink();
      },
    );
  }
}
