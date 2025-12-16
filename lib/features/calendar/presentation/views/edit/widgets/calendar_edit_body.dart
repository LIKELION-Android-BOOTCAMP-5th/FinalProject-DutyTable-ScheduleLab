import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/widgets/custom_calendar_setting_content_box.dart';
import 'package:dutytable/core/widgets/custom_confirm_dialog.dart';
import 'package:dutytable/features/calendar/presentation/viewmodels/calendar_edit_view_model.dart';
import 'package:dutytable/features/calendar/presentation/views/edit/widgets/custom_calendar_edit_text_field.dart';
import 'package:dutytable/features/calendar/presentation/widgets/chat_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalendarEditBody extends StatelessWidget {
  final CalendarEditViewModel viewModel;
  const CalendarEditBody({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<CalendarEditViewModel>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 캘린더 이름
              CustomCalendarEditTextField(
                title: const Text(
                  "캘린더 이름",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                controller: viewModel.titleController,
              ),

              const SizedBox(height: 40),

              /// 멤버 섹션
              const _CalendarMemberSection(),

              const SizedBox(height: 40),

              /// 캘린더 설명
              CustomCalendarEditTextField(
                title: const Text(
                  "캘린더 설명",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                controller: viewModel.descController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalendarMemberSection extends StatelessWidget {
  const _CalendarMemberSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text("캘린더 멤버", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        _CalendarMemberList(),
      ],
    );
  }
}

class _CalendarMemberList extends StatelessWidget {
  const _CalendarMemberList();

  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarEditViewModel>(
      builder: (_, viewModel, __) {
        final members = viewModel.calendar.calendarMemberModel;

        final isPersonal = members == null || members.isEmpty;

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: isPersonal ? 1 : members.length,
          itemBuilder: (_, index) {
            if (isPersonal) {
              return _PersonalOwnerTile(
                nickname: viewModel.calendar.ownerNickname,
              );
            }

            return _SharedMemberTile(
              member: members[index],
              isPersonalCalendar: viewModel.calendar.type == "personal",
            );
          },
          separatorBuilder: (_, __) => const SizedBox(height: 8),
        );
      },
    );
  }
}

class _PersonalOwnerTile extends StatelessWidget {
  final String nickname;

  const _PersonalOwnerTile({required this.nickname});

  @override
  Widget build(BuildContext context) {
    return CustomCalendarSettingContentBox(
      title: null,
      child: Row(
        children: [
          const CustomChatProfileImageBox(width: 24, height: 24),
          const SizedBox(width: 4),
          Text(nickname),
          const Text(" 👑"),
        ],
      ),
    );
  }
}

class _SharedMemberTile extends StatelessWidget {
  final dynamic member;
  final bool isPersonalCalendar;

  const _SharedMemberTile({
    required this.member,
    required this.isPersonalCalendar,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCalendarSettingContentBox(
      title: null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CustomChatProfileImageBox(width: 24, height: 24),
              const SizedBox(width: 4),
              Text(member.nickname),
            ],
          ),
          isPersonalCalendar
              ? const SizedBox.shrink()
              : member.is_admin
              ? const Text("👑")
              : const _RoleButton(),
        ],
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  const _RoleButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        CustomConfirmationDialog.show(
          context,
          content: "방장 권한을 넘기시겠습니까?",
          confirmColor: AppColors.commonBlue,
          onConfirm: () {
            // TODO: 방장 권한 위임 로직
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.commonBlue),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text("권한", style: TextStyle(color: AppColors.commonBlue)),
      ),
    );
  }
}
