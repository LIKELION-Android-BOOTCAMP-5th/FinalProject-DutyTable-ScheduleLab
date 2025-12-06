import 'package:dutytable/core/widgets/back_actions_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// TODO
/// 1. 12월 6일 ~ 7일에 공통 위젯으로 빼기
class AddCalendarScreen extends StatelessWidget {
  /// 캘린더 추가 화면
  const AddCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: BackActionsAppBar(
        title: Text(
          "새 캘린더",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w800),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            children: [
              const SizedBox(height: 10),

              // 캘린더 이미지
              Column(
                children: [
                  Text(
                    "캘린더 사진",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      shape: BoxShape.rectangle,
                      color: Colors.grey[200],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Color(0xFF707880),
                        size: 36,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "사진을 입력해주세요",
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // 캘린더 이름
              _LabeledTextField(label: "캘린더 이름", hint: "캘린더 이름을 입력해주세요"),

              const SizedBox(height: 12),

              //멤버 추가
              _LabeledTextField(
                label: "멤버 추가",
                hint: "닉네임으로 검색하기",
                readOnly: true,
                onTap: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (_) => _MemberSelectDialog(),
                  );
                },
              ),

              const SizedBox(height: 12),

              //설명
              _LabeledTextField(
                label: "설명",
                hint: "캘린더 설명을 입력해주세요 (선택사항)",
                maxLines: 8,
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey, width: 1)),
        ),
        child: SafeArea(
          top: false,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: const Text(
                "저장",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LabeledTextField extends StatelessWidget {
  /// 라벨
  final String label;

  /// 최대 텍스트 라인 - 기본 1
  final int maxLines;

  /// 텍스트 필드 힌트
  final String? hint;
  // TODO: 추후 ViewModel로 이동 시 삭제
  /// 텍스트 에딧 컨트롤
  final TextEditingController? controller;

  /// 텍스트 필드 validation
  final String? Function(String?)? validator;

  /// 읽기 전용 체크 - 멤버 추가 다이얼로그
  final bool readOnly;

  /// 텍스트 필드 클릭 시 해당 콜백 함수
  final VoidCallback? onTap;

  /// 라벨 + 텍스트 필드
  const _LabeledTextField({
    super.key,
    required this.label,
    this.maxLines = 1,
    this.controller,
    this.hint,
    this.validator,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 8),

        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}

// 멤버 추가 다이얼로그
class _MemberSelectDialog extends StatelessWidget {
  /// 멤버 추가 다이얼로그
  const _MemberSelectDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: size.width * 0.85,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(0.15)),
            ],
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
              _LabeledTextField(label: "닉네임 검색", hint: "닉네임을 검색해주세요"),

              const SizedBox(height: 16),

              // 초대한 멤버 리스트
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.separated(
                  itemCount: 5,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    thickness: 0.5,
                    color: Colors.grey.shade300,
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
                    color: const Color(0xFF3E7BFF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "완료",
                    style: TextStyle(
                      color: Colors.white,
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
