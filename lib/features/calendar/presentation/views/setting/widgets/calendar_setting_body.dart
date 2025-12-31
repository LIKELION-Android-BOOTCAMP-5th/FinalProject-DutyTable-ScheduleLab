import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/widgets/custom_confirm_dialog.dart';
import 'package:dutytable/features/calendar/data/models/calendar_member_model.dart';
import 'package:dutytable/features/calendar/presentation/viewmodels/calendar_setting_view_model.dart';
import 'package:dutytable/features/calendar/presentation/views/setting/widgets/custom_calendar_setting_content_box.dart';
import 'package:dutytable/features/calendar/presentation/widgets/chat_tab.dart';
import 'package:dutytable/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'custom_calendar_image_box.dart';

class CalendarSettingBody extends StatelessWidget {
  /// 캘린더 설정 화면 - 바디
  const CalendarSettingBody({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CalendarSettingViewModel>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomCalendarImageBox(imageUrl: viewModel.calendar.imageURL),
            const SizedBox(height: 40),
            CustomCalendarSettingContentBox(
              title: Text(
                "캘린더 이름",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain(context),
                ),
              ),
              child: Text(
                viewModel.calendar.title,
                style: TextStyle(color: AppColors.textMain(context)),
              ),
            ),

            const SizedBox(height: 40),

            const _CalendarMemberList(),

            const SizedBox(height: 40),

            CustomCalendarSettingContentBox(
              title: Text(
                "캘린더 설명",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain(context),
                ),
              ),
              child: Text(
                viewModel.calendar.description ?? "",
                style: TextStyle(color: AppColors.textMain(context)),
              ),
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
            Text(
              "캘린더 멤버",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textMain(context),
              ),
            ),
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
                    profileUrl: viewModel.calendar.ownerProfileUrl,
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
  final String? profileUrl;

  /// 캘린더 설정 - 바디 : 캘린더 멤버(방장)
  const _OwnerMemberTile({required this.nickname, this.profileUrl});

  @override
  Widget build(BuildContext context) {
    return CustomCalendarSettingContentBox(
      title: null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CustomChatProfileImageBox(
                width: 24,
                height: 24,
                imageUrl: profileUrl,
              ),
              const SizedBox(width: 4),
              Text(
                nickname,
                style: TextStyle(color: AppColors.textMain(context)),
              ),
            ],
          ),
          const Text("👑", style: TextStyle(fontSize: 24)),
        ],
      ),
    );
  }
}

class _SharedMemberTile extends StatelessWidget {
  final CalendarMemberModel member;
  final String calendarType;

  /// 캘린더 설정 - 바디 : 캘린더 멤버(멤버)
  const _SharedMemberTile({required this.member, required this.calendarType});

  @override
  Widget build(BuildContext context) {
    final currentUser = supabase.auth.currentUser;
    final calendar = context.read<CalendarSettingViewModel>().calendar;
    return CustomCalendarSettingContentBox(
      title: null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CustomChatProfileImageBox(
                width: 24,
                height: 24,
                imageUrl: member.profileUrl,
              ),
              const SizedBox(width: 4),
              Text(
                member.nickname,
                style: TextStyle(color: AppColors.textMain(context)),
              ),
            ],
          ),
          calendarType == "personal"
              ? const SizedBox.shrink()
              : member.isAdmin
              ? const Text("👑", style: TextStyle(fontSize: 24))
              : calendar.userId == currentUser!.id
              ? _KickButton(member.userId)
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}

class _KickButton extends StatelessWidget {
  final String userId;

  /// 추방 버튼
  const _KickButton(this.userId);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<CalendarSettingViewModel>();
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        CustomConfirmationDialog.show(
          context,
          content: "추방하시겠습니까?",
          confirmColor: AppColors.danger(context),
          onConfirm: () async {
            await viewModel.exileMember(userId);
            viewModel.fetchCalendar();
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.danger(context)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text("추방", style: TextStyle(color: AppColors.danger(context))),
      ),
    );
  }
}
