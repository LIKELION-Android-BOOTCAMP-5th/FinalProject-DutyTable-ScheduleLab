import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_detail_view_model.dart';
import 'package:dutytable/features/schedule/presentation/views/widgets/naver_map_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocationSection extends StatelessWidget {
  /// 일정 상세 - 지도(위치 및 마커)
  const LocationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScheduleDetailViewModel>();
    final address = viewModel.address;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: address != null
          ? Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.location_pin, color: AppColors.iconSub(context)),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          address,
                          style: TextStyle(color: AppColors.textMain(context)),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                if (address.isNotEmpty &&
                    viewModel.latitude != null &&
                    viewModel.longitude != null)
                  RepaintBoundary(
                    child: NaverMapSection(
                      latitude: viewModel.latitude!,
                      longitude: viewModel.longitude!,
                    ),
                  ),
              ],
            )
          : Row(
              children: [
                Icon(Icons.location_pin, color: AppColors.iconSub(context)),
                SizedBox(width: 10),
                Text(
                  "일정 장소가 없습니다",
                  style: TextStyle(color: AppColors.textSub(context)),
                ),
              ],
            ),
    );
  }
}
