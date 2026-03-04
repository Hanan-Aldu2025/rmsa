// lib/featurees/main_screens/contact_us/presentation/views/contact_us_view_consumer.dart

import 'package:appp/featurees/main_screens/contact_us/presentation/cubit/contact_us_cubit.dart';
import 'package:appp/featurees/main_screens/contact_us/presentation/cubit/contact_us_state.dart';
import 'package:appp/featurees/main_screens/contact_us/presentation/widgets/contact_us_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// المستهلك - يتفاعل مع تغييرات الحالة
class ContactUsViewConsumer extends StatelessWidget {
  const ContactUsViewConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactCubit, ContactState>(
      listener: (context, state) {
        if (state is ContactError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return const ContactUsViewBody();
      },
    );
  }
}
