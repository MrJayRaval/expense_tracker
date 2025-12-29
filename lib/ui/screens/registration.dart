import 'package:expense_tracker/config/colors.dart';
import 'package:expense_tracker/ui/components/button.dart';
import 'package:expense_tracker/ui/components/textbox.dart';
import 'package:expense_tracker/ui/screens/login.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _userName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios),
                  ),
                ],
              ),
              Flexible(child: FractionallySizedBox(heightFactor: 0.2)),
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
                      label: 'Confirm Password',
                      controller: _confirmPassword,
                    ),

                    SizedBox(height: 18),

                    CustPrimaryButton(
                      label: 'Sign Up',
                      function: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('Content')));
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
