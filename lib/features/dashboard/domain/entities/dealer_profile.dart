/// Identity summary shown at the top of the dealer dashboard.
class DealerProfile {
  const DealerProfile({
    required this.fullName,
    required this.initials,
    required this.commune,
    required this.isVerified,
  });

  final String fullName;
  final String initials;
  final String commune;
  final bool isVerified;
}
