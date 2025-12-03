import 'package:dutytable/features/auth/presentation/viewmodels/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(),
      child: _LoginScreen(),
    );
  }
}

class _LoginScreen extends StatelessWidget {
  const _LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Consumer<LoginViewModel>(
            builder: (context, viewModel, child) {
              return GestureDetector(
                onTap: () {
                  viewModel.googleSignIn(context);
                },
                child: const Text("로그인 하기"),
              );
            },
          ),
        ),
      ),
    );
  }
}
