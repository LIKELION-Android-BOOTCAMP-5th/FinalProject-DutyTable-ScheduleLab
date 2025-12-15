import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/widgets/custom_calendar_setting_content_box.dart';
import 'package:dutytable/core/widgets/custom_confirm_dialog.dart';
import 'package:dutytable/features/calendar/presentation/viewmodels/calendar_edit_view_model.dart';
import 'package:dutytable/features/calendar/presentation/views/edit/widgets/custom_calendar_edit_text_field.dart';
import 'package:dutytable/features/calendar/presentation/widgets/chat_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalendarEditBody extends StatelessWidget {
  const CalendarEditBody({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<CalendarEditViewModel>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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

              /// 캘린더 멤버 목록
              _CalendarMemberList(),

              const SizedBox(height: 40),

              /// 캘린더 설명 - 커스텀 캘린더 수정 텍스트 필드 사용
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

class _CalendarMemberList extends StatelessWidget {
  const _CalendarMemberList();

  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarEditViewModel>(
      builder: (_, viewModel, __) {
        final members = viewModel.calendar.calendarMemberModel;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("캘린더 멤버", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: (members == null || members.isEmpty)
                  ? 1
                  : members.length,
              itemBuilder: (_, index) {
                if (members == null || members.isEmpty) {
                  return _PersonalMemberTile(
                    ownerNickname: viewModel.calendar.ownerNickname,
                  );
                }

                return _SharedMemberTile(
                  member: members[index],
                  isPersonal: viewModel.calendar.type == "personal",
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 8),
            ),
          ],
        );
      },
    );
  }
}

class _PersonalMemberTile extends StatelessWidget {
  final String ownerNickname;

  const _PersonalMemberTile({required this.ownerNickname});

  @override
  Widget build(BuildContext context) {
    return CustomCalendarSettingContentBox(
      title: null,
      child: Row(
        children: [
          const CustomChatProfileImageBox(width: 24, height: 24),
          const SizedBox(width: 4),
          Text(ownerNickname),
          const Text(" 👑"),
        ],
      ),
    );
  }
}

class _SharedMemberTile extends StatelessWidget {
  final dynamic member;
  final bool isPersonal;

  const _SharedMemberTile({required this.member, required this.isPersonal});

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
          isPersonal
              ? const SizedBox.shrink()
              : member.is_admin
              ? const Text("👑")
              : const _RoleActionButton(),
        ],
      ),
    );
  }
}

class _RoleActionButton extends StatelessWidget {
  const _RoleActionButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        CustomConfirmationDialog(
          content: "방장 권한을 넘기시겠습니까?",
          confirmColor: AppColors.commonBlue,
          onConfirm: () {},
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
