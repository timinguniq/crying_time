// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 라우터는 앱 수명 내내 살아있어야 하므로 keepAlive.
/// 스플래시가 저장된 수령 기록을 보고 온보딩/홈으로 직접 보낸다.

@ProviderFor(appRouter)
final appRouterProvider = AppRouterProvider._();

/// 라우터는 앱 수명 내내 살아있어야 하므로 keepAlive.
/// 스플래시가 저장된 수령 기록을 보고 온보딩/홈으로 직접 보낸다.

final class AppRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// 라우터는 앱 수명 내내 살아있어야 하므로 keepAlive.
  /// 스플래시가 저장된 수령 기록을 보고 온보딩/홈으로 직접 보낸다.
  AppRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appRouterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return appRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$appRouterHash() => r'625446041346493b5a63c6eebbc842aac469bcdd';
