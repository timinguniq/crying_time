// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 홈 화면이 보여줄 게시글 번호 목록.
///
/// 화면에는 리터럴을 두지 않는다는 원칙에 따라, 목록이 서버에서 오도록 바뀌더라도
/// 이 viewmodel 만 고치면 되게 한다.

@ProviderFor(HomeViewModel)
final homeViewModelProvider = HomeViewModelProvider._();

/// 홈 화면이 보여줄 게시글 번호 목록.
///
/// 화면에는 리터럴을 두지 않는다는 원칙에 따라, 목록이 서버에서 오도록 바뀌더라도
/// 이 viewmodel 만 고치면 되게 한다.
final class HomeViewModelProvider
    extends $NotifierProvider<HomeViewModel, List<int>> {
  /// 홈 화면이 보여줄 게시글 번호 목록.
  ///
  /// 화면에는 리터럴을 두지 않는다는 원칙에 따라, 목록이 서버에서 오도록 바뀌더라도
  /// 이 viewmodel 만 고치면 되게 한다.
  HomeViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeViewModelHash();

  @$internal
  @override
  HomeViewModel create() => HomeViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<int>>(value),
    );
  }
}

String _$homeViewModelHash() => r'7aa6b010844a3178d9f84304464447570f970704';

/// 홈 화면이 보여줄 게시글 번호 목록.
///
/// 화면에는 리터럴을 두지 않는다는 원칙에 따라, 목록이 서버에서 오도록 바뀌더라도
/// 이 viewmodel 만 고치면 되게 한다.

abstract class _$HomeViewModel extends $Notifier<List<int>> {
  List<int> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<int>, List<int>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<int>, List<int>>,
              List<int>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
