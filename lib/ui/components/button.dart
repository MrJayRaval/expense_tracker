import 'package:expense_tracker/config/colors.dart';
import 'package:flutter/material.dart';

class CustPrimaryButton extends StatefulWidget {
  final VoidCallback function;
  final String label;
  const CustPrimaryButton({
    super.key,
    required this.function,
    required this.label,
  });

  @override
  State<CustPrimaryButton> createState() => _CustPrimaryButtonState();
}

class _CustPrimaryButtonState extends State<CustPrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.function,
      style: ElevatedButton.styleFrom(
        elevation: 3,
        backgroundColor: primaryColor,
        foregroundColor: onPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(8),
        ),
      ),
      child: Text(
        widget.label,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: onPrimaryColor,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class CustSecondaryButton extends StatefulWidget {
  final VoidCallback function;
  final String label;
  const CustSecondaryButton({
    super.key,
    required this.function,
    required this.label,
  });

  @override
  State<CustSecondaryButton> createState() => _CustSecondaryButtonState();
}

class _CustSecondaryButtonState extends State<CustSecondaryButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: widget.function,
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: primaryColor,
          width: 2
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(8),
        ),
      ),
      child: Text(
        widget.label,
        style: TextTheme.of(
          context,
        ).titleMedium!.copyWith(
          letterSpacing: 0.8, 
          color: onSecondaryColor),
      ),
    );
  }
}
