import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/widgets/custom_confirm_dialog.dart';
import 'package:dutytable/features/calendar/presentation/viewmodels/calendar_setting_view_model.dart';
import 'package:dutytable/features/calendar/presentation/widgets/chat_tab.dart';
import 'package:dutytable/core/widgets/custom_calendar_setting_content_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalendarSettingBody extends StatelessWidget {
  /// 캘린더 설정 화면 - 바디
  const CalendarSettingBody({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<CalendarSettingViewModel>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCalendarSettingContentBox(
              title: const Text(
                "캘린더 이름",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              child: Text(viewModel.calendar.title),
            ),

            const SizedBox(height: 40),

            const _CalendarMemberList(),

            const SizedBox(height: 40),

            CustomCalendarSettingContentBox(
              title: const Text(
                "캘린더 설명",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              child: Text(viewModel.calendar.description ?? ""),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarMemberList extends StatelessWidget {
  /// 캘린더 설정 - 바디 : 캘린더 멤버 리스트
  const _CalendarMemberList();

  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarSettingViewModel>(
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
                  return _OwnerMemberTile(
                    nickname: viewModel.calendar.ownerNickname,
                  );
                }

                return _SharedMemberTile(
                  member: members[index],
                  calendarType: viewModel.calendar.type,
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

class _OwnerMemberTile extends StatelessWidget {
  final String nickname;

  /// 캘린더 설정 - 바디 : 캘린더 멤버(방장)
  const _OwnerMemberTile({required this.nickname});

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
  final String calendarType;

  /// 캘린더 설정 - 바디 : 캘린더 멤버(멤버)
  const _SharedMemberTile({required this.member, required this.calendarType});

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
          calendarType == "personal"
              ? const SizedBox.shrink()
              : member.is_admin
              ? const Text("👑")
              : const _KickButton(),
        ],
      ),
    );
  }
}

class _KickButton extends StatelessWidget {
  /// 추방 버튼
  const _KickButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        CustomConfirmationDialog(
          content: "추방하시겠습니까?",
          confirmColor: AppColors.commonRed,
          onConfirm: () {},
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.commonRed),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text("추방", style: TextStyle(color: AppColors.commonRed)),
      ),
    );
  }
}
