import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_add_view_model.dart';
import 'package:dutytable/features/schedule/presentation/views/widgets/color_section.dart';
import 'package:dutytable/features/schedule/presentation/views/widgets/done_status_section.dart';
import 'package:dutytable/features/schedule/presentation/views/widgets/emotion_section.dart';
import 'package:dutytable/features/schedule/presentation/views/widgets/location_search_screen.dart';
import 'package:dutytable/features/schedule/presentation/views/widgets/location_section.dart';
import 'package:dutytable/features/schedule/presentation/views/widgets/memo_section.dart';
import 'package:dutytable/features/schedule/presentation/views/widgets/repeat_option_section.dart';
import 'package:dutytable/features/schedule/presentation/views/widgets/repeat_section.dart';
import 'package:dutytable/features/schedule/presentation/views/widgets/start_and_end_date_section.dart';
import 'package:dutytable/features/schedule/presentation/views/widgets/start_and_end_time_section.dart';
import 'package:dutytable/features/schedule/presentation/views/widgets/title_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScheduleAddBody extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const ScheduleAddBody({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScheduleAddViewModel>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  /// 감정 - 선택 사항(감정 아이콘 + 버튼)
                  EmotionSection(
                    selectedEmotion: viewModel.emotionTag,
                    onEmotionSelected: (emotion) {
                      viewModel.selectedEmotion = emotion;
                    },
                  ),

                  const SizedBox(height: 24),

                  /// 컬러 - 필수 사항(원형 + 색깔 + 버튼)
                  ColorSection(
                    selectColor: viewModel.colorValue,
                    onColorSelected: (color) {
                      viewModel.selectedColor = color;
                    },
                  ),

                  const SizedBox(height: 24),

                  /// 제목 - 필수 사항(텍스트 필드)
                  TitleSection(
                    title: viewModel.title,
                    onTitle: (title) {
                      viewModel.setTitle(title);
                    },
                  ),

                  const SizedBox(height: 24),

                  /// 완료 - 기본값(미완료), 스위치
                  DoneStatusSection(
                    isDone: viewModel.isDone,
                    onIsDone: (done) {
                      viewModel.setIsDone(done);
                    },
                  ),

                  const SizedBox(height: 24),

                  /// 시작일 ~ 종료일(캘린더 탭 - 선택한 날짜, 리스트 탭 - 오늘 날짜)
                  StartAndEndDateSection(
                    startDate: viewModel.startDate,
                    endDate: viewModel.endDate,
                    onStartDate: (date) {
                      viewModel.startDate = date;
                    },
                    onEndDate: (date) {
                      viewModel.endDate = date;
                    },
                  ),

                  const SizedBox(height: 24),

                  /// 시작시간 ~ 종료시간(기본 값 - 07:00 ~ 08:00)
                  StartAndEndTimeSection(
                    startTime: viewModel.startTime,
                    endTime: viewModel.endTime,
                    onStartTime: (time) {
                      viewModel.startTime = time;
                    },
                    onEndTime: (time) {
                      viewModel.endTime = time;
                    },
                  ),

                  const SizedBox(height: 24),

                  /// 일정 반복 - 선택 사항(기본 값 - false, 체크 박스)
                  RepeatSection(
                    isRepeat: viewModel.isRepeat,
                    repeatOption: viewModel.repeatOption,
                    repeatNum: viewModel.repeatNum,
                    onRepeatToggle: (value) => viewModel.isRepeat = value,
                    onRepeatNum: (value) => viewModel.repeatNum = value,
                    onRepeatOption: (value) => viewModel.repeatOption = value,
                  ),

                  const SizedBox(height: 24),

                  /// 반복 옵션 - 일정 반복(false - 비활성, true - 활성)
                  RepeatOptionSection(
                    isRepeat: viewModel.isRepeat,
                    weekendException: viewModel.weekendException,
                    holidayException: viewModel.holidayException,
                    repeatCount: viewModel.repeatCount,
                    onWeekendException: (value) =>
                        viewModel.weekendException = value,
                    onHolidayException: (value) =>
                        viewModel.holidayException = value,
                    onRepeatCount: (value) => viewModel.repeatCount = value,
                  ),

                  const SizedBox(height: 24),

                  /// 주소 - 선택 사항
                  LocationSection(
                    address: viewModel.address,
                    latitude: viewModel.latitude,
                    longitude: viewModel.longitude,
                    addressController: viewModel.addressController,
                    onSearch: () async {
                      final selected = await showLocationDialog(context);
                      if (selected == null) return;

                      await viewModel.updateLocationAction(selected.address);
                    },
                    onClear: () => viewModel.clearAddress(),
                  ),
                  const SizedBox(height: 24),

                  /// 메모 - 선택 사항(300자 제한)
                  MemoSection(
                    memo: viewModel.memo,
                    onMemo: (value) => viewModel.setMemo(value),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
