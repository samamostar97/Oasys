import 'package:flutter/material.dart';
import 'package:oasys_core/oasys_core.dart';

class LoginFormCard extends StatelessWidget {
  const LoginFormCard({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
    required this.isLoading,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool isLoading;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Prijava',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: usernameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Korisničko ime',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: FormValidators.compose([
                  FormValidators.requiredField(
                    'Korisničko ime je obavezno.',
                  ),
                  FormValidators.minLength(
                    3,
                    'Korisničko ime mora imati najmanje 3 karaktera.',
                  ),
                ]),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                onFieldSubmitted: (_) => onSubmit(),
                decoration: const InputDecoration(
                  labelText: 'Lozinka',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                validator: FormValidators.compose([
                  FormValidators.requiredField(
                    'Lozinka je obavezna.',
                  ),
                  FormValidators.minLength(
                    4,
                    'Lozinka mora imati najmanje 4 karaktera.',
                  ),
                ]),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: isLoading ? null : onSubmit,
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Prijavi se'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
