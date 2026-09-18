// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brands.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SeedController)
final seedControllerProvider = SeedControllerProvider._();

final class SeedControllerProvider
    extends $AsyncNotifierProvider<SeedController, void> {
  SeedControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'seedControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$seedControllerHash();

  @$internal
  @override
  SeedController create() => SeedController();
}

String _$seedControllerHash() => r'b252f33631b4c0ce5d7628c77fc1a256de39d859';

abstract class _$SeedController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
