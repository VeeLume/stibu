import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_helper_utils/flutter_helper_utils.dart';
import 'package:stibu/core/app_scaffold/scaffold.dart';
import 'package:stibu/core/authentication/auth_provider.dart';
import 'package:stibu/main.dart';
import 'package:watch_it/watch_it.dart';

@RoutePage()
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();
  final FocusNode _focusNodeConfirmPassword = FocusNode();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConFirmPassword =
      TextEditingController();

  bool _obscurePassword = true;

  Future<void> signup() async {
    if (_formKey.currentState?.validate() ?? false) {
      final registerResult = await di<AppAuthProvider>().register(
        email: _controllerEmail.text.trim(),
        password: _controllerPassword.text.trim(),
        name: _controllerUsername.text.trim(),
      );

      // Bug: registerResult can be a failure even if the user is created successfully.
      // So we thry to login after registration.
      try {
        final loginResult = await di<AppAuthProvider>().login(
          _controllerEmail.text.trim(),
          _controllerPassword.text.trim(),
        );

        if (loginResult.isFailure && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(loginResult.failure.message ?? 'Failed to login.'),
            ),
          );
        }
      } catch (e) {
        // Ignore the error, we just want to ensure the user is logged in after registration.
        log.d('Login after registration failed: $e');
        if (registerResult.isFailure && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                registerResult.failure.message ?? 'Failed to register.',
              ),
            ),
          );
          return;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: buildTitleBar(context),
    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    body: Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const SizedBox(height: 100),
            Text('Register', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 10),
            Text(
              'Create your account',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 35),
            TextFormField(
              controller: _controllerUsername,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter username.';
                }

                return null;
              },
              onEditingComplete: _focusNodeEmail.requestFocus,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _controllerEmail,
              focusNode: _focusNodeEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter email.';
                } else if (!value.isValidEmail) {
                  return 'Invalid email';
                }
                return null;
              },
              onEditingComplete: _focusNodePassword.requestFocus,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _controllerPassword,
              obscureText: _obscurePassword,
              focusNode: _focusNodePassword,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.password_outlined),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  icon:
                      _obscurePassword
                          ? const Icon(Icons.visibility_outlined)
                          : const Icon(Icons.visibility_off_outlined),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter password.';
                } else if (value.length < 8) {
                  return 'Password must be at least 8 character.';
                }
                return null;
              },
              onEditingComplete: _focusNodeConfirmPassword.requestFocus,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _controllerConFirmPassword,
              obscureText: _obscurePassword,
              focusNode: _focusNodeConfirmPassword,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: const Icon(Icons.password_outlined),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  icon:
                      _obscurePassword
                          ? const Icon(Icons.visibility_outlined)
                          : const Icon(Icons.visibility_off_outlined),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter password.';
                } else if (value != _controllerPassword.text) {
                  return "Password doesn't match.";
                }
                return null;
              },
            ),
            const SizedBox(height: 50),
            Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: signup,
                  child: const Text('Register'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

  @override
  void dispose() {
    _focusNodeEmail.dispose();
    _focusNodePassword.dispose();
    _focusNodeConfirmPassword.dispose();
    _controllerUsername.dispose();
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    _controllerConFirmPassword.dispose();
    super.dispose();
  }
}
