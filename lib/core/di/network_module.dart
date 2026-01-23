import 'package:dio/dio.dart';
import 'package:dutytable/core/network/dio_client.dart';
import 'package:injectable/injectable.dart';

@module
abstract class NetworkModule {
  @LazySingleton()
  Dio dio() {
    return DioClient.shared.dio;
  }
}
