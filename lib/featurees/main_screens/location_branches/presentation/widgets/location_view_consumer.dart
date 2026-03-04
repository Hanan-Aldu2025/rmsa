// lib/featurees/main_screens/location/presentation/views/location_view_consumer.dart

import 'package:appp/featurees/main_screens/location_branches/presentation/cubit/location_branches_cubit.dart';
import 'package:appp/featurees/main_screens/location_branches/presentation/cubit/location_branches_state.dart';
import 'package:appp/featurees/main_screens/location_branches/presentation/widgets/location_view_body.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// المستهلك - يتفاعل مع تغييرات الحالة
class LocationViewConsumer extends StatelessWidget {
  const LocationViewConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        if (state is LocationLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            ),
          );
        } else if (state is LocationError) {
          return Scaffold(body: Center(child: Text(state.message)));
        } else if (state is LocationLoaded) {
          return LocationViewBody(state: state);
        }
        return const SizedBox();
      },
    );
  }
}
