import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/calendar/presentation/viewmodels/calendar_add_view_model.dart';
import 'package:dutytable/features/calendar/presentation/widgets/label_text_field.dart';
import 'package:flutter/material.dart';

class DialogBody extends StatelessWidget {
  final CalendarAddViewModel viewModel;
  final TextEditingController _controller = TextEditingController();

  DialogBody({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: LabeledTextField(
            label: '닉네임',
            hint: '닉네임을 입력해주세요',
            controller: _controller,
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () async {
            await viewModel.addInvitedUserByNickname(_controller.text);
            if (viewModel.inviteError == null) {
              _controller.clear();
            }
          },
          child: Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              color: AppColors.commonBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.add, color: AppColors.commonWhite),
          ),
        ),
      ],
    );
  }
}
