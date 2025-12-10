import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/widgets/back_actions_app_bar.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_detail_view_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

/// TODO
/// 일정 상세 UI 추가
/// 지도 API 연동하여 주소가 있을 시 지도와 마커 추가
class ScheduleDetailScreen extends StatelessWidget {
  const ScheduleDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ScheduleDetailViewModeol(),
      child: _ScheduleDetailScreen(),
    );
  }
}

class _ScheduleDetailScreen extends StatelessWidget {
  const _ScheduleDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackActionsAppBar(title: Text("병원예약")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<ScheduleDetailViewModeol>(
            builder: (context, viewModel, child) {
              return Column(
                children: [
                  const SizedBox(height: 16),

                  /// 일정 상세 - 감정 및 색
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("😢", style: TextStyle(fontSize: 26)),

                        const SizedBox(width: 16),

                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Color(0xFFFF3B30),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Divider(),

                  const SizedBox(height: 12),

                  /// 일정 상제 - 일정 날짜 및 시간
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Text("🕒", style: TextStyle(fontSize: 20)),

                        const SizedBox(width: 12),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "11월 8일 (수)",
                              style: TextStyle(
                                color: AppColors.text(context),
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "7:00 AM",
                                  style: TextStyle(
                                    color: AppColors.commonGrey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                Icon(
                                  Icons.arrow_right_alt_rounded,
                                  size: 30,
                                  color: AppColors.commonGrey,
                                ),

                                Text(
                                  "8:00 AM",
                                  style: TextStyle(
                                    color: AppColors.commonGrey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Divider(),

                  const SizedBox(height: 10),

                  /// 일정 상세 - 완료 여부
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "완료",
                          style: TextStyle(
                            color: AppColors.text(context),
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Switch(
                          value: viewModel.isDone,
                          onChanged: (value) => viewModel.isDone = value,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Divider(),

                  const SizedBox(height: 8),

                  /// 일정 상세 - 지도(위치 및 마커)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        /// 지도 - 위치, 길찾기 텍스트 링크
                        Row(
                          children: [
                            Icon(Icons.location_pin),

                            const SizedBox(width: 10),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("대한민국 서울특별시 광화문역"),

                                const SizedBox(height: 10),

                                RichText(
                                  text: TextSpan(
                                    text: "길찾기",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        launchUrl(
                                          Uri.parse(
                                            "https://example.com/terms",
                                          ),
                                        );
                                      },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        /// 지도 API 이미지 연동 필요
                        const Placeholder(fallbackHeight: 300),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Divider(),

                  const SizedBox(height: 10),

                  /// 일정 상세 - 반복
                  Padding(
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
                                    onChanged: (value) =>
                                        viewModel.isRepeat = value ?? false,
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
                                opacity: viewModel.isRepeat
                                    ? 1.0
                                    : 0.4, // 비활성 시 흐릿하게
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
                                          initialValue: viewModel.repeatCount
                                              .toString(),
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) =>
                                              viewModel.repeatCount =
                                                  int.tryParse(value) ?? 1,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: AppColors.card(context),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  vertical: 12,
                                                ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: AppColors.commonGrey,
                                                width: 2,
                                              ),
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: AppColors.commonGrey,
                                                width: 2,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: AppColors.commonGrey,
                                                width: 2,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                              ? (value) =>
                                                    viewModel.repeatType =
                                                        value!
                                              : null, // disabled when repeat off
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: AppColors.card(context),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 12,
                                                ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: AppColors.commonGrey,
                                                width: 2,
                                              ),
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: AppColors.commonGrey,
                                                width: 2,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: AppColors.commonGrey,
                                                width: 2,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
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

                        const SizedBox(height: 10),

                        /// 일정 상세 - 반복(true) - 반복 옵션(주말, 공휴일 제외)
                        if (viewModel.isRepeat)
                          Column(
                            children: [
                              Row(
                                children: [
                                  /// 주말 제외
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                        right: 12.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.card(context),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: AppColors.commonGrey,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Checkbox(
                                            value: viewModel.excludeWeekend,
                                            onChanged: (value) =>
                                                viewModel.excludeWeekend =
                                                    value ?? false,
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
                                      padding: const EdgeInsets.only(
                                        right: 12.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.card(context),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: AppColors.commonGrey,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Checkbox(
                                            value: viewModel.excludeHoliday,
                                            onChanged: (value) =>
                                                viewModel.excludeHoliday =
                                                    value ?? false,
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

                  const SizedBox(height: 10),

                  const Divider(),

                  const SizedBox(height: 10),

                  /// 일정 상세 - 메모
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "메모",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 10),

                        TextFormField(
                          maxLength: 300,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: "메모를 입력하세요 (최대 300자)",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: AppColors.cardBorder(context),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Divider(),

                  const SizedBox(height: 10),

                  /// 일정 상세 바텀 버튼 - 편집, 공유, 삭제
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        /// 편집 버튼
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              print("편집");
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.background(context),
                                border: Border.all(
                                  color: AppColors.commonGrey,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.edit_note),

                                  const SizedBox(width: 6),

                                  Text(
                                    "편집",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        /// 공유 버튼
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              print("공유");
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.background(context),
                                border: Border.all(
                                  color: AppColors.commonBlue,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.share,
                                    color: AppColors.commonBlue,
                                  ),

                                  const SizedBox(width: 6),

                                  Text(
                                    "공유",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.commonBlue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        /// 삭제 버튼
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              print("삭제");
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.background(context),
                                border: Border.all(
                                  color: AppColors.commonRed,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: AppColors.commonRed,
                                  ),

                                  const SizedBox(width: 6),

                                  Text(
                                    "삭제",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.commonRed,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
