var transactionCategoryModel = [
  {"icon": "assets/Images/income/bank.svg", "label": "Bank Account"},

  {"icon": "assets/Images/income/cash.svg", "label": "Cash"},

  {"icon": "assets/Images/income/card.svg", "label": "Card"},
];

class TransactionCategory {
  final String label;
  final String icon;

  TransactionCategory({required this.label, required this.icon});
}
