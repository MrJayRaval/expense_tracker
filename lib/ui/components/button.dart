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
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(8),
        ),
      ),
      child: Text(
        widget.label,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
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
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(8),
        ),
      ),
      child: Text(
        widget.label,
        style: TextTheme.of(context).titleMedium!.copyWith(
          letterSpacing: 0.8,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}

class CustOutlinedButton extends StatefulWidget {
  final VoidCallback function;
  final String label;
  final TextStyle textStyle;
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;

  const CustOutlinedButton({
    super.key,
    required this.label,
    required this.textStyle,
    required this.borderRadius,
    required this.borderWidth,
    required this.borderColor, 
    required this.function,
  });

  @override
  State<CustOutlinedButton> createState() => _CustOutlinedButtonState();
}

class _CustOutlinedButtonState extends State<CustOutlinedButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: widget.function,
      style: ButtonStyle(
        side: WidgetStatePropertyAll(
          BorderSide(width: widget.borderWidth, color: widget.borderColor),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(widget.borderRadius),
          ),
        ),
      ),
      child: Text(widget.label, style: widget.textStyle),
    );
  }
}
