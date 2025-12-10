import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_add_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RepeatSection extends StatelessWidget {
  /// 일정 반복 - 선택 사항(기본 값 - false, 체크 박스)
  const RepeatSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScheduleAddViewModel>();

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                activeColor: AppColors.commonBlue,
                value: viewModel.isRepeat,
                onChanged: (value) => viewModel.isRepeat = value ?? false,
              ),

              const SizedBox(width: 10),

              const Text(
                "일정 반복",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          flex: 3,
          child: Opacity(
            opacity: viewModel.isRepeat ? 1.0 : 0.4, // 비활성 시 흐릿하게
            child: IgnorePointer(
              ignoring: !viewModel.isRepeat, // 클릭 막기
              child: Row(
                children: [
                  /// 숫자 입력 필드
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      enabled: viewModel.isRepeat, // 활성/비활성
                      textAlign: TextAlign.center,
                      initialValue: viewModel.repeatCount.toString(),
                      keyboardType: TextInputType.number,
                      onChanged: (value) =>
                          viewModel.repeatCount = int.tryParse(value) ?? 1,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.card(context),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppColors.commonGrey,
                            width: 2,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppColors.commonGrey,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppColors.commonGrey,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppColors.commonGrey,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// 드롭다운
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      value: viewModel.repeatType,
                      onChanged: viewModel.isRepeat
                          ? (value) => viewModel.repeatType = value!
                          : null, // disabled when repeat off
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.card(context),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppColors.commonGrey,
                            width: 2,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppColors.commonGrey,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppColors.commonGrey,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppColors.commonGrey,
                            width: 2,
                          ),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: "day", child: Text("일 마다")),
                        DropdownMenuItem(value: "week", child: Text("주 마다")),
                        DropdownMenuItem(value: "month", child: Text("개월 마다")),
                        DropdownMenuItem(value: "year", child: Text("년 마다")),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
