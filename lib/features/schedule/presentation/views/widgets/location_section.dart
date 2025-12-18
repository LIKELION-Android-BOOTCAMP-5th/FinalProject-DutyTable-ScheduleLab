import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_add_view_model.dart';
import 'package:dutytable/features/schedule/presentation/views/location_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:provider/provider.dart';

class LocationSection extends StatelessWidget {
  const LocationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScheduleAddViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "일정 장소",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: TextFormField(
                key: ValueKey(viewModel.address),
                initialValue: viewModel.address,
                readOnly: true,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: "주소를 입력해주세요",
                  hintStyle: TextStyle(
                    color: AppColors.commonGrey,
                    fontWeight: FontWeight.w600,
                  ),
                  filled: true,
                  fillColor: AppColors.card(context),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.cardBorder(context),
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.cardBorder(context),
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            GestureDetector(
              onTap: () async {
                final selected = await showLocationDialog(context);
                if (selected == null) return;

                final geo = await viewModel.geocodeAddress(selected.address);
                if (geo == null) return;

                viewModel.setLocation(
                  address: selected.address,
                  latitude: geo['latitude']!.toString(),
                  longitude: geo['longitude']!.toString(),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  color: AppColors.commonBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.location_pin, color: AppColors.commonWhite),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        if (viewModel.address != null) _NaverMap(),
      ],
    );
  }
}

class _NaverMap extends StatelessWidget {
  const _NaverMap({super.key});

  @override
  Widget build(BuildContext context) {
    final latLng = context.select<ScheduleAddViewModel, NLatLng?>((vm) {
      if (vm.latitude == null || vm.longitude == null) return null;
      return NLatLng(double.parse(vm.latitude!), double.parse(vm.longitude!));
    });

    if (latLng == null) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text("위치 정보 없음")),
      );
    }

    return Container(
      width: 400,
      height: 400,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
      child: NaverMap(
        options: NaverMapViewOptions(
          initialCameraPosition: NCameraPosition(target: latLng, zoom: 15),
        ),
        onMapReady: (controller) {
          controller.clearOverlays();
          controller.addOverlay(
            NMarker(id: "schedule_location", position: latLng),
          );
        },
      ),
    );
  }
}
