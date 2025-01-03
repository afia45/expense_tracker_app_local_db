import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';
import '../UI/budget/budget_provider.dart';
import '../models/model.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddListProvider extends ChangeNotifier {
  //Variables
  int incomeHome = 0;
  int expenseHome = 0;
  int balanceHome = 0;
  ValueNotifier<List<ValueOfTextForm>> incomeTextFormValues = ValueNotifier([]);
  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;
  String _pin = "";
  // ! Filtered transactions list
  List<ValueOfTextForm> _filteredTransactions = [];
  List<ValueOfTextForm> get filteredTransactions => _filteredTransactions;

  void setFilteredTransactions(List<ValueOfTextForm> transactions) {
    _filteredTransactions = transactions;
    notifyListeners();
  }

  void refreshTransactions() {
  // Reapply filtering or fetch the latest list
  _filteredTransactions = incomeTextFormValues.value.toList(); // or fetch from database
  notifyListeners(); // Ensure UI updates
}

void refreshTransactionsAndFilter(DateTime currentDate) {
  // Reapply filtering or fetch the latest list
  _filteredTransactions = incomeTextFormValues.value.where((transaction) {
    final transactionDate = DateFormat('EEE, MMM d, yyyy').parse(transaction.currentDate);
    return transactionDate.month == currentDate.month &&
        transactionDate.year == currentDate.year;
  }).toList();
  notifyListeners(); // Ensure UI updates
}


  //!
  //Dark Theme
  Future<void> toggleTheme() async {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDarkTheme", _isDarkTheme);
  }

  //PIN
   Future<void> savePin(String pin) async {
    _pin = pin;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("pin", _pin);
  }

  Future<String?> getPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("pin");
  }

  //Functions
  //ADDING THE INCOME TRANSACTION TO THE HOME PAGE
  Future<void> addingIncome(ValueOfTextForm value, BuildContext context) async {
    final homePageBox = await Hive.openBox<ValueOfTextForm>("HomePageBox");
    final listId = await homePageBox.add(value);
    value.id = listId;
    await homePageBox.put(listId, value);
    incomeTextFormValues.value.add(value);
    incomeHome += value.incomeAmount;
    balanceHome += value.incomeAmount;
    refreshTransactions();
    getHomeElements();
    
    notifyListeners();
  }

  //ADDING THE EXPENSE TRANSACTION TO THE HOME PAGE
  Future<void> addingExpense(
      ValueOfTextForm value, BuildContext context) async {
    final homePageBox = await Hive.openBox<ValueOfTextForm>("HomePageBox");
    final listId = await homePageBox.add(value);
    value.id = listId;
    await homePageBox.put(listId, value);
    incomeTextFormValues.value.add(value);
    balanceHome = balanceHome - value.expenseAmount;
    expenseHome += value.expenseAmount;
    refreshTransactionsAndFilter(DateTime.now()); // Pass the currentDate
    getHomeElements();
    
    notifyListeners();
  }

  bool isIncomeExpenseDataLoading = false;

  //DISPLAY THE HIVE DATA TO THE HOME PAGE ( INCOME AND EXPENSE )
  Future<void> getHomeElements() async {
    isIncomeExpenseDataLoading = true;
    notifyListeners();
    final homePageBox = await Hive.openBox<ValueOfTextForm>("HomePageBox");
    incomeTextFormValues.value.clear();
    expenseHome = 0;
    incomeHome = 0;
    balanceHome = 0;
    final incomeExpenseList = homePageBox.values.toList();
    for (int i = 0; i < incomeExpenseList.length; i++) {
      expenseHome += incomeExpenseList[i].expenseAmount;
      incomeHome += incomeExpenseList[i].incomeAmount;
      balanceHome = incomeHome - expenseHome;
    }
    incomeTextFormValues.value.addAll(incomeExpenseList);
    isIncomeExpenseDataLoading = false;
    refreshTransactions();
    refreshTransactionsAndFilter(DateTime.now()); // Pass the currentDate
    notifyListeners();
  }

  //UPDATING THE ELEMENT OF THE LIST TO DISPLAY IN THE HOME PAGE
  Future<void> updateListElements({
    required int id,
    required ValueOfTextForm value,
  }) async {
    final homePageBox = await Hive.openBox<ValueOfTextForm>("HomePageBox");
    homePageBox.put(id, value);
    final indexOfCategory = homePageBox.get(id);
    indexOfCategory!.selectedIndexHome == 1
        ? indexOfCategory.expenseAmount = 0
        : indexOfCategory.incomeAmount = 0;
    
    refreshTransactionsAndFilter(DateTime.now()); // Pass the currentDate
    getHomeElements();
    
    notifyListeners();
  }

  //removing the list from the homepage and updating the amount and balance
  Future<void> removeListFromHomePage({required int id}) async {
    final homePageBox = await Hive.openBox<ValueOfTextForm>("HomePageBox");
    final listElement = homePageBox.get(id);
    incomeHome -= listElement!.incomeAmount;
    expenseHome -= listElement.expenseAmount;
    listElement.selectedIndexHome == 1
        ? balanceHome -= listElement.incomeAmount
        : balanceHome += listElement.expenseAmount;
    await homePageBox.delete(id);
    final index =
        incomeTextFormValues.value.indexWhere((element) => element.id == id);
    if (index != -1) {
      incomeTextFormValues.value.removeAt(index);
      refreshTransactionsAndFilter(DateTime.now()); // Pass the currentDate
      getHomeElements();
      
      incomeTextFormValues.notifyListeners();
    }
  }

  //Total spend of the displayed list on the home page to show on the budget page (Total Spend)
  int totalSpendValue = 0;

  //compare the category name of the homepage display list and the budgeted list
  //if the both category name are same then the spend amount of the home page list should add to the totalspendValue.
  void totalSpendAmount({BuildContext? context}) {
    final provider = Provider.of<BudgetProvider>(context!, listen: false);
    if (incomeTextFormValues.value.isNotEmpty &&
        provider.budgetedList.isNotEmpty) {
      totalSpendValue = 0; // Reset the totalSpendValue before calculating
      for (int i = 0; i < incomeTextFormValues.value.length; i++) {
        for (int j = 0; j < provider.budgetedList.length; j++) {
          if (incomeTextFormValues.value[i].categoryName ==
              provider.budgetedList[j].categories) {
            totalSpendValue += incomeTextFormValues.value[i].expenseAmount;
            break; // Break the inner loop once a match is found
          }
        }
      }
    }
    notifyListeners();
  }

  //total Remaining on the budget page
  void totalRemaining(BuildContext context) {
    totalSpendAmount(context: context);
    final provider = Provider.of<BudgetProvider>(context, listen: false);
    provider.totalRemaining = provider.totalBudget - totalSpendValue;
  }

  int selectedContainerIndex = 1;

  void changeColor({
    required int containerIndex,
  }) {
    selectedContainerIndex = containerIndex;
    notifyListeners();
  }
}
