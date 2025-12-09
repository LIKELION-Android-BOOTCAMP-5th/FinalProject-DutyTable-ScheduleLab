import 'package:dutytable/core/widgets/back_actions_app_bar.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_add_view_model.dart';
import 'package:dutytable/features/schedule/presentation/widgets/address_section.dart';
import 'package:dutytable/features/schedule/presentation/widgets/color_section.dart';
import 'package:dutytable/features/schedule/presentation/widgets/done_status_section.dart';
import 'package:dutytable/features/schedule/presentation/widgets/emotion_section.dart';
import 'package:dutytable/features/schedule/presentation/widgets/memo_section.dart';
import 'package:dutytable/features/schedule/presentation/widgets/repeat_option_section.dart';
import 'package:dutytable/features/schedule/presentation/widgets/repeat_section.dart';
import 'package:dutytable/features/schedule/presentation/widgets/start_and_end_date_section.dart';
import 'package:dutytable/features/schedule/presentation/widgets/start_and_end_time_section.dart';
import 'package:dutytable/features/schedule/presentation/widgets/title_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScheduleAddScreen extends StatelessWidget {
  const ScheduleAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ScheduleAddViewModel(),
      child: _ScheduleAddScreen(),
    );
  }
}

class _ScheduleAddScreen extends StatelessWidget {
  const _ScheduleAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: BackActionsAppBar(
        title: Text(
          "일정 추가",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w800),
        ),
      ),

      body: Consumer<ScheduleAddViewModel>(
        builder: (context, viewModel, child) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),

                      /// 감정 - 선택 사항(감정 아이콘 + 버튼)
                      EmotionSection(),

                      const SizedBox(height: 16),

                      /// 컬러 - 필수 사항(원형 + 색깔 + 버튼)
                      ColorSection(),

                      const SizedBox(height: 16),

                      /// 제목 - 필수 사항(텍스트 필드)
                      TitleSection(),

                      const SizedBox(height: 16),

                      /// 완료 - 기본값(미완료), 스위치
                      DoneStatusSection(),

                      const SizedBox(height: 16),

                      /// 시작일 ~ 종료일(캘린더 탭 - 선택한 날짜, 리스트 탭 - 오늘 날짜)
                      StartAndEndDateSection(),

                      const SizedBox(height: 20),

                      /// 시작시간 ~ 종료시간(기본 값 - 07:00 ~ 08:00)
                      StartAndEndTimeSection(),

                      const SizedBox(height: 16),

                      /// 일정 반복 - 선택 사항(기본 값 - false, 체크 박스)
                      RepeatSection(),

                      const SizedBox(height: 20),

                      /// 반복 옵션 - 일정 반복(false - 비활성, true - 활성)
                      RepeatOptionSection(),

                      const SizedBox(height: 16),

                      /// 주소 - 선택 사항
                      AddressSection(),

                      const SizedBox(height: 16),

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
      ),
    );
  }
}
