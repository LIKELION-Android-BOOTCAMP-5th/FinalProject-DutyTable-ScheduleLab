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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                      activeColor: AppColors.commonBlue,
                      value: viewModel.isRepeat,
                      onChanged: (value) => viewModel.isRepeat = value ?? false,
                    ),

                    const SizedBox(width: 10),

                    const Text(
                      "일정 반복",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
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
                            initialValue: viewModel.repeatCount.toString(),
                            keyboardType: TextInputType.number,
                            onChanged: (value) => viewModel.repeatCount =
                                int.tryParse(value) ?? 1,
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
                            value: viewModel.repeatOption,
                            onChanged: viewModel.isRepeat
                                ? (value) => viewModel.repeatOption = value!
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
                              DropdownMenuItem(
                                value: "day",
                                child: Text("일 마다"),
                              ),
                              DropdownMenuItem(
                                value: "week",
                                child: Text("주 마다"),
                              ),
                              DropdownMenuItem(
                                value: "month",
                                child: Text("개월 마다"),
                              ),
                              DropdownMenuItem(
                                value: "year",
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
                          color: AppColors.card(context),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.commonGrey),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: viewModel.weekendException,
                              onChanged: (value) =>
                                  viewModel.weekendException = value ?? false,
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
                          color: AppColors.card(context),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.commonGrey),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: viewModel.holidayException,
                              onChanged: (value) =>
                                  viewModel.holidayException = value ?? false,
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
    );
  }
}
