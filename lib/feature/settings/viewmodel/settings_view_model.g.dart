// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 설정 화면의 상태와 조작.
///
/// 변경 메서드는 실패 문구(성공이면 null)를 돌려준다. 스낵바를 띄우는 일은
/// 화면의 몫이라 viewmodel 이 BuildContext 를 알 필요가 없다.

@ProviderFor(SettingsViewModel)
final settingsViewModelProvider = SettingsViewModelProvider._();

/// 설정 화면의 상태와 조작.
///
/// 변경 메서드는 실패 문구(성공이면 null)를 돌려준다. 스낵바를 띄우는 일은
/// 화면의 몫이라 viewmodel 이 BuildContext 를 알 필요가 없다.
final class SettingsViewModelProvider
    extends $AsyncNotifierProvider<SettingsViewModel, SettingsState> {
  /// 설정 화면의 상태와 조작.
  ///
  /// 변경 메서드는 실패 문구(성공이면 null)를 돌려준다. 스낵바를 띄우는 일은
  /// 화면의 몫이라 viewmodel 이 BuildContext 를 알 필요가 없다.
  SettingsViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsViewModelHash();

  @$internal
  @override
  SettingsViewModel create() => SettingsViewModel();
}

String _$settingsViewModelHash() => r'26f63550fac74ff9cbf3888ebc4ab36b7de6cb74';

/// 설정 화면의 상태와 조작.
///
/// 변경 메서드는 실패 문구(성공이면 null)를 돌려준다. 스낵바를 띄우는 일은
/// 화면의 몫이라 viewmodel 이 BuildContext 를 알 필요가 없다.

abstract class _$SettingsViewModel extends $AsyncNotifier<SettingsState> {
  FutureOr<SettingsState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<SettingsState>, SettingsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SettingsState>, SettingsState>,
              AsyncValue<SettingsState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
