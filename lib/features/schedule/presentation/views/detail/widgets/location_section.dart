import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:provider/provider.dart';

class LocationSection extends StatelessWidget {
  /// 일정 상세 - 지도(위치 및 마커)
  const LocationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScheduleDetailViewModel>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: viewModel.address != null
          ? Column(
              children: [
                /// 지도 - 위치, 길찾기 텍스트 링크
                Row(
                  children: [
                    Icon(Icons.location_pin),

                    const SizedBox(width: 10),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("대한민국 서울특별시 광화문역"),

                        const SizedBox(height: 10),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                _NaverMap(),
              ],
            )
          : Row(
              children: [
                Icon(Icons.location_pin),

                const SizedBox(width: 10),

                Text("일정 장소가 없습니다"),
              ],
            ),
    );
  }
}

class _NaverMap extends StatelessWidget {
  const _NaverMap({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScheduleDetailViewModel>();

    if (viewModel.latitude == null || viewModel.longitude == null) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text("위치 정보 없음")),
      );
    }

    final target = NLatLng(
      double.parse(viewModel.latitude!),
      double.parse(viewModel.longitude!),
    );

    return SizedBox(
      width: 400,
      height: 400,
      child: NaverMap(
        options: NaverMapViewOptions(
          initialCameraPosition: NCameraPosition(target: target, zoom: 15),
        ),
        onMapReady: (controller) {
          controller.clearOverlays();
          controller.addOverlay(
            NMarker(id: "schedule_location", position: target),
          );
        },
      ),
    );
  }
}
