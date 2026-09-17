import 'package:dksoft_market_dealer/features/authentication/presentation/auth_controller.dart';
import 'package:dksoft_market_dealer/features/authentication/presentation/widgets/auth_text_field.dart';
import 'package:dksoft_market_dealer/routing/app_router.dart';
import 'package:dksoft_market_dealer/utils/constants/app_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key, this.onSuccess});

  final VoidCallback? onSuccess;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final success = await ref
        .read(authControllerProvider.notifier)
        .signIn(
          phone: '+243${_phoneController.text.replaceAll(' ', '')}',
          password: _passwordController.text,
        );

    if (success && mounted) {
      if (widget.onSuccess != null) {
        widget.onSuccess!();
        return;
      }

      final from = GoRouterState.of(context).uri.queryParameters['from'];
      if (from != null && from.isNotEmpty) {
        context.go(Uri.decodeComponent(from));
      } else if (context.canPop()) {
        context.pop();
      } else {
        context.goNamed(AppRoute.dashboard.name);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    ref.listen<AsyncValue<void>>(authControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(next.error.toString())));
      }
    });

    return Scaffold(
      backgroundColor: AppColors.primary,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- En-tête bleu marine ----
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Bienvenue sur\nDksoft Market',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            height: 1.15,
                          ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      "Achetez auprès des commerçants de Kinshasa, "
                      "livré par moto en moins d'une heure.",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ---- Feuille blanche ----
            Expanded(
              flex: 8,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    24,
                    12,
                    24,
                    MediaQuery.viewInsetsOf(context).bottom + 24,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        Text(
                          'Se connecter',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Votre numéro de téléphone',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 20),

                        // Téléphone
                        AuthTextField(
                          label: 'TÉLÉPHONE',
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          focused: true,
                          hintText: '995 415 641',
                          autofillHints: const [AutofillHints.telephoneNumber],
                          prefix: const _PhonePrefix(),
                          validator: (value) {
                            final digits = (value ?? '').replaceAll(
                              RegExp(r'[^0-9]'),
                              '',
                            );
                            if (digits.length < 9) {
                              return 'Numéro de téléphone invalide';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        // Mot de passe
                        AuthTextField(
                          label: 'MOT DE PASSE',
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          prefix: Icon(
                            Icons.lock_outline_rounded,
                            color: Colors.grey[500],
                          ),
                          suffix: IconButton(
                            onPressed: () => setState(() {
                              _obscurePassword = !_obscurePassword;
                            }),
                            icon: HugeIcon(
                              color: AppColors.primary,
                              icon: _obscurePassword
                                  ? HugeIcons.strokeRoundedViewOffSlash
                                  : HugeIcons.strokeRoundedView,
                            ),
                          ),

                          validator: (value) {
                            if ((value ?? '').length < 6) {
                              return 'Au moins 6 caractères';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox.shrink(),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Mot de passe oublié ?',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
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
                                    'Se Connecter',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(
                                'ou',
                                style: TextStyle(color: Colors.grey[500]),
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // TODO: écran de vérification OTP par SMS.
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'La connexion par SMS arrive bientôt.',
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.phone_outlined,
                              color: Colors.green.shade600,
                            ),
                            label: const Text('Recevoir un code par SMS'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black87,
                              side: BorderSide(color: Colors.grey.shade300),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),

                        Center(
                          child: RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey[600]),
                              children: [
                                const TextSpan(text: 'Pas encore de compte ? '),
                                TextSpan(
                                  text: 'Créer un compte',
                                  style: const TextStyle(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      final from = GoRouterState.of(context)
                                          .uri
                                          .queryParameters['from'];
                                      context.pushNamed(
                                        AppRoute.signup.name,
                                        queryParameters: from != null
                                            ? {'from': from}
                                            : const {},
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhonePrefix extends StatelessWidget {
  const _PhonePrefix();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('🇨🇩', style: TextStyle(fontSize: 20)),
        const SizedBox(width: 6),
        Text(
          '+243',
          style: Theme.of(context).textTheme.titleMedium!
              .copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(width: 10),
        Container(width: 1, height: 22, color: Colors.grey.shade300),
      ],
    );
  }
}
