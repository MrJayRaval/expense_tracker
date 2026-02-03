class TransactionDetailsModel {
  final String id;
  // Transaction type
  final String transactionCategoryLabel;
  final String transactionCategoryIcon; // asset path

  // transaction source
  final String transactionSourceLabel;
  final String transactionSourceIcon; // asset path

  // Details
  final String notes;
  final double amount;

  // Date & Time (separate but derived from one DateTime)
  final DateTime dateTime;

  const TransactionDetailsModel({
    required this.transactionCategoryLabel,
    required this.transactionCategoryIcon,
    required this.transactionSourceLabel,
    required this.transactionSourceIcon,
    required this.notes,
    required this.amount,
    required this.dateTime,
    this.id = '',
  });

  // ---- Serialization ----

  Map<String, dynamic> toJson() {
    return {
      'transactionCategoryLabel': transactionCategoryLabel,
      'transactionCategoryIcon': transactionCategoryIcon,
      'transactionSourceLabel': transactionSourceLabel,
      'transactionSourceIcon': transactionSourceIcon,
      'notes': notes,
      'amount': amount,
      'date': dateTime.toIso8601String(),
    };
  }

  factory TransactionDetailsModel.fromJson(
    Map<String, dynamic> json,
    String id,
  ) {
    // Support multiple field naming conventions (Firestore vs local)
    final String transactionCategoryLabel =
        json['TransactionCategory'] ?? json['transactionCategoryLabel'] ?? '';
    final String transactionCategoryIcon =
        json['TransactionCategoryIcon'] ??
        json['TransactionCategoryIcon'] ??
        '';
    final String transactionSourceLabel =
        json['TransactionSource'] ?? json['transactionSourceLabel'] ?? '';
    final String transactionSourceIcon =
        json['TransactionSourceIcon'] ?? json['transactionSourceIcon'] ?? '';
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

    return TransactionDetailsModel(
      id: id,
      transactionCategoryLabel: transactionCategoryLabel,
      transactionCategoryIcon: transactionCategoryIcon,
      transactionSourceLabel: transactionSourceLabel,
      transactionSourceIcon: transactionSourceIcon,
      notes: notes,
      amount: amount,
      dateTime: dateTime,
    );
  }
}
