// lib/featurees/main_screens/location/presentation/views/widgets/branch_map_section.dart

import 'package:appp/featurees/main_screens/home/presentation/views/domain_layer.dart';
import 'package:appp/featurees/main_screens/location_branches/presentation/cubit/location_branches_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// قسم الخريطة لعرض مواقع الفروع
class BranchMapSection extends StatefulWidget {
  final List<BranchEntity> allBranches;
  final BranchEntity? selectedBranch;

  const BranchMapSection({
    super.key,
    required this.allBranches,
    this.selectedBranch,
  });

  @override
  State<BranchMapSection> createState() => _BranchMapSectionState();
}

class _BranchMapSectionState extends State<BranchMapSection> {
  GoogleMapController? _mapController;

  /// تكبير الخريطة لتشمل جميع الماركرز
  void _zoomToFitAll(List<BranchEntity> branches) {
    if (branches.isEmpty || _mapController == null) return;

    double minLat = branches.first.lat;
    double maxLat = branches.first.lat;
    double minLng = branches.first.lng;
    double maxLng = branches.first.lng;

    for (var b in branches) {
      if (b.lat < minLat) minLat = b.lat;
      if (b.lat > maxLat) maxLat = b.lat;
      if (b.lng < minLng) minLng = b.lng;
      if (b.lng > maxLng) maxLng = b.lng;
    }

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        50,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        child: GoogleMap(
          gestureRecognizers: const {},
          rotateGesturesEnabled: true,
          scrollGesturesEnabled: true,
          tiltGesturesEnabled: true,
          zoomGesturesEnabled: true,
          initialCameraPosition: CameraPosition(
            target: widget.selectedBranch != null
                ? LatLng(widget.selectedBranch!.lat, widget.selectedBranch!.lng)
                : const LatLng(15.350, 44.200),
            zoom: 10,
          ),
          onMapCreated: (controller) {
            _mapController = controller;
            _zoomToFitAll(widget.allBranches);
          },
          markers: widget.allBranches.map((branch) {
            final isSelected = branch.id == widget.selectedBranch?.id;
            final langCode = Localizations.localeOf(context).languageCode;

            return Marker(
              markerId: MarkerId(branch.id),
              position: LatLng(branch.lat, branch.lng),
              infoWindow: InfoWindow(
                title: branch.getName(langCode),
                snippet: branch.getAddress(langCode),
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                isSelected
                    ? BitmapDescriptor.hueOrange
                    : BitmapDescriptor.hueRed,
              ),
              onTap: () {
                context.read<LocationCubit>().selectBranch(branch);
                _mapController?.animateCamera(
                  CameraUpdate.newLatLng(LatLng(branch.lat, branch.lng)),
                );
              },
            );
          }).toSet(),
        ),
      ),
    );
  }
}
