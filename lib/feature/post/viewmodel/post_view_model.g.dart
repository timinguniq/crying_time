// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 게시글 상세 화면의 상태. Failure 를 던져 AsyncError 로 표면화한다.
///
/// 유즈케이스는 GetIt 에서 직접 꺼낸다. 테스트에서는 GetIt 에 mock 을 등록해 격리한다.

@ProviderFor(PostViewModel)
final postViewModelProvider = PostViewModelFamily._();

/// 게시글 상세 화면의 상태. Failure 를 던져 AsyncError 로 표면화한다.
///
/// 유즈케이스는 GetIt 에서 직접 꺼낸다. 테스트에서는 GetIt 에 mock 을 등록해 격리한다.
final class PostViewModelProvider
    extends $AsyncNotifierProvider<PostViewModel, Post> {
  /// 게시글 상세 화면의 상태. Failure 를 던져 AsyncError 로 표면화한다.
  ///
  /// 유즈케이스는 GetIt 에서 직접 꺼낸다. 테스트에서는 GetIt 에 mock 을 등록해 격리한다.
  PostViewModelProvider._({
    required PostViewModelFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'postViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$postViewModelHash();

  @override
  String toString() {
    return r'postViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PostViewModel create() => PostViewModel();

  @override
  bool operator ==(Object other) {
    return other is PostViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$postViewModelHash() => r'058a85f0e4cfe773604b3d223d87b8dd3c9bfa94';

/// 게시글 상세 화면의 상태. Failure 를 던져 AsyncError 로 표면화한다.
///
/// 유즈케이스는 GetIt 에서 직접 꺼낸다. 테스트에서는 GetIt 에 mock 을 등록해 격리한다.

final class PostViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          PostViewModel,
          AsyncValue<Post>,
          Post,
          FutureOr<Post>,
          int
        > {
  PostViewModelFamily._()
    : super(
        retry: null,
        name: r'postViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 게시글 상세 화면의 상태. Failure 를 던져 AsyncError 로 표면화한다.
  ///
  /// 유즈케이스는 GetIt 에서 직접 꺼낸다. 테스트에서는 GetIt 에 mock 을 등록해 격리한다.

  PostViewModelProvider call(int postId) =>
      PostViewModelProvider._(argument: postId, from: this);

  @override
  String toString() => r'postViewModelProvider';
}

/// 게시글 상세 화면의 상태. Failure 를 던져 AsyncError 로 표면화한다.
///
/// 유즈케이스는 GetIt 에서 직접 꺼낸다. 테스트에서는 GetIt 에 mock 을 등록해 격리한다.

abstract class _$PostViewModel extends $AsyncNotifier<Post> {
  late final _$args = ref.$arg as int;
  int get postId => _$args;

  FutureOr<Post> build(int postId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Post>, Post>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Post>, Post>,
              AsyncValue<Post>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
