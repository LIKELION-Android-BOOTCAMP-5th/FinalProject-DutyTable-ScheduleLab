import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 다이얼로그
class CustomDialog extends StatelessWidget {
  /// 다이얼로그 높이
  final height;

  /// 아이콘배경색
  final iconBackgroundColor;

  /// 아이콘
  final icon;

  /// 아이콘 색
  final iconColor;

  /// 다이얼로그 이름
  final title;

  /// 다이얼로그 설명
  final message;

  /// 확인버튼
  final allow;

  /// 뷰모델 호출
  final viewmodel;

  /// 버튼 선택 시 경로
  final goto;

  ///더 추가할 위젯
  Widget? announcement;

  CustomDialog(
    BuildContext context, {
    super.key,
    this.height,
    this.iconBackgroundColor,
    this.icon,
    this.iconColor,
    this.title,
    this.message,
    this.allow,
    this.viewmodel,
    this.goto,
    this.announcement,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
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
                    ElevatedButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: Text("   취소   ", style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF3F4F6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    ElevatedButton(
                      onPressed: () {
                        viewmodel;
                        context.pop();
                        context.push(goto);
                      },
                      child: Text(
                        allow,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
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
