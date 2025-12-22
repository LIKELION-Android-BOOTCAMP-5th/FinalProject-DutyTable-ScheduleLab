import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 일정 상세 - 반복
class RepeatSection extends StatelessWidget {
  const RepeatSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScheduleDetailViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.dBorder : AppColors.lBorder;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: IgnorePointer(
        ignoring: true,
        child: Column(
          children: [
            /// 일정 상세 - 반복 체크
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        activeColor: AppColors.primary(context),
                        checkColor: AppColors.pureWhite,
                        value: viewModel.isRepeat,
                        onChanged: (_) => viewModel.isRepeat,
                      ),

                      const SizedBox(width: 10),

                      Text(
                        "일정 반복",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textMain(context),
                        ),
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
                              initialValue: viewModel.repeatNum.toString(),
                              style: TextStyle(
                                color: AppColors.textMain(context),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (_) => viewModel.repeatNum,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.surface(context),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: borderColor,
                                    width: 2,
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: borderColor,
                                    width: 2,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: borderColor,
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: borderColor,
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
                              dropdownColor: AppColors.surface(context),
                              value: viewModel.repeatOption,
                              onChanged: (_) => viewModel.repeatOption,
                              style: TextStyle(
                                color: AppColors.textMain(context),
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.surface(context),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: borderColor,
                                    width: 2,
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: borderColor,
                                    width: 2,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: borderColor,
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: borderColor,
                                    width: 2,
                                  ),
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: "daily",
                                  child: Text("일 마다"),
                                ),
                                DropdownMenuItem(
                                  value: "weekly",
                                  child: Text("주 마다"),
                                ),
                                DropdownMenuItem(
                                  value: "monthly",
                                  child: Text("개월 마다"),
                                ),
                                DropdownMenuItem(
                                  value: "yearly",
                                  child: Text("년 마다"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            /// 일정 상세 - 반복(true) - 반복 옵션(주말, 공휴일 제외)
            if (viewModel.isRepeat)
              Column(
                children: [
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      /// 주말 제외
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(right: 12.0),
                          decoration: BoxDecoration(
                            color: AppColors.surface(context),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: borderColor),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Checkbox(
                                activeColor: AppColors.primary(context),
                                checkColor: AppColors.pureWhite,
                                value: viewModel.weekendException,
                                onChanged: (_) => viewModel.weekendException,
                              ),
                              const Text("주말 제외"),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      /// 공휴일 제외
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(right: 12.0),
                          decoration: BoxDecoration(
                            color: AppColors.surface(context),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: borderColor),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Checkbox(
                                activeColor: AppColors.primary(context),
                                checkColor: AppColors.pureWhite,
                                value: viewModel.holidayException,
                                onChanged: (_) => viewModel.holidayException,
                              ),
                              const Text("공휴일 제외"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
