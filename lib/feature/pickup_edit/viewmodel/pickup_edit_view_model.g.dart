// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pickup_edit_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PickupEditViewModel)
final pickupEditViewModelProvider = PickupEditViewModelProvider._();

final class PickupEditViewModelProvider
    extends $AsyncNotifierProvider<PickupEditViewModel, PickupEditState> {
  PickupEditViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pickupEditViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pickupEditViewModelHash();

  @$internal
  @override
  PickupEditViewModel create() => PickupEditViewModel();
}

String _$pickupEditViewModelHash() =>
    r'46f47760f78b02d220ea62eb0f0e31dbabbeb29f';

abstract class _$PickupEditViewModel extends $AsyncNotifier<PickupEditState> {
  FutureOr<PickupEditState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PickupEditState>, PickupEditState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PickupEditState>, PickupEditState>,
              AsyncValue<PickupEditState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
