import 'package:dutytable/core/widgets/back_actions_app_bar.dart';
import 'package:dutytable/features/calendar/presentation/viewmodels/calendar_setting_view_model.dart';
import 'package:dutytable/features/calendar/presentation/views/setting/widgets/calendar_setting_body.dart';
import 'package:dutytable/features/calendar/presentation/views/setting/widgets/delete_button_section.dart';
import 'package:dutytable/core/widgets/custom_calendar_setting_content_box.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/configs/app_colors.dart';
import '../../../../../core/widgets/custom_confirm_dialog.dart';
import '../../../data/models/calendar_model.dart';
import '../../widgets/chat_tab.dart';

// class CalendarSettingScreen extends StatelessWidget {
//   /// 캘린더 데이터
//   final CalendarModel? calendar;
//
//   /// 캘린더 설정 화면(provider 주입)
//   const CalendarSettingScreen({super.key, this.calendar});
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       // 캘린더 설정 뷰모델 주입
//       create: (context) =>
//           // 캘린더 데이터 함께 주입
//           CalendarSettingViewModel(calendar: calendar),
//       child: _CalendarSettingScreen(),
//     );
//   }
// }
//
// class _CalendarSettingScreen extends StatelessWidget {
//   /// 캘린더 설정 화면(private)
//   const _CalendarSettingScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // 캘린더 설정 뷰모델 주입
//     return Consumer<CalendarSettingViewModel>(
//       builder: (context, viewModel, child) {
//         return Scaffold(
//           appBar: BackActionsAppBar(
//             title: Text(
//               "캘린더 설정",
//               style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w800),
//             ),
//             actions: [
//               // 리플 없는 버튼
//               GestureDetector(
//                 onTap: () {
//                   print("수정 버튼 눌림");
//                   context.push("/calendar/edit", extra: viewModel.calendar);
//                 },
//                 child: const Text(
//                   "수정",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           body: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               // 위젯 크기와 수에 따른 전체 영역 스크롤
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // 캘린더 이름
//                     CustomCalendarSettingContentBox(
//                       title: const Text(
//                         "캘린더 이름",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       child: Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(viewModel.calendar.title),
//                       ),
//                     ),
//                     const SizedBox(height: 40),
//                     // 캘린더 멤버 목록
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           "캘린더 멤버",
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(height: 8),
//                         ListView.separated(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           // 멤버 목록이 비었을 경우(개인 캘린더의 경우) 방장만 표시하기위해 1을 반환
//                           itemCount:
//                               viewModel.calendar.calendarMemberModel?.isEmpty ??
//                                   true
//                               ? 1
//                               : viewModel.calendar.calendarMemberModel!.length,
//                           itemBuilder: (context, index) {
//                             final members =
//                                 viewModel.calendar.calendarMemberModel;
//                             // 개인 캘린더일 때(멤버 목록이 없을 때)
//                             if (members == null || members.isEmpty) {
//                               return CustomCalendarSettingContentBox(
//                                 title: null,
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         const CustomChatProfileImageBox(
//                                           width: 24,
//                                           height: 24,
//                                         ),
//                                         const SizedBox(width: 4),
//                                         Text(viewModel.calendar.ownerNickname),
//                                         const Text("👑"), // 방장 표시
//                                       ],
//                                     ),
//                                     const SizedBox.shrink(),
//                                   ],
//                                 ),
//                               );
//                             }
//
//                             // 공유 캘린더일 때
//                             final member = members[index];
//                             return CustomCalendarSettingContentBox(
//                               title: null,
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       // 커스텀 프로필 이미지 박스 사용
//                                       CustomChatProfileImageBox(
//                                         width: 24,
//                                         height: 24,
//                                       ),
//                                       const SizedBox(width: 4),
//                                       // 멤버 닉네임
//                                       Text(member.nickname),
//                                     ],
//                                   ),
//                                   // 개인 캘린더는 추방 버튼 안나옴
//                                   viewModel.calendar.type == "personal"
//                                       ? SizedBox.shrink()
//                                       // 공유 캘린더는 방장만 추방 버튼 안나옴
//                                       : viewModel
//                                             .calendar
//                                             .calendarMemberModel![index]
//                                             .is_admin
//                                       // 방장 표시
//                                       ? const Text("👑")
//                                       // 추방 버튼
//                                       : GestureDetector(
//                                           // 전체 영역 터치 가능
//                                           behavior: HitTestBehavior.opaque,
//                                           onTap: () {
//                                             showCustomConfirmationDialog(
//                                               context,
//                                               content: "추방하시겠습니까?",
//                                               color: AppColors.commonRed,
//                                               onConfirm: () => print("확인"),
//                                             );
//                                             print("추방");
//                                           },
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               border: Border.all(
//                                                 color: AppColors.commonRed,
//                                               ),
//                                               borderRadius:
//                                                   BorderRadiusGeometry.circular(
//                                                     8,
//                                                   ),
//                                             ),
//                                             child: Padding(
//                                               padding: const EdgeInsets.all(
//                                                 8.0,
//                                               ),
//                                               child: Center(
//                                                 child: Text(
//                                                   "추방",
//                                                   style: TextStyle(
//                                                     color: AppColors.commonRed,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                 ],
//                               ),
//                             );
//                           },
//                           separatorBuilder: (context, index) {
//                             return const SizedBox(height: 8); // 멤버간 간격
//                           },
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 40),
//                     // 캘린더 설명
//                     CustomCalendarSettingContentBox(
//                       title: const Text(
//                         "캘린더 설명",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       child: Text(viewModel.calendar.description ?? ""),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           // 공유 캘린더만 표시
//           bottomNavigationBar: viewModel.calendar.type == "personal"
//               ? null
//               : SafeArea(
//                   child: Padding(
//                     padding: const EdgeInsets.only(
//                       bottom: 8.0,
//                       right: 8.0,
//                       left: 8.0,
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadiusGeometry.all(
//                         Radius.circular(12),
//                       ),
//                       child: GestureDetector(
//                         behavior: HitTestBehavior.opaque,
//                         onTap: () {
//                           showCustomConfirmationDialog(
//                             context,
//                             content: "캘린더를 삭제하시겠습니까?",
//                             color: AppColors.commonRed,
//                             onConfirm: () {
//                               print("확인 눌림");
//                             },
//                           );
//                         },
//                         child: BottomAppBar(
//                           color: AppColors.commonRed,
//                           height: 52,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 Icons.delete_outline,
//                                 color: AppColors.commonWhite,
//                               ),
//                               Text(
//                                 "캘린더 삭제",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: AppColors.commonWhite,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//         );
//       },
//     );
//   }
// }
class CalendarSettingScreen extends StatelessWidget {
  final CalendarModel? calendar;

  const CalendarSettingScreen({super.key, this.calendar});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalendarSettingViewModel(calendar: calendar),
      child: const _CalendarSettingScreen(),
    );
  }
}

class _CalendarSettingScreen extends StatelessWidget {
  const _CalendarSettingScreen();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CalendarSettingViewModel>();

    return Scaffold(
      appBar: BackActionsAppBar(
        title: const Text(
          "캘린더 설정",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        actions: const [_EditButton()],
      ),
      body: const CalendarSettingBody(),
      bottomNavigationBar: viewModel.calendar.type == "personal"
          ? null
          : const DeleteButtonSection(),
    );
  }
}

class _EditButton extends StatelessWidget {
  const _EditButton();

  @override
  Widget build(BuildContext context) {
    final calendar = context.read<CalendarSettingViewModel>().calendar;

    return GestureDetector(
      onTap: () {
        context.push("/calendar/edit", extra: calendar);
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          "수정",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
