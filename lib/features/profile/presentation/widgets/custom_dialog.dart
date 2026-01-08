import 'package:dutytable/core/configs/app_colors.dart';
import 'package:flutter/material.dart';

/// 다이얼로그
class CustomDialog extends StatelessWidget {
  /// 다이얼로그 높이
  final double height;

  /// 아이콘배경색
  final Color iconBackgroundColor;

  /// 아이콘
  final IconData icon;

  /// 아이콘 색
  final Color iconColor;

  /// 다이얼로그 이름
  final String title;

  /// 다이얼로그 설명
  final String message;

  /// 확인버튼
  final String allow;

  final void Function() onClosed;

  /// 뷰모델 호출
  final onChangeSelected;

  ///더 추가할 위젯
  Widget? announcement;

  CustomDialog(
    BuildContext context, {
    super.key,
    required this.height,
    required this.iconBackgroundColor,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.allow,
    this.onChangeSelected,
    this.announcement,
    required this.onClosed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.surface(context),
            ),
            width: 300,
            height: height,
            child: Column(
              children: [
                Padding(padding: EdgeInsets.all(13)),
                Stack(
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: iconBackgroundColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(icon, color: iconColor),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.all(5)),
                Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                Padding(padding: EdgeInsets.all(5)),
                Text(
                  message,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Padding(padding: EdgeInsets.all(5)),
                ?(announcement != null)
                    ? announcement
                    : Padding(padding: EdgeInsets.all(1)),

                Padding(padding: EdgeInsets.all(10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => onClosed(),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xFFF3F4F6),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Text(
                            "   취소   ",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    GestureDetector(
                      onTap: () => onChangeSelected(),
                      child: Container(
                        // color: Colors.red,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.red,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Text(
                            allow,
                            style: TextStyle(
                              color: AppColors.pureWhite,
                              fontSize: 12,
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
        ],
      ),
    );
  }
}
