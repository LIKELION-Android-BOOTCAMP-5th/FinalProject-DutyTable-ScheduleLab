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
        return const Center(child: CircularProgressIndicator());

      case ViewState.error:
        final message = context.read<SharedCalendarViewModel>().errorMessage;
        return Center(
          child: Text(
            message ?? '알 수 없는 오류',
            style: const TextStyle(color: Colors.red),
          ),
        );

      case ViewState.success:
        final calendars = context.read<SharedCalendarViewModel>().calendarList;

        if (calendars == null || calendars.isEmpty) {
          return const Center(child: Text('공유 캘린더가 없습니다.'));
        }

        return ListView.separated(
          itemCount: calendars.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, index) {
            return _CalendarListItem(calendar: calendars[index]);
          },
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
    final viewModel = context.watch<SharedCalendarViewModel>();

    final isAdmin = calendar.user_id == viewModel.currentUserId;
    final isSelected = viewModel.isSelected(calendar.id.toString());

    return GestureDetector(
      onTap: () => context.push("/shared/schedule", extra: calendar),
      child: CalendarCard(
        imageUrl: calendar.imageURL,
        title: calendar.title,
        deleteMode: viewModel.deleteMode,
        isAdmin: isAdmin,
        members: calendar.calendarMemberModel?.length ?? 0,
        isSelected: isSelected,
        onChangeSelected: () =>
            viewModel.toggleSelected(calendar.id.toString()),
      ),
    );
  }
}
