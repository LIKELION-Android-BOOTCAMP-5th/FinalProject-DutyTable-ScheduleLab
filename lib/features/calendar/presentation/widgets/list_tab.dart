import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/custom_floatingactionbutton.dart';
import '../viewmodels/schedule_view_model.dart';

/// 리스트 탭(Provider 주입)
class ListTab extends StatelessWidget {
  const ListTab({super.key});

  @override
  Widget build(BuildContext context) {
    // 스케쥴 뷰모델 주입
    return ChangeNotifierProvider(
      create: (context) => ScheduleViewModel(),
      child: _ListTab(),
    );
  }
}

class _ListTab extends StatelessWidget {
  /// 리스트 탭(private)
  const _ListTab({super.key});

  @override
  Widget build(BuildContext context) {
    // 스케쥴 뷰모델 주입
    return Consumer<ScheduleViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      spacing: 8,
                      children: [
                        // 커스텀 드롭다운 버튼 사용
                        CustomDropdownButton(
                          // 기본 선택 값
                          defaultValue: viewModel.selectedFilterYears,
                          // 눌렀을 떄 나오는 아이템들
                          items: viewModel.filterYears
                              .map<DropdownMenuItem<int>>((int year) {
                                return DropdownMenuItem<int>(
                                  value: year,
                                  child: Text("${year.toString()}년"),
                                );
                              })
                              .toList(),
                          // 아이템 눌렀을 떄 실행 할 함수
                          onChanged: (dynamic newValue) {
                            viewModel.selectedYear(newValue ?? 0);
                            print('선택된 연도: $newValue');
                          },
                        ),
                        // 커스텀 드롭다운 버튼 사용
                        CustomDropdownButton(
                          // 기본 선택 값
                          defaultValue: viewModel.selectedFilterMonth,
                          // 눌렀을 떄 나오는 아이템들
                          items: viewModel.filterMonths
                              .map<DropdownMenuItem<int>>((int month) {
                                return DropdownMenuItem<int>(
                                  value: month,
                                  child: Text("${month.toString()}월"),
                                );
                              })
                              .toList(),
                          // 아이템 눌렀을 떄 실행 할 함수
                          onChanged: (dynamic newValue) {
                            viewModel.selectedYear(newValue ?? 0);
                            print('선택된 월: $newValue');
                          },
                        ),
                        // 커스텀 드롭다운 버튼 사용
                        CustomDropdownButton(
                          // 기본 선택 값
                          defaultValue: viewModel.selectedFilterColor,
                          // 눌렀을 떄 나오는 아이템들
                          items: viewModel.filterColors
                              .map<DropdownMenuItem<String>>((String color) {
                                return DropdownMenuItem<String>(
                                  value: color,
                                  child: Text("${color.toString()}"),
                                );
                              })
                              .toList(),
                          // 아이템 눌렀을 떄 실행 할 함수
                          onChanged: (dynamic newValue) {
                            viewModel.selectedYear(newValue ?? 0);
                            print('선택된 연도: $newValue');
                          },
                        ),
                      ],
                    ),
                    // 리플 없는 버튼
                    GestureDetector(
                      onTap: () {
                        print("선택삭제 눌림");
                      },
                      child: Text(
                        "선택삭제",
                        style: TextStyle(color: Color(0xFF3C82F6)),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 8.0,
                  ),
                  child: ListView.separated(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return CustomScheduleCard();
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 12.0);
                    },
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: CustomFloatingActionButton(),
        );
      },
    );
  }
}

class CustomDropdownButton extends StatelessWidget {
  /// 기본 선택 값
  final dynamic defaultValue;

  /// 눌렀을 떄 나오는 아이템들
  final List<DropdownMenuItem<dynamic>> items;

  /// 아이템 눌렀을 떄 실행 할 함수
  final void Function(dynamic) onChanged;

  /// 커스텀 드롭다운 버튼
  const CustomDropdownButton({
    super.key,
    this.defaultValue,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: DropdownButton(
        value: defaultValue,
        items: items,
        onChanged: onChanged,
        underline: const SizedBox.shrink(), // 기본 밑줄 제거
        icon: const Icon(
          Icons.keyboard_arrow_down,
          size: 18,
          color: Color(0xFF6B7280),
        ), // 아이콘 커스텀
        isDense: true,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class CustomScheduleCard extends StatelessWidget {
  /// 커스텀 일정 카드 UI
  const CustomScheduleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: BoxBorder.all(width: 2, color: Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.maxFinite,
          height: 52,
          child: Row(
            spacing: 8,
            children: [
              Container(
                width: 6,
                height: double.maxFinite,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              Text("😎", style: TextStyle(fontSize: 28)),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("운동", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      "2025년 12월 4일 · 09:00 ~ 18:00",
                      style: TextStyle(
                        color: Colors.grey,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
