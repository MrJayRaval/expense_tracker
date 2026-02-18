import '../../../../config/theme_helper.dart';
import '../provider/auth_provider.dart';
import '../../features/create_profile/data/models/user_profile_model.dart';
import '../../features/create_profile/presentation/provider/profile_provider.dart';
import '../../../../ui/components/button.dart';
import '../../../../ui/components/textbox.dart';
import '../../../../routes/routes.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _userName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _showErrorDialog(BuildContext context, String message) async {
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign Up Failed'),
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
  void dispose() {
    _userName.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ThemeHelper.surface,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                        return;
                      }
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    },
                    icon: Icon(Icons.arrow_back_ios),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),

              Image.asset('assets/logo.png', scale: 5),

              Text(
                'Nice to meet you!',
                style: Theme.of(context).textTheme.headlineLarge,
              ),

              Text(
                'Before we begin, we need some details.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 46),

              Form(
                key: _formKey,

                child: Column(
                  children: [
                    CustTextField(
                      autoFocus: false,
                      label: 'Name',
                      controller: _userName,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter Username';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 18),

                    CustTextField(
                      fieldName: 'emailField',
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

                    const SizedBox(height: 18),

                    CustPasswordField(
                      label: 'Password',
                      controller: _password,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter Password';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 18),

                    CustPasswordField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter Confirm Password';
                        }
                        if (_confirmPassword.text != _password.text) {
                          return "Password doesn't matched!";
                        }
                        return null;
                      },
                      label: 'Confirm Password',
                      controller: _confirmPassword,
                      textInputType: TextInputType.visiblePassword,
                    ),

                    SizedBox(height: 18),

                    if (auth.isLoading) const CircularProgressIndicator(),

                    // if (auth.error != null) Text(auth.error!),
                    CustPrimaryButton(
                      label: 'Sign Up',
                      function: () async {
                        if (auth.isLoading) return;
                        if (_formKey.currentState!.validate()) {
                          // call register and wait for the result
                          final success = await context
                              .read<AuthProvider>()
                              .register(
                                _email.text.trim(),
                                _password.text.trim(),
                              );
                          if (success) {
                            // get the newly created user
                            final user = context
                                .read<AuthProvider>()
                                .currentUser;

                            if (user != null) {
                              // create profile in Firestore
                              final profileSuccess = await context
                                  .read<ProfileProvider>()
                                  .createProfile(
                                    UserProfileModel(
                                      uid: user.uid,
                                      name: _userName.text.trim(),
                                      email: user.email ?? _email.text.trim(),
                                    ),
                                  );
                              if (!profileSuccess) {
                                await _showErrorDialog(
                                  context,
                                  context.read<ProfileProvider>().error ??
                                      'Failed to create user profile.',
                                );
                                await context.read<AuthProvider>().signOut();
                                if (mounted) {
                                  Navigator.popUntil(
                                    context,
                                    (route) => route.isFirst,
                                  );
                                }
                              } else {
                                if (mounted) {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    AppRoutes.dashboard,
                                    (route) => false,
                                  );
                                }
                              }
                            } else {
                              // if user is null something went wrong; show error
                              await _showErrorDialog(
                                context,
                                'Failed to get created user.',
                              );
                            }
                          } else {
                            // registration failed; error is shown via provider
                            await _showErrorDialog(
                              context,
                              auth.error ?? 'Unable to sign up.',
                            );
                          }
                        }
                      },
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
