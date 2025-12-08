import 'package:flutter/material.dart';

// ///프로필스크린에 있는 각 설정 항목
class CustomTab extends StatelessWidget {
  /// 항목에 들어갈 아이콘
  final icon;

  /// 항목에 들어갈 텍스트
  final buttonText;

  /// 항목 텍스트 가운데 정렬
  final padding;

  ///더 추가할 위젯
  Widget? addWidget;

  CustomTab({
    super.key,
    this.icon,
    this.buttonText,
    this.padding,
    this.addWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(padding: EdgeInsets.only(left: 20)),
        Expanded(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color(0xFFE5E7EB)),
                ),
                child: SizedBox(height: 50),
              ),
              Column(
                children: [
                  Padding(padding: EdgeInsets.all(padding)),
                  Row(
                    children: [
                      Padding(padding: EdgeInsets.all(7)),
                      Icon(icon, size: 25),
                      Text(
                        buttonText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      ?(addWidget == null) ? Container() : addWidget,
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(padding: EdgeInsets.only(left: 20)),
      ],
    );
  }
}
