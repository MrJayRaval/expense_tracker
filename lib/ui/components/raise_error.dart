import '../../config/theme_helper.dart';
import 'package:flutter/material.dart';

SnackBar buildErrorSnackBar(String message) {
  return SnackBar(
    content: Text(
      message,
      style: ThemeHelper.bodyMedium!.copyWith(
        color: ThemeHelper.onErrorContainer,
      ),
    ),
    backgroundColor: ThemeHelper.errorContainer,
    showCloseIcon: true,
    closeIconColor: ThemeHelper.onErrorContainer,
    duration: const Duration(seconds: 1),
    dismissDirection: DismissDirection.up,
  );
}
