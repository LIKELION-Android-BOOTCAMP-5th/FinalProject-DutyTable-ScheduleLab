import 'dart:io';

import 'package:dutytable/features/calendar/data/datasources/calendar_data_source.dart';
import 'package:dutytable/features/calendar/data/models/calendar_model.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../main.dart';

class CalendarEditViewModel extends ChangeNotifier {
  /// 캘린더 제목 컨트롤러(private)
  late final TextEditingController _titleController = TextEditingController(
    text: _calendar.title,
  );

  /// 캘린더 제목 컨트롤러(public)
  TextEditingController get titleController => _titleController;

  /// 캘린더 설명 컨트롤러(private)
  late final TextEditingController _descController = TextEditingController(
    text: _calendar.description,
  );

  /// 캘린더 설명 컨트롤러(public)
  TextEditingController get descController => _descController;

  /// 캘린더 데이터(private)
  late CalendarModel _calendar;

  /// 캘린더 데이터(public)
  CalendarModel get calendar => _calendar;

  // 이미지 피커로 갤러리에서 사진 가져오기
  File? _image;
  File? get image => _image;
  final ImagePicker picker = ImagePicker();

  /// 캘린더 수정 뷰모델
  CalendarEditViewModel({CalendarModel? initialCalendarData}) {
    if (initialCalendarData != null) {
      _calendar = initialCalendarData;
    }
  }

  /// 방장 권한 넘김
  Future<void> transferAdminRole(String newAdminId) async {
    await CalendarDataSource.instance.transferAdminRole(
      _calendar.id,
      newAdminId,
    );
  }

  //이미지를 가져오기
  Future getImage() async {
    // 갤러리에서 선택된 이미지
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path); //이미지 가져와서 _image에 로컬 경로 저장
    }
    notifyListeners();
  }

  /// 선택한 이미지 supabase storage 에 저장
  Future<String?> _uploadCalendarImage() async {
    if (_image == null) return null;

    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final file = _image!;
    final extension = file.path.split('.').last;
    final filePath =
        'calendar-images/${user.id}/${DateTime.now().millisecondsSinceEpoch}.$extension';

    await supabase.storage
        .from('calendar-images')
        .upload(
          filePath,
          file,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );

    return supabase.storage.from('calendar-images').getPublicUrl(filePath);
  }

  /// 캘린더 정보 업데이트
  Future<bool> updateCalendarInfo() async {
    final imageUrl = await _uploadCalendarImage();

    final bool result = await CalendarDataSource.instance.updateCalendarInfo(
      _titleController.text,
      _descController.text,
      imageUrl,
      _calendar.id,
    );
    return result;
  }

  /// 컨트롤러 dispose
  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }
}
