import 'package:expense_tracker/config/colors.dart';
import 'package:expense_tracker/features/auth/presentation/pages/login.dart';
import 'package:expense_tracker/features/auth/presentation/provider/auth_provider.dart';
import 'package:expense_tracker/ui/components/button.dart';
import 'package:expense_tracker/ui/components/textbox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatelessWidget {
  final _userName = TextEditingController();

  final _email = TextEditingController();

  final _password = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProviderr>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: secondaryColor,
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
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
                      autoFocus: true,
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

                    CustPasswordField(label: 'Password', controller: _password),

                    const SizedBox(height: 18),

                    CustPasswordField(
                      validator: (value) {
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

                    if (auth.error != null) Text(auth.error!),

                    CustPrimaryButton(
                      label: 'Sign Up',
                      function: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('Content')));
                        }

                        auth.isLoading
                            ? ()
                            : context.read<AuthProviderr>().register(
                                _email.text.trim(),
                                _password.text.trim(),
                              );
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
