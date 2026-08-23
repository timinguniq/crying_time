// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 라우터는 앱 수명 내내 살아있어야 하므로 keepAlive.
/// 로그인 가드 같은 전역 분기는 여기 `redirect` 에 붙인다.

@ProviderFor(appRouter)
final appRouterProvider = AppRouterProvider._();

/// 라우터는 앱 수명 내내 살아있어야 하므로 keepAlive.
/// 로그인 가드 같은 전역 분기는 여기 `redirect` 에 붙인다.

final class AppRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// 라우터는 앱 수명 내내 살아있어야 하므로 keepAlive.
  /// 로그인 가드 같은 전역 분기는 여기 `redirect` 에 붙인다.
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

String _$appRouterHash() => r'ba84329a8c2fd840c55e8b687401571cf878bc53';
