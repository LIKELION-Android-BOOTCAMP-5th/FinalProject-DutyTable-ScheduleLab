import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/widgets/back_actions_app_bar.dart';
import 'package:dutytable/extensions.dart';
import 'package:dutytable/features/schedule/models/schedule_model.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_detail_view_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'address_search_bottom_sheet.dart';

/// TODO
/// 일정 상세 UI 추가
/// 지도 API 연동하여 주소가 있을 시 지도와 마커 추가
class ScheduleDetailScreen extends StatelessWidget {
  final ScheduleModel scheduleDetail;
  final bool isAdmin;

  const ScheduleDetailScreen({
    super.key,
    required this.scheduleDetail,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ScheduleDetailViewModel(
        scheduleDetail: scheduleDetail,
        isAdmin: isAdmin,
      ),
      child: _ScheduleDetailScreen(),
    );
  }
}

class _ScheduleDetailScreen extends StatelessWidget {
  const _ScheduleDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScheduleDetailViewModel>();

    return Scaffold(
      appBar: BackActionsAppBar(title: Text(viewModel.title)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<ScheduleDetailViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                children: [
                  const SizedBox(height: 16),

                  /// 일정 상세 - 감정 및 색
                  _EmotionColorSection(),

                  const SizedBox(height: 12),

                  const Divider(),

                  const SizedBox(height: 12),

                  /// 일정 상세 - 일정 날짜 및 시간
                  _ScheduleDateTime(),

                  const SizedBox(height: 12),

                  const Divider(),

                  const SizedBox(height: 10),

                  /// 일정 상세 - 완료 여부
                  _SuccessStatusSection(),

                  const SizedBox(height: 10),

                  const Divider(),

                  const SizedBox(height: 8),

                  /// 일정 상세 - 지도(위치 및 마커)
                  _MapSection(),

                  const SizedBox(height: 8),

                  const Divider(),

                  const SizedBox(height: 10),

                  /// 일정 상세 - 반복
                  _RepeatSection(),

                  const SizedBox(height: 10),

                  const Divider(),

                  const SizedBox(height: 10),

                  /// 일정 상세 - 메모
                  _MemoSection(),

                  const SizedBox(height: 10),

                  const Divider(),

                  const SizedBox(height: 10),

                  /// 일정 상세 바텀 버튼 - 편집, 공유, 삭제
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        /// 편집 버튼
                        if (viewModel.isAdmin)
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
                        if (viewModel.isAdmin)
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => Dialog(
                                    backgroundColor: AppColors.background(
                                      context,
                                    ),
                                    insetPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 24,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "일정을 삭제하시겠습니까?",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),

                                          const SizedBox(height: 14),

                                          Row(
                                            children: [
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () => context.pop(),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Color(0xfff3f4f6),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                    alignment: Alignment.center,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          vertical: 10,
                                                        ),
                                                    child: const Text(
                                                      "취소",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              const SizedBox(width: 10),

                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    await viewModel
                                                        .deleteSchedules(
                                                          viewModel.scheduleId,
                                                        );
                                                    context.pop();
                                                    context.pop(true);
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Color(0xffef4444),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                    alignment: Alignment.center,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          vertical: 10,
                                                        ),
                                                    child: const Text(
                                                      "확인",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
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

/// 일정 상세 - 감정 및 색
class _EmotionColorSection extends StatelessWidget {
  const _EmotionColorSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScheduleDetailViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(viewModel.emotionTag ?? "", style: TextStyle(fontSize: 26)),

          const SizedBox(width: 16),

          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Color(int.parse(viewModel.colorValue)),
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

/// 일정 상세 - 일정 날짜 및 시간
class _ScheduleDateTime extends StatelessWidget {
  const _ScheduleDateTime({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScheduleDetailViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Text("🕒", style: TextStyle(fontSize: 20)),

          const SizedBox(width: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 일정 날짜 - 시작일 ~ 종료일
              Row(
                children: [
                  Text(
                    viewModel.startedAt
                        .toString()
                        .toDateTime()
                        .koreanShortDateWithWeekday,
                    style: TextStyle(
                      color: AppColors.text(context),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    "~",
                    style: TextStyle(
                      color: AppColors.text(context),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    viewModel.endedAt
                        .toString()
                        .toDateTime()
                        .koreanShortDateWithWeekday,
                    style: TextStyle(
                      color: AppColors.text(context),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),

              /// 일정 날짜 - 시작일 ~ 종료일
              Row(
                children: [
                  Text(
                    viewModel.startedAt.toString().toDateTime().koreanAmPmTime,
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
                    viewModel.endedAt.toString().toDateTime().koreanAmPmTime,
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
    );
  }
}

/// 일정 상세 - 완료 여부
class _SuccessStatusSection extends StatelessWidget {
  const _SuccessStatusSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScheduleDetailViewModel>();

    return Padding(
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
    );
  }
}

/// 일정 상세 - 지도(위치 및 마커)
class _MapSection extends StatelessWidget {
  const _MapSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScheduleDetailViewModel>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: viewModel.address != null
          ? Column(
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
                            text: "주소 검색",
                            style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                final selected = await showAddressSearchSheet(
                                  context,
                                );

                                if (selected == null) return;

                                final geo = await viewModel.geocodeAddress(
                                  selected.address,
                                );
                                if (geo == null) return;

                                viewModel.setAddress(
                                  address: selected.address,
                                  latitude: geo['latitude']!.toString(),
                                  longitude: geo['longitude']!.toString(),
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
                const SizedBox(width: 400, height: 400, child: _NaverMap()),
              ],
            )
          : Row(
              children: [
                Icon(Icons.location_pin),

                const SizedBox(width: 10),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("일정 장소가 없습니다"),

                    const SizedBox(height: 10),

                    RichText(
                      text: TextSpan(
                        text: "주소 검색",
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            final selected = await showAddressSearchSheet(
                              context,
                            );

                            if (selected == null) return;

                            final geo = await viewModel.geocodeAddress(
                              selected.address,
                            );
                            if (geo == null) return;

                            viewModel.setAddress(
                              address: selected.address,
                              latitude: geo['latitude']!.toString(),
                              longitude: geo['longitude']!.toString(),
                            );
                          },
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

class _NaverMap extends StatelessWidget {
  const _NaverMap({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScheduleDetailViewModel>();

    if (viewModel.latitude == null || viewModel.longitude == null) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text("위치 정보 없음")),
      );
    }

    final target = NLatLng(
      double.parse(viewModel.latitude!),
      double.parse(viewModel.longitude!),
    );

    return SizedBox(
      height: 300,
      child: NaverMap(
        options: NaverMapViewOptions(
          initialCameraPosition: NCameraPosition(target: target, zoom: 15),
        ),
        onMapReady: (controller) {
          controller.clearOverlays();
          controller.addOverlay(
            NMarker(id: "schedule_location", position: target),
          );
        },
      ),
    );
  }
}

/// 일정 상세 - 반복
class _RepeatSection extends StatelessWidget {
  const _RepeatSection({super.key});

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

/// 일정 상세 - 메모
class _MemoSection extends StatelessWidget {
  const _MemoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScheduleDetailViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "메모",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),

          const SizedBox(height: 10),

          TextFormField(
            initialValue: viewModel.memo,
            maxLength: 300,
            maxLines: 4,
            enabled: false,
            onChanged: (value) => viewModel.memo = value,
            decoration: InputDecoration(
              hintText: "메모를 입력하세요 (최대 300자)",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
