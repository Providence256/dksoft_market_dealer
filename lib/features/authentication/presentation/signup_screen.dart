import 'package:dksoft_market_dealer/features/authentication/domain/user_role.dart';
import 'package:dksoft_market_dealer/features/authentication/presentation/auth_controller.dart';
import 'package:dksoft_market_dealer/features/authentication/presentation/widgets/auth_text_field.dart';
import 'package:dksoft_market_dealer/routing/app_router.dart';
import 'package:dksoft_market_dealer/utils/constants/app_colors.dart';
import 'package:dksoft_market_dealer/utils/constants/kinshasa_communes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key, this.onSuccess});

  final VoidCallback? onSuccess;

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // This is the dealer app, so dealer is the sensible default — but the
  // same auth flow doubles as a client sign-up until a dedicated client
  // app exists, so both options stay available.
  UserRole _role = UserRole.dealer;
  String? _commune;
  bool _obscurePassword = true;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vous devez accepter les conditions d'utilisation."),
        ),
      );
      return;
    }
    if (!isValid) return;

    FocusScope.of(context).unfocus();

    final success = await ref
        .read(authControllerProvider.notifier)
        .signUp(
          fullName: _nameController.text.trim(),
          phone: '+243${_phoneController.text.replaceAll(' ', '')}',
          password: _passwordController.text,
          commune: _commune!,
          role: _role,
          email: _emailController.text.trim().isEmpty
              ? null
              : _emailController.text.trim(),
        );

    if (!mounted) return;

    if (success) {
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${next.error}')));
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        title: Text(
          'Créer un compte',
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
                  'Rejoignez Dksoft Market',
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  'Quelques informations pour créer votre profil.',
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),

                _SectionLabel('Je suis'),
                const SizedBox(height: 10),
                SegmentedButton<UserRole>(
                  segments: const [
                    ButtonSegment(
                      value: UserRole.dealer,
                      label: Text('Dealer'),
                      icon: Icon(Icons.storefront_outlined),
                    ),
                    ButtonSegment(
                      value: UserRole.client,
                      label: Text('Client'),
                      icon: Icon(Icons.person_outline),
                    ),
                  ],
                  selected: {_role},
                  onSelectionChanged: (selection) =>
                      setState(() => _role = selection.first),
                  style: SegmentedButton.styleFrom(
                    selectedBackgroundColor: AppColors.primary,
                    selectedForegroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                _SectionLabel('Vos informations'),
                const SizedBox(height: 10),

                AuthTextField(
                  label: 'NOM COMPLET',
                  controller: _nameController,
                  prefix: Icon(Icons.person_outline, color: Colors.grey[500]),
                  hintText: 'Providence Musaghi',
                  validator: (value) => (value ?? '').trim().length < 2
                      ? 'Entrez votre nom complet'
                      : null,
                ),
                const SizedBox(height: 14),

                AuthTextField(
                  label: 'TÉLÉPHONE',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  hintText: '995 415 641',
                  prefix: const _CountryPrefix(),
                  validator: (value) {
                    final digits = (value ?? '').replaceAll(
                      RegExp(r'[^0-9]'),
                      '',
                    );
                    return digits.length < 9 ? 'Numéro invalide' : null;
                  },
                ),
                const SizedBox(height: 14),

                AuthTextField(
                  label: 'E-MAIL (OPTIONNEL)',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'vous@exemple.com',
                  prefix: Icon(Icons.mail_outline, color: Colors.grey[500]),
                  validator: (value) {
                    if (value == null || value.isEmpty) return null;
                    final valid = RegExp(r'^.+@.+\..+$').hasMatch(value);
                    return valid ? null : 'E-mail invalide';
                  },
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
                const SizedBox(height: 22),

                _SectionLabel('Sécurité'),
                const SizedBox(height: 10),

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

                  validator: (value) =>
                      (value ?? '').length < 6 ? 'Au moins 6 caractères' : null,
                ),
                const SizedBox(height: 14),

                AuthTextField(
                  label: 'CONFIRMER LE MOT DE PASSE',
                  controller: _confirmPasswordController,
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

                  validator: (value) => value != _passwordController.text
                      ? 'Les mots de passe ne correspondent pas'
                      : null,
                ),
                const SizedBox(height: 16),

                InkWell(
                  onTap: () => setState(() => _acceptedTerms = !_acceptedTerms),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _acceptedTerms,
                        onChanged: (value) =>
                            setState(() => _acceptedTerms = value ?? false),
                        activeColor: AppColors.primary,
                      ),
                      Expanded(
                        child: Text(
                          "J'accepte les conditions d'utilisation de Dksoft Market",
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

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
                            'Créer mon compte',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                Center(
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(color: Colors.grey[600]),
                      children: [
                        const TextSpan(text: 'Déjà un compte ? '),
                        TextSpan(
                          text: 'Se connecter',
                          style: const TextStyle(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w700,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).pop();
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
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall
          ?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}

class _CountryPrefix extends StatelessWidget {
  const _CountryPrefix();

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
