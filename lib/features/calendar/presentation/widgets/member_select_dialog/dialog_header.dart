import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DialogHeader extends StatelessWidget {
  const DialogHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '닉네임 검색',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ],
    );
  }
}
