// lib/featurees/main_screens/location/presentation/views/location_view_body.dart

import 'package:appp/core/constans/constans_kword.dart';
import 'package:appp/featurees/main_screens/location_branches/presentation/cubit/location_branches_state.dart';
import 'package:appp/featurees/main_screens/location_branches/presentation/widgets/branch_details_section.dart';
import 'package:appp/featurees/main_screens/location_branches/presentation/widgets/branch_map_section.dart';
import 'package:appp/featurees/main_screens/location_branches/presentation/widgets/location_search_field.dart';
import 'package:appp/featurees/main_screens/location_branches/presentation/widgets/search_results_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// جسم صفحة المواقع
class LocationViewBody extends StatelessWidget {
  final LocationLoaded state;

  const LocationViewBody({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kHorizintalPadding),
          child: Column(
            children: [
              const SizedBox(height: 8),
              const LocationSearchField(),
              const SizedBox(height: 5),
              Expanded(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          BranchMapSection(
                            allBranches: state.allBranches,
                            selectedBranch: state.selectedBranch,
                          ),
                          if (state.selectedBranch != null)
                            BranchDetailsSection(branch: state.selectedBranch!),
                        ],
                      ),
                    ),
                    if (state.isSearching && state.filteredBranches.isNotEmpty)
                      SearchResultsOverlay(
                        filteredBranches: state.filteredBranches,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
