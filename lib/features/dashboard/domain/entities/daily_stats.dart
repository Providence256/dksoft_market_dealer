/// Today's activity snapshot, matching the admin/dealer dashboard
/// indicators described in §5.9 of the cahier des charges.
class DailyStats {
  const DailyStats({
    required this.date,
    required this.ordersCount,
    required this.marginEarned,
    required this.deliveredCount,
    required this.cancelledCount,
  });

  final DateTime date;
  final int ordersCount;
  final double marginEarned;
  final int deliveredCount;
  final int cancelledCount;
}
