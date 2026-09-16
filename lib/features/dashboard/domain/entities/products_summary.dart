/// Count of products the dealer currently proposes, and how many
/// commerçants they come from.
class ProductsSummary {
  const ProductsSummary({
    required this.productsCount,
    required this.merchantsCount,
  });

  final int productsCount;
  final int merchantsCount;
}
