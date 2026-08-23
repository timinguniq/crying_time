// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 스플래시가 끝난 뒤 갈 경로(Routes.home 또는 Routes.onboarding).

@ProviderFor(SplashViewModel)
final splashViewModelProvider = SplashViewModelProvider._();

/// 스플래시가 끝난 뒤 갈 경로(Routes.home 또는 Routes.onboarding).
final class SplashViewModelProvider
    extends $AsyncNotifierProvider<SplashViewModel, String> {
  /// 스플래시가 끝난 뒤 갈 경로(Routes.home 또는 Routes.onboarding).
  SplashViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'splashViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$splashViewModelHash();

  @$internal
  @override
  SplashViewModel create() => SplashViewModel();
}

String _$splashViewModelHash() => r'301d33f0845dcdade26cc749705635ea454e3271';

/// 스플래시가 끝난 뒤 갈 경로(Routes.home 또는 Routes.onboarding).

abstract class _$SplashViewModel extends $AsyncNotifier<String> {
  FutureOr<String> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String>, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String>, String>,
              AsyncValue<String>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
