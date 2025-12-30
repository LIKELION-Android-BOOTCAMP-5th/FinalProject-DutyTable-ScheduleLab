import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/profile/presentation/viewmodels/profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserProfileSection extends StatelessWidget {
  const UserProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewmodel>();

    return Column(
      children: [
        // 프로필 섹션
        Row(
          children: [
            const Padding(padding: EdgeInsets.only(left: 10)),
            Stack(
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: (viewModel.image == null || viewModel.image!.isEmpty)
                      ? Icon(
                          Icons.account_circle,
                          size: 60,
                          color: AppColors.iconSub(context),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            viewModel.image!,
                            width: double.infinity,
                            height: 350,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                if (viewModel.is_edit)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () async {
                        await viewModel.getImage(ImageSource.gallery);
                        await viewModel.upload();
                      },
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: AppColors.primary(context),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          size: 14,
                          color: AppColors.pureWhite,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(left: 10)),
            if (viewModel.is_edit)
              Expanded(
                child: TextField(
                  controller: viewModel.nicknameController,
                  style: TextStyle(color: AppColors.textMain(context)),
                  decoration: InputDecoration(
                    hintText: "닉네임을 입력해주세요",
                    hintStyle: TextStyle(color: AppColors.textSub(context)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.lBorder),
                    ),
                  ),
                ),
              )
            else
              Text(
                viewModel.nickname,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain(context),
                ),
              ),
            if (viewModel.is_edit)
              TextButton(
                onPressed: () => viewModel.nicknameOverlapping(),
                child: const Text("중복체크"),
              )
            else
              const Spacer(),
            GestureDetector(
              onTap: () => viewModel.nicknameButtonFunc(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  viewModel.nicknameButtonText(),
                  style: const TextStyle(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(right: 10)),
          ],
        ),
        const Padding(padding: EdgeInsets.all(10)),

        // 내 계정 섹션
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.surface(context), // 배경색 대응
            ),
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                "내 계정 : ${viewModel.email}",
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSub(context),
                ),
              ),
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.all(7)),
      ],
    );
  }
}
