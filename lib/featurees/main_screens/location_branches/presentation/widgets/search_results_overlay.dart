// lib/featurees/main_screens/location/presentation/views/widgets/search_results_overlay.dart

import 'package:appp/featurees/main_screens/home/presentation/views/domain_layer.dart';
import 'package:appp/featurees/main_screens/location_branches/presentation/cubit/location_branches_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// طبقة نتائج البحث المنبثقة
class SearchResultsOverlay extends StatelessWidget {
  final List<BranchEntity> filteredBranches;

  const SearchResultsOverlay({super.key, required this.filteredBranches});

  @override
  Widget build(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;

    return Positioned(
      top: 0,
      left: 16,
      right: 16,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 300),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
          ],
        ),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: filteredBranches.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final branch = filteredBranches[index];
            return ListTile(
              title: Text(branch.getName(langCode)),
              subtitle: Text(branch.getAddress(langCode)),
              onTap: () {
                context.read<LocationCubit>().selectBranch(branch);
                FocusScope.of(context).unfocus();
              },
            );
          },
        ),
      ),
    );
  }
}
