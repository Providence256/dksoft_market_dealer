/// A dealer's deposit into or withdrawal from their provision.
///
/// §5.5 describes this as a *request* the dealer submits, separate from
/// the actual credit which needs admin validation (§12.3 — protection
/// contre les fausses commandes). TEST MODE: there's no back office yet,
/// so ProvisionRepository.submitRequest credits/debits the wallet
/// immediately and logs the request as already `validee` — see the TODO
/// there for what a real validation flow should do instead.
enum ProvisionRequestType { depot, retrait }

enum ProvisionRequestStatus { enAttente, validee, refusee }

class ProvisionRequest {
  const ProvisionRequest({
    required this.id,
    required this.type,
    required this.amount,
    required this.method,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final ProvisionRequestType type;
  final double amount;
  final String method;
  final ProvisionRequestStatus status;
  final DateTime createdAt;
}
