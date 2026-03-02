import 'package:flutter/material.dart';

class AiSchedule extends StatelessWidget {
  final String? aiScheduleTitle;
  final String aiScheduleDate;
  final String aiScheduleTime;
  final String? aiSchedulePlace;

  const AiSchedule({
    super.key,
    required this.aiScheduleTitle,
    required this.aiScheduleDate,
    required this.aiScheduleTime,
    this.aiSchedulePlace = "(장소 없음)",
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: double.maxFinite,
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFDAE6FB), width: 2.0),
            color: Color(0xFFF8FAFF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Row(
                children: [
                  Text(
                    "${aiScheduleTitle} ${aiScheduleDate} ${aiScheduleTime} ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${aiSchedulePlace} ",
                    style: (aiSchedulePlace == "(장소 없음)")
                        ? TextStyle(color: Colors.grey)
                        : TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("일정에 추가하시겠습니까?"),
                ],
              ),
              Spacer(),
              GestureDetector(
                onTap: () {},
                child: Icon(Icons.close, size: 20, color: Color(0xFFDAE6FB)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
