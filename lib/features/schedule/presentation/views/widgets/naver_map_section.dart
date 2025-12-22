import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class NaverMapSection extends StatelessWidget {
  final String latitude;
  final String longitude;

  const NaverMapSection({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;

    final lat = double.tryParse(latitude) ?? 0.0;
    final lng = double.tryParse(longitude) ?? 0.0;
    final latLng = NLatLng(lat, lng);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: SizedBox(
        width: deviceWidth,
        height: deviceWidth,
        child: NaverMap(
          options: NaverMapViewOptions(
            initialCameraPosition: NCameraPosition(target: latLng, zoom: 15),
            zoomGesturesEnable: true,
            logoClickEnable: false,
            nightModeEnable: isDark,
          ),

          onMapReady: (controller) {
            controller.addOverlay(
              NMarker(id: "schedule_location", position: latLng),
            );
          },
        ),
      ),
    );
  }
}
