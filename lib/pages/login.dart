import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:stibu/core/app_scaffold/scaffold.dart';
import 'package:stibu/core/authentication/auth_provider.dart';
import 'package:stibu/router.gr.dart';
import 'package:watch_it/watch_it.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final FocusNode _focusNodePassword = FocusNode();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  bool _obscurePassword = true;

  Future<void> login() async {
    if (_formKey.currentState?.validate() ?? false) {
      final result = await di<AppAuthProvider>().login(
        _controllerUsername.text,
        _controllerPassword.text,
      );

      if (result.isFailure && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.failure.message ?? 'Failed to login.')),
        );
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
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            const SizedBox(height: 150),
            Text(
              'Welcome back',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 10),
            Text(
              'Login to your account',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 60),
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
              onEditingComplete: _focusNodePassword.requestFocus,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter username.';
                }

                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _controllerPassword,
              focusNode: _focusNodePassword,
              obscureText: _obscurePassword,
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
                }

                return null;
              },
            ),
            const SizedBox(height: 60),
            Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: login,
                  child: const Text('Login'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () async {
                        _formKey.currentState?.reset();

                        await AutoRouter.of(context).push(const SignupRoute());
                      },
                      child: const Text('Signup'),
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
    _focusNodePassword.dispose();
    _controllerUsername.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }
}
