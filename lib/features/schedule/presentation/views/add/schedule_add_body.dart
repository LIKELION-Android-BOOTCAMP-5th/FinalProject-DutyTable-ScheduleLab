import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_add_view_model.dart';
import 'package:dutytable/features/schedule/presentation/views/add/widgets/location_section.dart';
import 'package:dutytable/features/schedule/presentation/views/add/widgets/color_section.dart';
import 'package:dutytable/features/schedule/presentation/views/add/widgets/done_status_section.dart';
import 'package:dutytable/features/schedule/presentation/views/add/widgets/emotion_section.dart';
import 'package:dutytable/features/schedule/presentation/views/add/widgets/memo_section.dart';
import 'package:dutytable/features/schedule/presentation/views/add/widgets/repeat_option_section.dart';
import 'package:dutytable/features/schedule/presentation/views/add/widgets/repeat_section.dart';
import 'package:dutytable/features/schedule/presentation/views/add/widgets/start_and_end_date_section.dart';
import 'package:dutytable/features/schedule/presentation/views/add/widgets/start_and_end_time_section.dart';
import 'package:dutytable/features/schedule/presentation/views/add/widgets/title_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScheduleAddBody extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const ScheduleAddBody({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScheduleAddViewModel>(
      builder: (context, viewModel, child) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    /// 감정 - 선택 사항(감정 아이콘 + 버튼)
                    EmotionSection(),

                    const SizedBox(height: 24),

                    /// 컬러 - 필수 사항(원형 + 색깔 + 버튼)
                    ColorSection(),

                    const SizedBox(height: 24),

                    /// 제목 - 필수 사항(텍스트 필드)
                    TitleSection(),

                    const SizedBox(height: 24),

                    /// 완료 - 기본값(미완료), 스위치
                    DoneStatusSection(),

                    const SizedBox(height: 24),

                    /// 시작일 ~ 종료일(캘린더 탭 - 선택한 날짜, 리스트 탭 - 오늘 날짜)
                    StartAndEndDateSection(),

                    const SizedBox(height: 24),

                    /// 시작시간 ~ 종료시간(기본 값 - 07:00 ~ 08:00)
                    StartAndEndTimeSection(),

                    const SizedBox(height: 24),

                    /// 일정 반복 - 선택 사항(기본 값 - false, 체크 박스)
                    RepeatSection(),

                    const SizedBox(height: 24),

                    /// 반복 옵션 - 일정 반복(false - 비활성, true - 활성)
                    RepeatOptionSection(),

                    const SizedBox(height: 24),

                    /// 주소 - 선택 사항
                    LocationSection(),

                    const SizedBox(height: 24),

                    /// 메모 - 선택 사항(300자 제한)
                    MemoSection(),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
