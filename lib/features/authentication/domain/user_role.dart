/// The two account kinds the auth flow can create today.
///
/// A [client] account belongs to the buyer-facing app; a [dealer] account
/// is what unlocks this app's dashboard, provision wallet and order
/// validation (§3.1 / §3.3 of the cahier des charges).
enum UserRole { client, dealer }

extension UserRoleLabel on UserRole {
  String get label => switch (this) {
    UserRole.client => 'Client',
    UserRole.dealer => 'Dealer',
  };
}
