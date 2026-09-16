import 'dart:math';

import 'package:dksoft_market_dealer/utils/constants/app_sizes.dart';

class GridMetrics {
  const GridMetrics(this.crossAxisCount, this.itemWidth);

  final int crossAxisCount;
  final double itemWidth;

  factory GridMetrics.of(
    double maxWidth, {
    double minItemWidth = 250,
    double gap = Sizes.p12,
    int maxColumns = 6,
  }) {
    final crossAxisCount = max(
      2,
      min(maxColumns, (maxWidth / minItemWidth).floor()),
    );
    final itemWidth = (maxWidth - gap * (crossAxisCount - 1)) / crossAxisCount;
    return GridMetrics(crossAxisCount, itemWidth);
  }
}
