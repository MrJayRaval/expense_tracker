import '../../../../config/theme_helper.dart';
import '../provider/auth_provider.dart';
import '../../../../ui/components/button.dart';
import '../../../../ui/components/textbox.dart';
import '../../../../routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _showErrorDialog(BuildContext context, String message) async {
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign In Failed'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: ThemeHelper.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: FractionallySizedBox(heightFactor: 0.2)),
              Image.asset('assets/logo.png', scale: 5),

              Text(
                'Welcome Back!',
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: ThemeHelper.onSurface,
                ),
              ),

              Text(
                'let\'s manage your money.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(color: ThemeHelper.onSurface),
              ),

              const SizedBox(height: 46),

              Form(
                key: _formKey,

                child: Column(
                  children: [
                    CustTextField(
                      label: 'Email',
                      textInputType: TextInputType.emailAddress,
                      controller: _email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter Email';
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Enter valid email';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 18),

                    CustPasswordField(
                      autoFocus: true,
                      label: 'Password',
                      controller: _password,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter Username';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.forgotPassword,
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: BoxBorder.fromLTRB(
                                bottom: BorderSide(
                                  width: 2,
                                  color: ThemeHelper.primary,
                                ),
                              ),
                            ),
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ThemeHelper.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 18),

                    if (auth.isLoading) const CircularProgressIndicator(),

                    CustPrimaryButton(
                      label: 'Sign In',
                      function: () async {
                        if (auth.isLoading) return;
                        if (_formKey.currentState!.validate()) {
                          final success = await context
                              .read<AuthProvider>()
                              .logIn(_email.text.trim(), _password.text.trim());
                          if (success) {
                            if (context.mounted) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                AppRoutes.dashboard,
                                (route) => false,
                              );
                            }
                          } else {
                            if (context.mounted) {
                              await _showErrorDialog(
                                context,
                                auth.error ?? 'Unable to sign in.',
                              );
                            }
                          }
                        }
                      },
                    ),

                    SizedBox(height: 18),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Don\'t have any Account? '),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.register);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: BoxBorder.fromLTRB(
                                bottom: BorderSide(
                                  color: ThemeHelper.primary,
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ThemeHelper.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
