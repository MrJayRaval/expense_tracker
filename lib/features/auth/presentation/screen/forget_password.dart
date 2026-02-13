import '../../../../config/theme_helper.dart';
import '../provider/auth_provider.dart';
import '../../../../ui/components/button.dart';
import '../../../../ui/components/textbox.dart';
import '../../../../routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _showDialog(BuildContext context, String title, String message) async {
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  BackButton(),
                  Center(
                    child: Text(
                      'Forgot Password?',
                      style: TextTheme.of(
                        context,
                      ).headlineMedium!.copyWith(color: ThemeHelper.onSurface),
                    ),
                  ),
                ],
              ),

              Text(
                'Don\'t worry, If your account exist. we will send you password reset link.',
                style: TextTheme.of(
                  context,
                ).bodyMedium!.copyWith(color: ThemeHelper.onSurface),
              ),

              SizedBox(height: 35),

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

                    SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustPrimaryButton(
                          label: 'Send',
                          function: () async {
                            if (auth.isLoading) return;
                            if (_formKey.currentState!.validate()) {
                              final success = await context
                                  .read<AuthProvider>()
                                  .resetPasswordLink(
                                    _email.text.trim(),
                                  );
                              if (success) {
                                await _showDialog(
                                  context,
                                  'Reset Link Sent',
                                  'Check your email for the password reset link.',
                                );
                              } else {
                                await _showDialog(
                                  context,
                                  'Reset Failed',
                                  auth.error ?? 'Unable to send reset link.',
                                );
                              }
                            }
                          },
                        ),

                        SizedBox(width: 5),

                        CustSecondaryButton(
                          label: 'Back to Log In',
                          function: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                              return;
                            }
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.login,
                            );
                          },
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
