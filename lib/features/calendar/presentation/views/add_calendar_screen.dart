import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/widgets/back_actions_app_bar.dart';
import 'package:dutytable/features/calendar/presentation/viewmodels/calendar_add_view_model.dart';
import 'package:dutytable/features/calendar/presentation/widgets/label_text_field.dart';
import 'package:dutytable/features/calendar/presentation/widgets/member_select_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AddCalendarScreen extends StatelessWidget {
  /// 캘린더 추가 화면
  const AddCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalendarAddViewModel(),
      child: _AddCalendarScreen(),
    );
  }
}

class _AddCalendarScreen extends StatelessWidget {
  const _AddCalendarScreen({super.key});

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarAddViewModel>(
      builder: (context, viewModel, child) {
        final isEnabled = viewModel.isValid && !viewModel.isLoading;

        return Scaffold(
          /// 앱 바
          appBar: BackActionsAppBar(
            title: Text(
              "새 캘린더",
              style: TextStyle(
                color: AppColors.text(context),
                fontSize: 20.0,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          body: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                children: [
                  const SizedBox(height: 10),

                  /// 캘린더 이미지
                  Column(
                    children: [
                      Text(
                        "캘린더 사진",
                        style: TextStyle(
                          color: AppColors.text(context),
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 8),

                      GestureDetector(
                        onTap: () async {
                          await context
                              .read<CalendarAddViewModel>()
                              .pickImage();
                        },
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: AppColors.cardBorder(context),
                              width: 2,
                            ),
                            color: AppColors.card(context),
                          ),
                          child: viewModel.imageFile != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(22),
                                  child: Image.file(
                                    viewModel.imageFile!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Center(
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    color: AppColors.commonGrey,
                                    size: 36,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "사진을 입력해주세요",
                        style: TextStyle(
                          color: AppColors.commonGreyShade400,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// 캘린더 이름
                  LabeledTextField(
                    label: "캘린더 이름",
                    hint: "캘린더 이름을 입력해주세요",
                    validator: (value) => value == null || value.trim().isEmpty
                        ? '캘린더 이름은 필수입니다'
                        : null,
                    onChanged: (value) {
                      context.read<CalendarAddViewModel>().setTitle(value);
                    },
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
                        barrierDismissible: false,
                        context: context,
                        builder: (_) =>
                            MemberSelectDialog(viewModel: viewModel),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  /// 설명
                  LabeledTextField(
                    label: "설명",
                    hint: "캘린더 설명을 입력해주세요 (선택사항)",
                    maxLines: 8,
                    onChanged: (value) {
                      context.read<CalendarAddViewModel>().setDescription(
                        value,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          /// 바텀 네비게이션 바 - 새 캘린더 저장 버튼
          bottomNavigationBar: Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                top: BorderSide(color: AppColors.commonGrey, width: 1),
              ),
            ),
            child: SafeArea(
              top: false,
              child: GestureDetector(
                onTap: isEnabled
                    ? () async {
                        if (_formKey.currentState?.validate() != true) return;

                        try {
                          await viewModel.addSharedCalendar();
                          context.pop(true);
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                      }
                    : null,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isEnabled
                        ? AppColors.commonBlue
                        : AppColors.commonGreyShade400, // 비활성 색상
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: viewModel.isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          "저장",
                          style: TextStyle(
                            color: isEnabled
                                ? AppColors.commonWhite
                                : AppColors.commonGrey,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
