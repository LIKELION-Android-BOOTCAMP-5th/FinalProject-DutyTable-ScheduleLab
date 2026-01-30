import 'package:flutter/material.dart';

abstract class LocalRepository {
  Future<void> redirect(BuildContext context);
}
