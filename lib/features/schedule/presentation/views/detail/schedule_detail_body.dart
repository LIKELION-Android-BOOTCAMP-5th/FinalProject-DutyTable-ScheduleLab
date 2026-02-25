import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_detail_view_model.dart';
import 'package:dutytable/features/schedule/presentation/views/detail/widgets/emotion_color_section.dart';
import 'package:dutytable/features/schedule/presentation/views/detail/widgets/location_section.dart';
import 'package:dutytable/features/schedule/presentation/views/detail/widgets/memo_section.dart';
import 'package:dutytable/features/schedule/presentation/views/detail/widgets/repeat_detail_section.dart';
import 'package:dutytable/features/schedule/presentation/views/detail/widgets/schedule_date_time.dart';
import 'package:dutytable/features/schedule/presentation/views/detail/widgets/success_status_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScheduleDetailBody extends StatelessWidget {
  const ScheduleDetailBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Consumer<ScheduleDetailViewModel>(
          builder: (context, viewModel, child) {
            // 데이터 로딩 중이나 에러 시 예외 처리
            if (viewModel.state == DetailViewState.loading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            return Column(
              children: [
                const SizedBox(height: 16),

                /// 일정 상세 - 감정 및 색
                const EmotionColorSection(),

                const _DividerGap(),

                /// 일정 상세 - 일정 날짜 및 시간
                const ScheduleDateTime(),

                const _DividerGap(),

                /// 일정 상세 - 완료 여부
                const SuccessStatusSection(),

                const _DividerGap(),

                /// 일정 상세 - 지도(위치 및 마커)
                const LocationSection(),

                const _DividerGap(),

                ///일정 상세 - 반복
                // 반복 설정이 있을 때만 보여주거나, 없으면 '없음'으로 표시
                const RepeatDetailSection(),

                const _DividerGap(),

                /// 일정 상세 - 메모
                const MemoSection(),

                const SizedBox(height: 32),
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
