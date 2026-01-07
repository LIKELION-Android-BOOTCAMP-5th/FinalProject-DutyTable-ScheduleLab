import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/calendar/presentation/viewmodels/calendar_edit_view_model.dart';
import 'package:dutytable/features/calendar/presentation/views/edit/widgets/custom_calendar_edit_text_field.dart';
import 'package:dutytable/features/calendar/presentation/views/setting/widgets/custom_calendar_setting_content_box.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/utils/image_picker_utils.dart';
import '../../../../../../core/widgets/custom_confirm_dialog.dart';
import '../../../../data/models/calendar_member_model.dart';
import '../../../widgets/chat_tab.dart';
import '../../setting/widgets/custom_calendar_image_box.dart';

class CalendarEditBody extends StatelessWidget {
  const CalendarEditBody({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CalendarEditViewModel>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  ImagePickerUtils.showImagePicker(
                    context: context,
                    onImageSelected: (source) =>
                        viewModel.pickCalendarImage(source),
                    onDelete: viewModel.deleteImage,
                  );
                },
                child: CustomCalendarImageBox(
                  imageUrl: viewModel.newImage != null
                      ? viewModel.newImage!.path
                      : viewModel.calendar.imageURL,
                ),
              ),
              const SizedBox(height: 40),

              /// 캘린더 이름
              CustomCalendarEditTextField(
                title: Text(
                  "캘린더 이름",
                  style: TextStyle(
                    color: AppColors.textMain(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                controller: viewModel.titleController,
                maxLength: 20,
                maxLines: 1,
              ),

              const SizedBox(height: 40),

              /// 멤버 섹션
              const _CalendarMemberSection(),

              const SizedBox(height: 40),

              /// 캘린더 설명
              CustomCalendarEditTextField(
                title: Text(
                  "캘린더 설명",
                  style: TextStyle(
                    color: AppColors.textMain(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                controller: viewModel.descController,
                maxLength: 500,
                maxLines: null,
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
      children: [
        Text(
          "캘린더 멤버",
          style: TextStyle(
            color: AppColors.textMain(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
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
                profileUrl: viewModel.calendar.ownerProfileUrl,
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
  final String? profileUrl;

  const _PersonalOwnerTile({required this.nickname, this.profileUrl});

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
          isPersonalCalendar
              ? const SizedBox.shrink()
              : member.isAdmin
              ? const Text("👑", style: TextStyle(fontSize: 24))
              : _RoleButton(member.userId),
        ],
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  final String newAdminId;
  const _RoleButton(this.newAdminId);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<CalendarEditViewModel>();
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        CustomConfirmationDialog.show(
          context,
          content: "방장 권한을 넘기시겠습니까?",
          confirmColor: AppColors.primaryBlue,
          onConfirm: () async {
            await viewModel.transferAdminRole(newAdminId);

            if (!context.mounted) return;

            context.pop();
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryBlue),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text("권한", style: TextStyle(color: AppColors.primaryBlue)),
      ),
    );
  }
}
