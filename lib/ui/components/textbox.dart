import 'dart:async';

import 'package:expense_tracker/config/colors.dart';
import 'package:flutter/material.dart';

class CustTextField extends StatelessWidget {
  final String? fieldName;
  final String label;
  final bool? autoFocus;
  final TextInputType textInputType;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  const CustTextField({
    super.key,
    this.fieldName,
    required this.label,
    required this.controller,
    this.validator,
    this.autoFocus = false,
    this.textInputType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        // key: Key(fieldName!),
        keyboardType: textInputType,
        autofocus: autoFocus!,
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          label: Text(label),
          labelStyle: TextStyle(color: primaryColor),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: primaryColor, width: 3.0),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 2.0, color: primaryColor),
          ),

          errorStyle: TextStyle(color: errorColor),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: errorColor, width: 1.0),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: errorColor, width: 2.0),
          ),
        ),
      ),
    );
  }
}

class CustPasswordField extends StatefulWidget {
  final String label;
  final bool? autoFocus;
  final TextInputType textInputType;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustPasswordField({
    super.key,
    required this.label,
    required this.controller,
    this.autoFocus,
    this.textInputType = TextInputType.text,
    this.validator,
  });

  @override
  State<CustPasswordField> createState() => _CustPasswordFieldState();
}

class _CustPasswordFieldState extends State<CustPasswordField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = true;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscureText,
        validator: widget.validator,
        decoration: InputDecoration(
          label: Text(widget.label),
          suffixIcon: IconButton(
            style: ButtonStyle(),
            onPressed: () async => {
              setState(() {
                _obscureText = !_obscureText;
              }),

              await Future.delayed(const Duration(milliseconds: 800), () {}),

              setState(() {
                _obscureText = !_obscureText;
              }),
            },

            icon: _obscureText
                ? Icon(Icons.visibility, size: 25)
                : Icon(Icons.visibility_off),
          ),

          labelStyle: TextStyle(color: primaryColor),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: primaryColor, width: 3.0),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 2.0, color: primaryColor),
          ),

          errorStyle: TextStyle(color: errorColor),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: errorColor, width: 1.0),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: errorColor, width: 2.0),
          ),
        ),
      ),
    );
  }
}
