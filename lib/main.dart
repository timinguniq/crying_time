import 'package:crying_time/app/app.dart';
import 'package:crying_time/app/di/injector.dart';
import 'package:crying_time/app/provider_retry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();

  runApp(const ProviderScope(retry: noProviderRetry, child: App()));
}
