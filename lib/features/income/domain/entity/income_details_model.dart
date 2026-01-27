class IncomeDetailsModel {
  final String id;
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
    this.id = '',
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
      'date': dateTime.toIso8601String(),
    };
  }

  factory IncomeDetailsModel.fromJson(Map<String, dynamic> json, String id) {
    // Support multiple field naming conventions (Firestore vs local)
    final String incomeTypeLabel =
        json['IncomeType'] ?? json['incomeTypeLabel'] ?? '';
    final String incomeTypeIcon =
        json['IncomeTypeIcon'] ?? json['incomeTypeIcon'] ?? '';
    final String incomeSourceLabel =
        json['IncomeSource'] ?? json['incomeSourceLabel'] ?? '';
    final String incomeSourceIcon =
        json['IncomeSourceIcon'] ?? json['incomeSourceIcon'] ?? '';
    final String notes = json['Notes'] ?? json['notes'] ?? '';

    // Parse amount which could be num or string
    final dynamic rawAmount = json['Amount'] ?? json['amount'] ?? 0;
    double amount;
    if (rawAmount is num) {
      amount = rawAmount.toDouble();
    } else {
      amount = double.tryParse(rawAmount?.toString() ?? '') ?? 0.0;
    }

    // Parse timestamp which may be a Firestore Timestamp, ISO string, or milliseconds
    final dynamic rawDate =
        json['TimeStamp'] ?? json['timeStamp'] ?? json['date'] ?? json['Date'];
    DateTime dateTime;
    if (rawDate == null) {
      dateTime = DateTime.now();
    } else if (rawDate is DateTime) {
      dateTime = rawDate;
    } else if (rawDate is int) {
      dateTime = DateTime.fromMillisecondsSinceEpoch(rawDate);
    } else if (rawDate is String) {
      dateTime = DateTime.tryParse(rawDate) ?? DateTime.now();
    } else if (rawDate is Map && rawDate['_seconds'] != null) {
      // Some serialized Timestamp formats
      dateTime = DateTime.fromMillisecondsSinceEpoch(
        (rawDate['_seconds'] as int) * 1000,
      );
    } else {
      try {
        // Firestore Timestamp
        final ts = rawDate; // often a Timestamp instance
        dateTime = ts.toDate();
      } catch (_) {
        dateTime = DateTime.now();
      }
    }

    return IncomeDetailsModel(
      id: id,
      incomeTypeLabel: incomeTypeLabel,
      incomeTypeIcon: incomeTypeIcon,
      incomeSourceLabel: incomeSourceLabel,
      incomeSourceIcon: incomeSourceIcon,
      notes: notes,
      amount: amount,
      dateTime: dateTime,
    );
  }
}
