// lib/featurees/main_screens/location/presentation/views/location_view.dart

import 'package:appp/featurees/main_screens/home/presentation/views/presentation_layer.dart';
import 'package:appp/featurees/main_screens/location_branches/data/datasources/location_remote_data_source.dart';
import 'package:appp/featurees/main_screens/location_branches/data/repositories/location_repository_impl.dart';
import 'package:appp/featurees/main_screens/location_branches/presentation/cubit/location_branches_cubit.dart';
import 'package:appp/featurees/main_screens/location_branches/presentation/widgets/location_view_consumer.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// صفحة المواقع - نقطة الدخول
class LocationView extends StatelessWidget {
  const LocationView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeSelectedBranch = context.read<HomeCubit>().state.selectedBranch;

    return BlocProvider(
      create: (context) => LocationCubit(
        repository: LocationRepositoryImpl(
          remoteDataSource: LocationRemoteDataSource(),
        ),
      )..fetchBranches(homeSelectedBranch: homeSelectedBranch),
      child: BlocListener<HomeCubit, HomeState>(
        listenWhen: (previous, current) =>
            previous.selectedBranch != current.selectedBranch,
        listener: (context, homeState) {
          if (homeState.selectedBranch != null) {
            context.read<LocationCubit>().selectBranch(
              homeState.selectedBranch!,
            );
          }
        },
        child: const LocationViewConsumer(),
      ),
    );
  }
}
