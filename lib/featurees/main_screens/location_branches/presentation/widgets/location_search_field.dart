// lib/featurees/main_screens/location/presentation/views/widgets/location_search_field.dart

import 'package:appp/featurees/main_screens/home/presentation/views/presentation_layer.dart';
import 'package:appp/featurees/main_screens/location_branches/presentation/cubit/location_branches_cubit.dart';
import 'package:appp/generated/l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// حقل البحث في صفحة المواقع
class LocationSearchField extends StatelessWidget {
  const LocationSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);

    return AppSearchField(
      hintText: lang.searchBranch,
      controller: context.read<LocationCubit>().searchController,
      onChanged: (value) {
        context.read<LocationCubit>().searchBranches(value);
      },
    );
  }
}
