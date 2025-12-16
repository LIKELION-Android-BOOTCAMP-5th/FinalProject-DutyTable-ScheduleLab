import 'package:dutytable/features/calendar/presentation/viewmodels/calendar_add_view_model.dart';
import 'package:dutytable/features/calendar/presentation/views/add/widgets/calendar_image_section.dart';
import 'package:dutytable/features/calendar/presentation/widgets/label_text_field.dart';
import 'package:dutytable/features/calendar/presentation/widgets/member_select_dialog/member_select_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalendarAddBody extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  /// 캘린더 추가 바디
  const CalendarAddBody({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CalendarAddViewModel>();

    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          const SizedBox(height: 10),

          /// 캘린더 이미지
          CalendarImageSection(),

          const SizedBox(height: 12),

          /// 캘린더 이름
          LabeledTextField(
            label: "캘린더 이름",
            hint: "캘린더 이름을 입력해주세요",
            validator: (value) =>
                value == null || value.trim().isEmpty ? '캘린더 이름은 필수입니다' : null,
            onChanged: viewModel.setTitle,
          ),

          const SizedBox(height: 12),

          /// 멤버 추가
          LabeledTextField(
            label: "멤버 추가",
            hint: viewModel.invitedUsers.isEmpty
                ? "닉네임으로 검색하기"
                : viewModel.invitedUsers.values.join(', '),
            readOnly: true,
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => MemberSelectDialog(viewModel: viewModel),
              );
            },
          ),

          const SizedBox(height: 12),

          /// 캘린더 설명
          LabeledTextField(
            label: "설명",
            hint: "캘린더 설명을 입력해주세요 (선택사항)",
            maxLines: 8,
            onChanged: viewModel.setDescription,
          ),
        ],
      ),
    );
  }
}
