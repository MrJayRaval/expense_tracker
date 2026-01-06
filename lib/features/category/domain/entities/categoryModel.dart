final List<Map<String, String>> expenseCategoryEntity = [
  {
    'label': 'Baby',
    'icon': 'assets/Images/categoryIcon/game-icons--baby-bottle.svg',
  },
  {
    'label': 'Beauty',
    'icon': 'assets/Images/categoryIcon/temaki--lipstick.svg',
  },
  {
    'label': 'Bills',
    'icon': 'assets/Images/categoryIcon/mingcute--bill-2-fill.svg',
  },
  {'label': 'Car', 'icon': 'assets/Images/categoryIcon/car.svg'},
  {
    'label': 'Clothing',
    'icon': 'assets/Images/categoryIcon/lsicon--clothes-filled.svg',
  },
  {
    'label': 'Education',
    'icon': 'assets/Images/categoryIcon/basil--book-solid.svg',
  },
  {
    'label': 'Electronics',
    'icon': 'assets/Images/categoryIcon/emojione-monotone--fax-machine.svg',
  },
  {
    'label': 'Entertainment',
    'icon': 'assets/Images/categoryIcon/arcticons--jiocinema.svg',
  },
  {'label': 'Food', 'icon': 'assets/Images/categoryIcon/dashicons--food.svg'},
  {
    'label': 'Health',
    'icon': 'assets/Images/categoryIcon/ix--health-filled.svg',
  },
  {'label': 'Home', 'icon': 'assets/Images/categoryIcon/f7--house-fill.svg'},
  {
    'label': 'Insurance',
    'icon': 'assets/Images/categoryIcon/icon-park-solid--protect.svg',
  },
  {
    'label': 'Shopping',
    'icon': 'assets/Images/categoryIcon/weui--shop-filled.svg',
  },
  {
    'label': 'Social',
    'icon': 'assets/Images/categoryIcon/fa-solid--user-friends.svg',
  },
  {
    'label': 'Sport',
    'icon':
        'assets/Images/categoryIcon/material-symbols-light--sports-volleyball.svg',
  },
  {
    'label': 'Tax',
    'icon': 'assets/Images/categoryIcon/heroicons-solid--receipt-tax.svg',
  },
  {
    'label': 'Telephone',
    'icon': 'assets/Images/categoryIcon/wpf--phone-office.svg',
  },
  {
    'label': 'Transportation',
    'icon': 'assets/Images/categoryIcon/transportation.svg',
  },
];

class CategoryModel {
  final String label;
  final String icon;
  final bool isDefault;

  CategoryModel({required this.label, required this.isDefault, required this.icon});

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(label: map['label'], isDefault: false, icon: map['icon']);
  }

  Map<String, String> toMap() {
    return {
      'label': label,
      'icon': icon
      };
  }
}

final List<CategoryModel> defaultCategoryModels =
    expenseCategoryEntity.map((e) {
  return CategoryModel(
    label: e['label']!,
    icon: e['icon']!,
    isDefault: true,
  );
}).toList();

