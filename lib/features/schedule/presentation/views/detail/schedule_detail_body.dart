import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_detail_view_model.dart';
import 'package:dutytable/features/schedule/presentation/views/detail/widgets/emotion_color_section.dart';
import 'package:dutytable/features/schedule/presentation/views/detail/widgets/location_section.dart';
import 'package:dutytable/features/schedule/presentation/views/detail/widgets/memo_section.dart';
import 'package:dutytable/features/schedule/presentation/views/detail/widgets/repeat_section.dart';
import 'package:dutytable/features/schedule/presentation/views/detail/widgets/schedule_date_time.dart';
import 'package:dutytable/features/schedule/presentation/views/detail/widgets/success_status_section.dart';

class ScheduleDetailBody extends StatelessWidget {
  const ScheduleDetailBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Consumer<ScheduleDetailViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                const SizedBox(height: 16),

                /// 일정 상세 - 감정 및 색
                EmotionColorSection(),

                _DividerGap(),

                /// 일정 상세 - 일정 날짜 및 시간
                ScheduleDateTime(),

                _DividerGap(),

                /// 일정 상세 - 완료 여부
                SuccessStatusSection(),

                _DividerGap(),

                /// 일정 상세 - 지도(위치 및 마커)
                LocationSection(),

                _DividerGap(),

                /// 일정 상세 - 반복
                RepeatSection(),

                _DividerGap(),

                /// 일정 상세 - 메모
                MemoSection(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DividerGap extends StatelessWidget {
  const _DividerGap();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Divider(),
    );
  }
}
