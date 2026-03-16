import 'package:injectable/injectable.dart';

import '../entities/detect_result.dart';
import '../repositories/chat_repository.dart';

@injectable
class DetectScheduleUseCase {
  final ChatRepository repository;

  DetectScheduleUseCase(this.repository);

  /// 메시지에서 일정 감지 (이전 메시지들과 함께 분석)
  Future<DetectResult?> call(
    String message, {
    List<String> previousMessages = const [],
  }) => repository.detectSchedule(message, previousMessages: previousMessages);
}
