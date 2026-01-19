import 'package:expense_tracker/features/auth/presentation/provider/auth_provider.dart';
import 'package:expense_tracker/ui/components/button.dart';
import 'package:expense_tracker/ui/components/textbox.dart';
import 'package:expense_tracker/features/auth/presentation/pages/forget_password.dart';
import 'package:expense_tracker/features/auth/presentation/pages/registration.dart';
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
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProviderr>();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),

              Text(
                'let\'s manage your money.',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSurface),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPassword(),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: BoxBorder.fromLTRB(
                                bottom: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 18),

                    if (auth.isLoading) const CircularProgressIndicator(),

                    if (auth.error != null) Text(auth.error!),

                    CustPrimaryButton(
                      label: 'Sign In',
                      function: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthProviderr>().logIn(
                            _email.text.trim(),
                            _password.text.trim(),
                          );
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegistrationPage(),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: BoxBorder.fromLTRB(
                                bottom: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
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
