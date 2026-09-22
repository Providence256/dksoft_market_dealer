import 'package:dksoft_market_dealer/features/provision/application/provision_controller.dart';
import 'package:dksoft_market_dealer/features/provision/domain/entities/provision_request.dart';
import 'package:dksoft_market_dealer/utils/constants/app_colors.dart';
import 'package:dksoft_market_dealer/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _paymentMethods = ['Mobile Money'];

/// Shared form for both "Alimenter" (dépôt) and "Retirer" (retrait) —
/// same shape, same flow, only the copy and the request type differ, so
/// one screen serves both rather than duplicating it.
class ProvisionRequestScreen extends ConsumerStatefulWidget {
  const ProvisionRequestScreen({super.key, required this.type});

  final ProvisionRequestType type;

  @override
  ConsumerState<ProvisionRequestScreen> createState() =>
      _ProvisionRequestScreenState();
}

class _ProvisionRequestScreenState
    extends ConsumerState<ProvisionRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String _method = _paymentMethods.first;

  bool get _isDeposit => widget.type == ProvisionRequestType.depot;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final amount = double.parse(_amountController.text.replaceAll(',', '.'));

    final success = await ref
        .read(provisionControllerProvider.notifier)
        .submit(type: widget.type, amount: amount, method: _method);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isDeposit ? 'Provision créditée.' : 'Retrait effectué.',
          ),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final submitState = ref.watch(provisionControllerProvider);
    final isLoading = submitState.isLoading;

    ref.listen<AsyncValue<void>>(provisionControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${next.error}')));
      }
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 2,
        scrolledUnderElevation: 0.5,
        title: Text(
          _isDeposit ? 'Alimenter mon compte' : 'Demander un retrait',
          style: Theme.of(context).textTheme.headlineSmall!
              .copyWith(color: AppColors.primary),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Sizes.p24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isDeposit
                      ? 'Combien voulez-vous ajouter à votre provision ?'
                      : 'Combien voulez-vous retirer de vos gains ?',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                gapH4,
                Text(
                  _isDeposit
                      ? 'Le montant sera ajouté immédiatement à votre '
                            'provision disponible.'
                      : 'Le montant sera retiré immédiatement de vos gains '
                            'retirables.',
                  style: Theme.of(context).textTheme.labelMedium
                      ?.copyWith(color: AppColors.textSecondaryLight),
                ),
                gapH24,

                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'MONTANT (USD)',
                    prefixText: '\$ ',
                  ),
                  validator: (value) {
                    final parsed = double.tryParse(
                      (value ?? '').replaceAll(',', '.'),
                    );
                    if (parsed == null || parsed <= 0) {
                      return 'Entrez un montant valide';
                    }
                    return null;
                  },
                ),
                gapH16,

                Text(
                  'MODE DE PAIEMENT',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                gapH8,
                Wrap(
                  spacing: Sizes.p8,
                  children: _paymentMethods.map((method) {
                    final selected = method == _method;
                    return ChoiceChip(
                      label: Text(method),
                      selected: selected,
                      onSelected: (_) => setState(() => _method = method),
                      selectedColor: AppColors.primary.withValues(alpha: 0.15),
                      labelStyle: TextStyle(
                        color: selected
                            ? AppColors.primary
                            : AppColors.textPrimaryLight,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    );
                  }).toList(),
                ),
                gapH24,

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            _isDeposit ? 'Créditer ma provision' : 'Retirer',
                            style: Theme.of(context).textTheme.bodySmall!
                                .copyWith(color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
