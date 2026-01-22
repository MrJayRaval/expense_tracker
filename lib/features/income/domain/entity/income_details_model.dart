import 'package:flutter/material.dart';

class IncomeDetailsModel {
  // Income type
  final String incomeTypeLabel;
  final String incomeTypeIcon; // asset path

  // Income source
  final String incomeSourceLabel;
  final String incomeSourceIcon; // asset path

  // Details
  final String notes;
  final double amount;

  // Date & Time (separate but derived from one DateTime)
  final DateTime dateTime;

  const IncomeDetailsModel({
    required this.incomeTypeLabel,
    required this.incomeTypeIcon,
    required this.incomeSourceLabel,
    required this.incomeSourceIcon,
    required this.notes,
    required this.amount,
    required this.dateTime,
  });

  // ---- Serialization ----

  Map<String, dynamic> toJson() {
    return {
      'incomeTypeLabel': incomeTypeLabel,
      'incomeTypeIcon': incomeTypeIcon,
      'incomeSourceLabel': incomeSourceLabel,
      'incomeSourceIcon': incomeSourceIcon,
      'notes': notes,
      'amount': amount,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory IncomeDetailsModel.fromJson(Map<String, dynamic> json) {
    return IncomeDetailsModel(
      incomeTypeLabel: json['incomeTypeLabel'],
      incomeTypeIcon: json['incomeTypeIcon'],
      incomeSourceLabel: json['incomeSourceLabel'],
      incomeSourceIcon: json['incomeSourceIcon'],
      notes: json['notes'],
      amount: (json['amount'] as num).toDouble(),
      dateTime: DateTime.parse(json['date']),
    );
  }
}
