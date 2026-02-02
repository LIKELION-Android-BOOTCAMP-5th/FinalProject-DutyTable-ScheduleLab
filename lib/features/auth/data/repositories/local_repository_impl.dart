import 'package:dutytable/features/notification/data/datasources/notification_data_source.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/local_repository.dart';

@LazySingleton(as: LocalRepository)
class LocalRepositoryImpl implements LocalRepository {
  final NotificationDataSource dataSource;

  LocalRepositoryImpl(this.dataSource);

  @override
  Future<void> redirect(BuildContext context) async {
    await dataSource.setupNotificationListenersAndState(context);
  }
}
