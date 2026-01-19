import 'dart:async';

import 'package:flutter/material.dart';

class CustTextField extends StatelessWidget {
  final String? fieldName;
  final String label;
  final bool? autoFocus;
  final bool? expands;
  final TextInputType textInputType;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final double borderWidth;
  final dynamic maxLines;
  final dynamic minLines;  
  final  TextStyle textStyle;
  final Color borderColor;

  const CustTextField({
    super.key,
    this.fieldName,
    required this.label,
    required this.controller,
    this.validator,
    this.borderWidth = 3.0,
    this.expands = false,
    this.autoFocus = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.textInputType = TextInputType.text,
    this.textStyle =const TextStyle(),
    this.borderColor = const Color.fromARGB(255, 0, 0, 0)
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        
        // key: Key(fieldName!),
        expands: expands!,
        maxLines: maxLines,
        minLines: minLines,
        keyboardType: textInputType,
        autofocus: autoFocus!,
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          label: Text(label),
          
          alignLabelWithHint: true,
          labelStyle: textStyle,

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              width: borderWidth,
              color: borderColor,
            ),
          ),

          errorStyle: TextStyle(color: Theme.of(context).colorScheme.error),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: borderWidth,
            ),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: borderWidth,
            ),
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
                ? Icon(
                    Icons.visibility,
                    size: 25,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : Icon(
                    Icons.visibility_off,
                    color: Theme.of(context).colorScheme.primary,
                  ),
          ),

          labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 3.0,
            ),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              width: 2.0,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          errorStyle: TextStyle(color: Theme.of(context).colorScheme.error),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 1.0,
            ),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
