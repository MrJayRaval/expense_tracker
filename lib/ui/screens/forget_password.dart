import 'package:expense_tracker/ui/components/button.dart';
import 'package:expense_tracker/ui/components/textbox.dart';
import 'package:expense_tracker/ui/screens/login.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                      style: TextTheme.of(context).headlineMedium,
                    ),
                  ),
                ],
              ),

              Text(
                'Don\'t worry, If your account exist. we will send you password reset link.',
                style: TextTheme.of(context).bodyMedium,
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
                          function: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Content')),
                              );
                            }
                          },
                        ),

                        SizedBox(width: 5),

                        CustSecondaryButton(
                          label: 'Back to Log In',
                          function: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
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
