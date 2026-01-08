import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/widgets/back_actions_app_bar.dart';
import 'package:dutytable/features/calendar/data/models/calendar_model.dart';
import 'package:dutytable/features/calendar/presentation/viewmodels/calendar_edit_view_model.dart';
import 'package:dutytable/features/calendar/presentation/views/edit/widgets/calendar_edit_body.dart';
import 'package:dutytable/features/calendar/presentation/views/edit/widgets/edit_button_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalendarEditScreen extends StatelessWidget {
  /// 캘린더 데이터
  final CalendarModel? calendar;

  /// 캘린더 수정 화면(provider 주입)
  const CalendarEditScreen({super.key, this.calendar});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // 캘린더 수정 뷰모델 주입
      create: (context) =>
          // 캘린더 데이터 함께 주입
          CalendarEditViewModel(initialCalendarData: calendar),
      child: _CalendarEditScreen(),
    );
  }
}

class _CalendarEditScreen extends StatelessWidget {
  /// 캘린더 수정 화면(private)
  const _CalendarEditScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CalendarEditViewModel>();
    Widget bodyContent;

    switch (viewModel.state) {
      case ViewState.loading:
        // 데이터 로드 중일 때 로딩 인디케이터 표시
        bodyContent = Center(
          child: CircularProgressIndicator(
            color: AppColors.primary(context),
            strokeWidth: 2,
          ),
        );
        break;

      case ViewState.error:
        // 오류 발생 시 에러 메시지 표시
        bodyContent = Center(
          child: Text(
            "데이터 로드 실패: ${viewModel.errorMessage ?? '알 수 없는 오류'}",
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.pureDanger),
          ),
        );
        break;

      case ViewState.success:
        bodyContent = CalendarEditBody();
        break;
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.background(context),
        appBar: BackActionsAppBar(
          title: Text(
            "캘린더 수정",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w800),
          ),
        ),
        body: bodyContent,
        bottomNavigationBar: EditButtonSection(),
      ),
    );
  }
}
