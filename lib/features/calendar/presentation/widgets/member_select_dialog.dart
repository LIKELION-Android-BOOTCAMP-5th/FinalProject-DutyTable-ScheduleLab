// 멤버 추가 다이얼로그
import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/calendar/presentation/widgets/label_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../viewmodels/calendar_add_view_model.dart';

class MemberSelectDialog extends StatelessWidget {
  final CalendarAddViewModel viewModel;
  final TextEditingController _controller = TextEditingController();

  MemberSelectDialog({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Consumer<CalendarAddViewModel>(
        builder: (context, vm, _) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: size.width * 0.85,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// 헤더
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '닉네임 검색',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => context.pop(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// 입력 + 추가 버튼
                  Row(
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
                          await vm.addInvitedUserByNickname(_controller.text);
                          if (vm.inviteError == null) {
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
                          child: const Icon(
                            Icons.add,
                            color: AppColors.commonWhite,
                          ),
                        ),
                      ),
                    ],
                  ),

                  /// 🔴 에러 메시지 (다이얼로그 내부)
                  SizedBox(
                    height: 24,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: vm.inviteError == null
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  vm.inviteError!,
                                  key: ValueKey(vm.inviteError),
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// 초대된 멤버
                  if (vm.invitedUsers.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: vm.invitedUsers.entries
                          .map(
                            (e) => Chip(
                              label: Text(e.value),
                              onDeleted: () => vm.removeInvitedUser(e.key),
                            ),
                          )
                          .toList(),
                    ),

                  const SizedBox(height: 20),

                  /// 완료
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.pop(),
                      child: const Text('완료'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
