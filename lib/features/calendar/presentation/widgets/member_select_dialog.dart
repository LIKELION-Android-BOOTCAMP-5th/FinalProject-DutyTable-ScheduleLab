// 멤버 추가 다이얼로그
import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/calendar/presentation/widgets/label_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MemberSelectDialog extends StatelessWidget {
  /// 멤버 추가 다이얼로그
  const MemberSelectDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: Material(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: size.width * 0.85,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: AppColors.card(context),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 제목 + 닫기 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "닉네임 검색",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: const Icon(Icons.close, size: 20),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // 검색 입력
              LabeledTextField(label: "닉네임 검색", hint: "닉네임을 검색해주세요"),

              const SizedBox(height: 16),

              // 초대한 멤버 리스트
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.separated(
                  itemCount: 5,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    thickness: 0.5,
                    color: AppColors.commonGreyShade400,
                  ),
                  itemBuilder: (context, index) {
                    final name = "테스트${index + 1}";
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 4,
                      ),
                      child: Text(name, style: const TextStyle(fontSize: 15)),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // 완료 버튼
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.commonBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "완료",
                    style: TextStyle(
                      color: AppColors.commonWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
