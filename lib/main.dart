import 'package:crying_time/app/app.dart';
import 'package:crying_time/app/di/injector.dart';
import 'package:crying_time/app/provider_retry.dart';
import 'package:crying_time/data/network/api_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 목 모드에서는 Firebase 설정 파일(google-services.json 등)이 없어도 앱이 뜬다.
  if (!ApiConfig.useMockApi) {
    await Firebase.initializeApp();
  }

  configureDependencies();

  runApp(const ProviderScope(retry: noProviderRetry, child: App()));
}
