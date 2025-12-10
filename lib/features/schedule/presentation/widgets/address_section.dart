import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_add_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressSection extends StatelessWidget {
  /// 주소 - 선택 사항
  /// 주소입력 버튼 클릭 - 주소, 이미지 없을 때
  /// 주소 입력 후 완료 하면 버튼 UI 바뀜(주소랑 + 지도 이미지)
  /// 다시 누르면 다시 주소입력 화면으로 이동
  /// 주소 + 지도 이미지 - 주소, 이미지 있을 때
  /// X버튼으로 지우면 원래 버튼 UI로 복귀
  const AddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ScheduleAddViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "주소",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "주소를 입력해주세요",
                  hintStyle: TextStyle(
                    color: AppColors.commonGrey,
                    fontWeight: FontWeight.w600,
                  ),
                  filled: true,
                  fillColor: AppColors.card(context),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.cardBorder(context),
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.cardBorder(context),
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  color: AppColors.commonBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.location_pin, color: AppColors.commonWhite),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
