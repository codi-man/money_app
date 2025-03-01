class ExpenseIncomeModel {
  final String name;
  final String imageName;
  bool isSelected;

  ExpenseIncomeModel({
    required this.name,
    required this.imageName,
    this.isSelected = false,
  });

}
final List<ExpenseIncomeModel> expenseIncomeList = [
  ExpenseIncomeModel(imageName: 'assets/categories/expense/automobile.png', name: 'Automobile'),
  ExpenseIncomeModel(imageName: 'assets/categories/expense/baby.png', name: 'Baby Care'),
  ExpenseIncomeModel(imageName: 'assets/categories/expense/books.png', name: 'Books'),
  ExpenseIncomeModel(imageName: 'assets/categories/expense/charity.png', name: 'Charity'),
  ExpenseIncomeModel(imageName: 'assets/categories/expense/clothing.png', name: 'Clothing'),
  ExpenseIncomeModel(imageName: 'assets/categories/expense/drinks.png', name: 'Drinks'),
];