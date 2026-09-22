import 'package:dksoft_market_dealer/core/domain/pickup_location.dart';
import 'package:dksoft_market_dealer/features/address/application/address_controller.dart';
import 'package:dksoft_market_dealer/features/authentication/presentation/widgets/auth_text_field.dart';
import 'package:dksoft_market_dealer/routing/app_router.dart';
import 'package:dksoft_market_dealer/utils/constants/app_colors.dart';
import 'package:dksoft_market_dealer/utils/constants/kinshasa_communes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Shown once, right after sign-up: a brand-new dealer can't reach the
/// dashboard until they've set their pickup address. Existing dealers
/// logging back in skip straight past this — see SignUpScreen/LoginScreen
/// for where each flow is routed.
class AddressScreen extends ConsumerStatefulWidget {
  const AddressScreen({super.key});

  @override
  ConsumerState<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends ConsumerState<AddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _referenceController = TextEditingController();
  String? _commune;

  @override
  void dispose() {
    _addressController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final displayName = FirebaseAuth.instance.currentUser?.displayName ?? '';

    // TODO(location): latitude/longitude default to 0 until a map picker
    // (e.g. via the geolocator package) is wired up — see the same TODO
    // in AuthRepository.signUpWithPhoneAndPassword.
    final address = PickupLocation(
      id: uid,
      name: displayName,
      address: _addressController.text.trim(),
      commune: _commune!,
      reference: _referenceController.text.trim(),
      latitude: 0,
      longitude: 0,
    );

    final success = await ref
        .read(addressControllerProvider.notifier)
        .save(address);

    if (!mounted) return;

    if (success) {
      context.goNamed(AppRoute.dashboard.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final saveState = ref.watch(addressControllerProvider);
    final isLoading = saveState.isLoading;

    ref.listen<AsyncValue<void>>(addressControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${next.error}')));
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: false,
        elevation: 0,
        title: Text(
          'Votre adresse',
          style: Theme.of(context).textTheme.headlineSmall!
              .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Où récupère-t-on vos commandes ?',
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  'Cette adresse sera utilisée par les motards pour la '
                  'livraison.',
                  style: Theme.of(context).textTheme.labelMedium
                      ?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),

                AuthTextField(
                  label: 'ADRESSE',
                  controller: _addressController,
                  prefix: Icon(
                    Icons.location_on_outlined,
                    color: Colors.grey[500],
                  ),
                  hintText: 'Avenue de la Victoire, 12',
                  validator: (value) => (value ?? '').trim().length < 3
                      ? 'Entrez votre adresse'
                      : null,
                ),
                const SizedBox(height: 14),

                DropdownButtonFormField<String>(
                  initialValue: _commune,
                  decoration: const InputDecoration(labelText: 'COMMUNE'),
                  items: kKinshasaCommunes
                      .map(
                        (commune) => DropdownMenuItem(
                          value: commune,
                          child: Text(commune),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _commune = value),
                  validator: (value) =>
                      value == null ? 'Sélectionnez votre commune' : null,
                ),
                const SizedBox(height: 14),

                AuthTextField(
                  label: 'POINT DE REPÈRE',
                  controller: _referenceController,
                  prefix: Icon(Icons.flag_outlined, color: Colors.grey[500]),
                  hintText: 'Près du rond-point Boulevard Triomphal',
                  validator: (value) => (value ?? '').trim().length < 3
                      ? 'Ajoutez un point de repère'
                      : null,
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
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
                        : const Text(
                            'Continuer',
                            style: TextStyle(fontWeight: FontWeight.w700),
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
