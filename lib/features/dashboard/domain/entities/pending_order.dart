/// A single order awaiting the dealer's validation (§4.3 / §6.5), with the
/// time left before the acceptance window closes.
class PendingOrder {
  const PendingOrder({
    required this.orderNumber,
    required this.amount,
    required this.expiresIn,
  });

  final String orderNumber;
  final double amount;
  final Duration expiresIn;
}
