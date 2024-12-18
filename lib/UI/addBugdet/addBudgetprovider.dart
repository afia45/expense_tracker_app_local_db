import 'package:flutter/material.dart';
import '/UI/addBugdet/addbudgetmodel.dart';

class AddBudgetProvider extends ChangeNotifier {
  List<AddBudgetModel> expenseContainerList = [
    AddBudgetModel(
      false,
      0,
      'Others',
      Colors.blue,
      Icons.note_outlined,
    ),
    AddBudgetModel(
      false,
      1,
      'Bills and Utilities',
      Colors.yellow.shade700,
      Icons.payment_outlined,
    ),
    AddBudgetModel(
      false,
      2,
      'Food and Drinks',
      Colors.blue.shade700,
      Icons.fastfood_outlined,
    ),
    AddBudgetModel(
      false,
      3,
      'Entertainment',
      Colors.orange,
      Icons.tv,
    ),
    AddBudgetModel(
      false,
      4,
      'Investment',
      Colors.green.shade700,
      Icons.savings_outlined,
    ),
    AddBudgetModel(
      false,
      5,
      'Transportations',
      Colors.blueAccent,
      Icons.directions_bus_outlined,
    ),
    AddBudgetModel(
      false,
      6,
      'Shopping',
      Colors.pink.shade700,
      Icons.shopping_bag_outlined,
    ),
    AddBudgetModel(
      false,
      7,
      'Medical',
      Colors.indigo.shade700,
      Icons.medical_services_outlined,
    ),
    AddBudgetModel(
      false,
      8,
      'Education',
      Colors.teal.shade700,
      Icons.school_outlined,
    ),
    AddBudgetModel(
      false,
      9,
      'Gifts and Donations',
      Colors.deepOrange.shade700,
      Icons.card_giftcard_outlined,
    ),
    AddBudgetModel(
      false,
      10,
      'Insurance',
      Colors.indigo,
      Icons.newspaper_outlined,
    ),
    AddBudgetModel(
      false,
      11,
      'Tax',
      Colors.red,
      Icons.money_off_csred_outlined,
    ),
  ];
  List<AddBudgetModel> incomeContainerList = [
    AddBudgetModel(
      false,
      0,
      "Others",
      Colors.blue,
      Icons.note_outlined,
    ),
    AddBudgetModel(
        false, 1, 'Salary', Colors.green, Icons.payment_outlined),
    AddBudgetModel(
        false, 2, 'Sales', Colors.pink.shade700, Icons.trending_up_sharp),
    AddBudgetModel(
        false, 3, 'Awards', Colors.pinkAccent, Icons.language_outlined),
    AddBudgetModel(
        false, 4, 'Business', Colors.yellow.shade700, Icons.euro_outlined),
  ];

  //INCOME SECTION
  int incomeSelectedIndex = 0;
  String incomeCategoryName = '';
  late IconData incomeIconOfCategory;

  void incomeSelectedContainerColorChange(int newIndex) {
    incomeSelectedIndex = newIndex;
    if (newIndex >= 0 && newIndex < incomeContainerList.length) {
      for (int i = 0; i < incomeContainerList.length; i++) {
        incomeContainerList[i].boolean = false;
      }
      incomeContainerList[newIndex].boolean = true;
      incomeCategoryName = incomeContainerList[newIndex].text;
      incomeIconOfCategory = incomeContainerList[newIndex].icon;
      notifyListeners();
    }
  }

//EXPENSE SECTION
  int expenseSelectedIndex = 0;
  String expenseCategoryName = '';
  IconData expenseIconOfCategory = Icons.abc;

  void expenseSelectedContainerColorChange(int newIndex) {
    expenseSelectedIndex = newIndex;
    if (newIndex >= 0 && newIndex < expenseContainerList.length) {
      for (int i = 0; i < expenseContainerList.length; i++) {
        expenseContainerList[i].boolean = false;
      }
      expenseContainerList[newIndex].boolean = true;
      expenseCategoryName = expenseContainerList[newIndex].text;
      expenseIconOfCategory = expenseContainerList[newIndex].icon;
      notifyListeners();
    }
  }
}
