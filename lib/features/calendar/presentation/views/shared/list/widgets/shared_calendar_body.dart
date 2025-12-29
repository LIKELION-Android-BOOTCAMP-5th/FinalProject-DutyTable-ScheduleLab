import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/calendar/data/models/calendar_model.dart';
import 'package:dutytable/features/calendar/presentation/viewmodels/shared_calendar_view_model.dart';
import 'package:dutytable/features/calendar/presentation/widgets/calendar_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SharedCalendarBody extends StatelessWidget {
  /// 공유 캘린더 목록 - 바디
  const SharedCalendarBody({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.select<SharedCalendarViewModel, ViewState>(
      (viewModel) => viewModel.state,
    );

    switch (state) {
      case ViewState.loading:
        return Center(
          child: CircularProgressIndicator(
            color: AppColors.primary(context),
            strokeWidth: 2,
          ),
        );

      case ViewState.error:
        final message = context.read<SharedCalendarViewModel>().errorMessage;
        return Center(
          child: Text(
            message ?? '알 수 없는 오류',
            style: TextStyle(color: AppColors.danger(context)),
          ),
        );

      case ViewState.success:
        final calendars = context.read<SharedCalendarViewModel>().calendarList;

        if (calendars == null || calendars.isEmpty) {
          return Center(
            child: Text(
              '공유 캘린더가 없습니다.',
              style: TextStyle(color: AppColors.textSub(context)),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: ListView.separated(
            itemCount: calendars.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, index) {
              return _CalendarListItem(calendar: calendars[index]);
            },
          ),
        );
    }
  }
}

class _CalendarListItem extends StatelessWidget {
  final CalendarModel calendar;

  /// 공유 캘린더 목록 - 바디 : - 공유 캘린더 목록
  const _CalendarListItem({required this.calendar});

  @override
  Widget build(BuildContext context) {
    /// 방장인지 여부
    final isAdmin = context.select<SharedCalendarViewModel, bool>(
      (vm) => calendar.userId == vm.currentUserId,
    );

    /// 캘린더 삭제 모드
    final deleteMode = context.select<SharedCalendarViewModel, bool>(
      (vm) => vm.deleteMode,
    );

    /// 캘린더 삭제 모드 true 일때 - 캘린더 선택 여부
    final isSelected = context.select<SharedCalendarViewModel, bool>(
      (vm) => vm.isSelected(calendar.id.toString()),
    );

    return GestureDetector(
      onTap: () async {
        await context.push("/shared/schedule", extra: calendar);
        context.read<SharedCalendarViewModel>().fetchCalendars();
      },
      child: CalendarCard(
        imageUrl: calendar.imageURL,
        title: calendar.title,
        deleteMode: deleteMode,
        isAdmin: isAdmin,
        members: calendar.calendarMemberModel?.length ?? 0,
        isSelected: isSelected,
        calendarId: calendar.id,
        onChangeSelected: () => context
            .read<SharedCalendarViewModel>()
            .toggleSelected(calendar.id.toString()),
      ),
    );
  }
}
