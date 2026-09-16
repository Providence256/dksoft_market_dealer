sealed class AppException implements Exception {
  AppException(this.code, this.message);

  final String code;
  final String message;

  @override
  String toString() => message;
}

//Orders

class ParseOrderFailureException extends AppException {
  ParseOrderFailureException(this.status)
    : super('parse-order-failure', 'Statut de commande inconnu: $status');
  final String status;
}
