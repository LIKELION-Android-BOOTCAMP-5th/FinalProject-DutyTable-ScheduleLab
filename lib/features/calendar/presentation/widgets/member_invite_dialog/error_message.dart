import 'package:dutytable/features/calendar/presentation/viewmodels/shared_calendar_view_model.dart';
import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final SharedCalendarViewModel viewModel;

  const ErrorMessage({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: viewModel.inviteError == null
            ? const SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    viewModel.inviteError!,
                    key: ValueKey(viewModel.inviteError),
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              ),
      ),
    );
  }
}
