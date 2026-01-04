import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/widgets/custom_floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/custom_confirm_dialog.dart';
import '../../../schedule/presentation/viewmodels/schedule_view_model.dart';
import '../../data/models/calendar_model.dart';

/// 리스트 탭(Provider 주입)
class ListTab extends StatelessWidget {
  final CalendarModel? calendar;

  const ListTab({super.key, this.calendar});

  @override
  Widget build(BuildContext context) {
    // 스케쥴 뷰모델 주입
    return ChangeNotifierProvider(
      create: (context) => ScheduleViewModel(calendar: calendar),
      child: _ListTab(),
    );
  }
}

class _ListTab extends StatelessWidget {
  /// 리스트 탭(private)
  const _ListTab({super.key});

  @override
  Widget build(BuildContext context) {
    // 스케쥴 뷰모델 주입
    return Consumer<ScheduleViewModel>(
      builder: (context, viewModel, child) {
        final items = viewModel.selectedFilteringList;
        return Scaffold(
          backgroundColor: AppColors.background(context),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8.0,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          spacing: 8,
                          children: [
                            // 커스텀 드롭다운 버튼 사용
                            CustomDropdownButton(
                              // 기본 선택 값
                              defaultValue: viewModel.selectedFilterYears,
                              // 눌렀을 떄 나오는 아이템들
                              items: viewModel.filterYears
                                  .map<DropdownMenuItem<int>>((int year) {
                                    return DropdownMenuItem<int>(
                                      value: year,
                                      child: Text("${year.toString()}년"),
                                    );
                                  })
                                  .toList(),
                              // 아이템 눌렀을 떄 실행 할 함수
                              onChanged: (dynamic newValue) {
                                viewModel.selectedYear(newValue ?? 0);
                              },
                            ),
                            // 커스텀 드롭다운 버튼 사용
                            CustomDropdownButton(
                              // 기본 선택 값
                              defaultValue: viewModel.selectedFilterMonth,
                              // 눌렀을 떄 나오는 아이템들
                              items: viewModel.filterMonths
                                  .map<DropdownMenuItem<int>>((int month) {
                                    return DropdownMenuItem<int>(
                                      value: month,
                                      child: Text("${month.toString()}월"),
                                    );
                                  })
                                  .toList(),
                              // 아이템 눌렀을 떄 실행 할 함수
                              onChanged: (dynamic newValue) {
                                viewModel.selectedMonth(newValue ?? 0);
                              },
                            ),
                            // 커스텀 드롭다운 버튼 사용
                            CustomDropdownButton(
                              // 기본 선택 값
                              defaultValue: viewModel.selectedFilterColor,
                              // 눌렀을 떄 나오는 아이템들
                              items: viewModel.filterColors
                                  .map<DropdownMenuItem<String>>((
                                    String color,
                                  ) {
                                    return DropdownMenuItem<String>(
                                      value: color,
                                      child: color == '전체'
                                          ? Text(color)
                                          : Container(
                                              width: 28,
                                              height: 28,
                                              decoration: BoxDecoration(
                                                color: Color(int.parse(color)),
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: AppColors.textSub(
                                                    context,
                                                  ),
                                                ),
                                              ),
                                            ),
                                    );
                                  })
                                  .toList(),
                              // 아이템 눌렀을 떄 실행 할 함수
                              onChanged: (dynamic newValue) {
                                viewModel.selectedColor(newValue ?? "");
                              },
                            ),
                          ],
                        ),
                        // TODO: 방장만 표시
                        viewModel.calendar?.userId == viewModel.currentUserId
                            ? viewModel.deleteMode
                                  ? Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            viewModel.cancelDeleteMode();
                                          },
                                          child: Text(
                                            "취소",
                                            style: TextStyle(
                                              color: AppColors.primaryBlue,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        GestureDetector(
                                          onTap: () {
                                            if (viewModel
                                                .selectedIds
                                                .isNotEmpty) {
                                              CustomConfirmationDialog.show(
                                                context,
                                                content: '정말 삭제 하시겠습니까?',
                                                confirmColor: AppColors.danger(
                                                  context,
                                                ),
                                                onConfirm: () async {
                                                  await viewModel
                                                      .deleteAllSchedules();
                                                  viewModel.cancelDeleteMode();
                                                },
                                              );
                                            } else {
                                              null;
                                            }
                                          },
                                          child: Text(
                                            "삭제",
                                            style: TextStyle(
                                              color:
                                                  viewModel
                                                      .selectedIds
                                                      .isNotEmpty
                                                  ? AppColors.pureDanger
                                                  : AppColors.textSub(context),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        viewModel.toggleDeleteMode();
                                      },
                                      child: Text(
                                        "선택삭제",
                                        style: TextStyle(
                                          color: AppColors.primaryBlue,
                                        ),
                                      ),
                                    )
                            : SizedBox.shrink(),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // 공유 캘린더일 때: 내 일정 불러오기
                          if (viewModel.calendar?.type != "personal") ...[
                            Checkbox(
                              value: viewModel.isShowMySchedule,
                              activeColor: AppColors.primaryBlue,
                              checkColor: AppColors.pureWhite,
                              side: BorderSide(
                                color: AppColors.textSub(context),
                              ),
                              onChanged: (_) =>
                                  viewModel.toggleFetchMySchedule(),
                            ),
                            Text(
                              "내 일정 불러오기",
                              style: TextStyle(
                                color: AppColors.textMain(context),
                              ),
                            ),
                          ]
                          // 내 캘린더일 때: 모든 공유 일정 불러오기
                          else ...[
                            Checkbox(
                              value: viewModel.isShowAllSchedule,
                              activeColor: AppColors.primaryBlue,
                              checkColor: AppColors.pureWhite,
                              side: BorderSide(
                                color: AppColors.textSub(context),
                              ),
                              onChanged: (_) =>
                                  viewModel.toggleFetchAllSchedule(),
                            ),
                            Text(
                              "공유 일정 불러오기",
                              style: TextStyle(
                                color: AppColors.textMain(context),
                              ),
                            ),
                          ],
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 8.0,
                  ),
                  child: ListView.separated(
                    itemCount: viewModel.selectedFilteringList.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      // 이 일정이 현재 탭의 캘린더 소유인지 확인 (삭제 권한 여부)
                      final bool isMySchedule =
                          item.calendarId == viewModel.calendar?.id;

                      return CustomScheduleCard(
                        emoji: item.emotionTag ?? "",
                        title: item.title,
                        color: item.colorValue,
                        startedAt: item.startedAt,
                        endedAt: item.endedAt,
                        // 1. 내 일정이면서 삭제 모드일 때만 체크박스를 보여줌
                        isDeleteMode: viewModel.deleteMode && isMySchedule,
                        // 2. 내 일정이 아닌데 혹시 선택되어 있더라도 테두리를 표시하지 않음
                        isSelected:
                            isMySchedule &&
                            viewModel.isSelected(item.id.toString()),
                        onChangeSelected: () {
                          if (isMySchedule) {
                            viewModel.toggleSelected(item.id.toString());
                          }
                        },
                        onTap: () async {
                          if (viewModel.deleteMode) {
                            // 3. 삭제 모드일 때: 내 일정인 경우만 토글, 아니면 아무것도 안 함
                            if (isMySchedule) {
                              viewModel.toggleSelected(item.id.toString());
                            }
                            return;
                          }

                          // 일반 모드 상세 페이지 이동 로직
                          bool canEdit = false;
                          if (viewModel.calendar?.type == "personal") {
                            canEdit = isMySchedule;
                          } else {
                            final isTabAdmin =
                                viewModel.calendar?.userId ==
                                viewModel.currentUserId;
                            canEdit = isTabAdmin && isMySchedule;
                          }

                          final bool? isDeleted = await context.push<bool>(
                            "/schedule/detail",
                            extra: {"schedule": item, "isAdmin": canEdit},
                          );

                          if (isDeleted == true) {
                            await viewModel.fetchSchedules();
                          }
                        },
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12.0),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton:
              viewModel.calendar!.userId == viewModel.currentUserId
              ? CustomFloatingActionButton(calendarId: viewModel.calendar!.id)
              : null,
        );
      },
    );
  }
}

class CustomDropdownButton extends StatelessWidget {
  /// 기본 선택 값
  final dynamic defaultValue;

  /// 눌렀을 떄 나오는 아이템들
  final List<DropdownMenuItem<dynamic>> items;

  /// 아이템 눌렀을 떄 실행 할 함수
  final void Function(dynamic) onChanged;

  /// 커스텀 드롭다운 버튼
  const CustomDropdownButton({
    super.key,
    this.defaultValue,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.textSub(context)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: DropdownButton(
        value: defaultValue,
        items: items,
        onChanged: onChanged,
        underline: const SizedBox.shrink(), // 기본 밑줄 제거
        dropdownColor: AppColors.surface(context),
        icon: Icon(
          Icons.keyboard_arrow_down,
          size: 18,
          color: AppColors.textSub(context),
        ),
        isDense: true,
        style: TextStyle(
          color: AppColors.textMain(context),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class CustomScheduleCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String color;
  final DateTime startedAt;
  final DateTime endedAt;
  final bool isDeleteMode;
  final bool isSelected;
  final VoidCallback onChangeSelected;
  final VoidCallback onTap;

  /// 커스텀 일정 카드 UI
  const CustomScheduleCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.color,
    required this.startedAt,
    required this.endedAt,
    required this.isDeleteMode,
    required this.isSelected,
    required this.onChangeSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: isSelected ? 2 : 1,
            color: isSelected
                ? AppColors.pureDanger
                : (isDarkMode ? AppColors.dBorder : AppColors.lBorder),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.maxFinite,
            height: 52,
            child: Row(
              spacing: 8,
              children: [
                Container(
                  width: 6,
                  height: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Color(int.parse(color)),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                Text(emoji, style: TextStyle(fontSize: 28)),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMain(context),
                        ),
                      ),
                      Text(
                        formatScheduleDate(startedAt, endedAt),
                        style: TextStyle(
                          color: AppColors.textSub(context),
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                isDeleteMode
                    ? Checkbox(
                        value: isSelected,
                        activeColor: AppColors.pureDanger,
                        onChanged: (_) => onChangeSelected(),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String formatScheduleDate(DateTime startedAt, DateTime endedAt) {
  final start = startedAt;
  final end = endedAt;

  // '년 월 일' 포맷터 (예: 2025년 12월 4일)
  final dateFormat = DateFormat('yyyy년 M월 d일', 'ko_KR');
  // '시:분' 포맷터 (예: 09:00)
  final timeFormat = DateFormat('HH:mm');

  // 1. 시작일과 종료일이 같은 날짜인지 확인합니다.
  final isSameDay =
      start.year == end.year &&
      start.month == end.month &&
      start.day == end.day;

  if (isSameDay) {
    // 2. 같은 날짜일 경우: '2025년 12월 4일 · 09:00 ~ 18:00' 형식
    final datePart = dateFormat.format(start);
    final startTimePart = timeFormat.format(start);
    final endTimePart = timeFormat.format(end);

    return '$datePart · $startTimePart ~ $endTimePart';
  } else {
    // 3. 다른 날짜일 경우: '2025년 12월 4일 · 2025년 12월 5일' 형식
    final startDatePart = dateFormat.format(start);
    final endDatePart = dateFormat.format(end);

    return '$startDatePart · $endDatePart';
  }
}
