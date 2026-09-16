/// The dealer's provision balance, per the cahier des charges (§5.5):
/// - [available]: montant que le dealer peut utiliser.
/// - [blocked]: montant réservé pour une ou plusieurs commandes en cours.
/// - [withdrawable]: gains que le dealer peut retirer.
class DealerWallet {
  const DealerWallet({
    required this.available,
    required this.blocked,
    required this.withdrawable,
  });

  final double available;
  final double blocked;
  final double withdrawable;
}
