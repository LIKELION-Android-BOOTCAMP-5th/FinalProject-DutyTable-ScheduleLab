import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/configs/app_colors.dart';

class ChatAiInfo extends StatelessWidget {
  const ChatAiInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.surface(context),
        ),
        width: 300,
        height: 270,
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 25, left: 20),
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Container(
                              width: 100,
                              height: 23,
                              decoration: BoxDecoration(
                                color: AppColors.aiInfo(context),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                width: double.infinity,
                                child: Text(
                                  "• AI 일정 인식",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textBlue(context),
                                  ),
                                ),
                                alignment: Alignment.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(top: 25, right: 20.0),
                      child: GestureDetector(
                        onTap: () => context.pop(context),
                        child: Icon(
                          Icons.close,
                          color: AppColors.dialogCloseIcon(context),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.all(8)),
                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      "채팅으로 일정 추가",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.textMain(context),
                      ),
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                ),
              ],
            ),
            Padding(padding: EdgeInsets.all(10)),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                width: double.infinity,
                child: Text(
                  "날짜, 시간, 장소를 채팅으로 입력하면 AI가\n자동으로 일정을 입력해요!",
                  style: TextStyle(color: AppColors.textSub(context)),
                ),
                alignment: Alignment.centerLeft,
              ),
            ),
            Padding(padding: EdgeInsets.all(11)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Stack(
                children: [
                  Container(
                    width: 300,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.aiInfo(context),
                      border: Border.all(
                        color: AppColors.aiInfoBorder(context),
                        width: 2.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text("💡", style: TextStyle(fontSize: 20)),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "\"3월 1일 오전 10시 용산역 친구 약속\"",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textBlue(context),
                                ),
                              ),
                              Text(
                                "이렇게 입력하면 바로 인식해요",
                                style: TextStyle(
                                  color: AppColors.textSub(context),
                                  fontSize: 13,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
