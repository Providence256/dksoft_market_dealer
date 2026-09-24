// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(orderStream)
final orderStreamProvider = OrderStreamFamily._();

final class OrderStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<OrderModel?>,
          OrderModel?,
          Stream<OrderModel?>
        >
    with $FutureModifier<OrderModel?>, $StreamProvider<OrderModel?> {
  OrderStreamProvider._({
    required OrderStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'orderStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$orderStreamHash();

  @override
  String toString() {
    return r'orderStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<OrderModel?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<OrderModel?> create(Ref ref) {
    final argument = this.argument as String;
    return orderStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is OrderStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$orderStreamHash() => r'4be7ac5a88cfaf4494745877c51f7d9e1e488eaa';

final class OrderStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<OrderModel?>, String> {
  OrderStreamFamily._()
    : super(
        retry: null,
        name: r'orderStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  OrderStreamProvider call(String id) =>
      OrderStreamProvider._(argument: id, from: this);

  @override
  String toString() => r'orderStreamProvider';
}
