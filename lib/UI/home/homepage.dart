import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/UI/addBugdet/addbudget.dart';
import '../../providers/provider.dart';
import '/utils/animation.dart';
import '/utils/gradienttext.dart';
import 'package:provider/provider.dart';
import '../../utils/colors.dart';
import '../addBugdet/addbudgetprovider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime currentDate = DateTime.now();

  //!-------FILTER-------------------
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _filterTransactions();
    });
  }

  void _filterTransactions() {
    final provider = Provider.of<AddListProvider>(context, listen: false);
    final filteredTransactions =
        provider.incomeTextFormValues.value.where((transaction) {
      final transactionDate =
          DateFormat('EEE, MMM d, yyyy').parse(transaction.currentDate);

      return transactionDate.month == currentDate.month &&
          transactionDate.year == currentDate.year;
    }).toList();

    provider.setFilteredTransactions(filteredTransactions);
  }

  //TODO---------------
  int _calculateMonthlyIncome(List<dynamic> transactions) {
    return transactions.fold(0, (sum, transaction) {
      if (transaction.selectedIndexHome == 1) {
        // Ensure the value is converted to a double
        int income = transaction.incomeAmount is int
            ? transaction.incomeAmount.toInt()
            : int.tryParse(transaction.incomeAmount.toString()) ?? 0;
        return sum + income;
      }
      return sum;
    });
  }

  int _calculateMonthlyExpense(List<dynamic> transactions) {
    return transactions.fold(0, (sum, transaction) {
      if (transaction.selectedIndexHome != 1) {
        // Safely handle expenseAmount type
        int expense = 0;

        if (transaction.expenseAmount is int) {
          expense = (transaction.expenseAmount as int).toInt();
        } else if (transaction.expenseAmount is String) {
          expense = int.tryParse(transaction.expenseAmount) ?? 0;
        }

        return sum + expense;
      }
      return sum;
    });
  }

//!---------------------------
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Consumer2<AddListProvider, AddBudgetProvider>(
      builder: (context, snapshot, snapshot2, _) {
        final filteredTransactions = snapshot.filteredTransactions;
        final monthlyIncome = _calculateMonthlyIncome(filteredTransactions);
        final monthlyExpense = _calculateMonthlyExpense(filteredTransactions);

        return Scaffold(
          backgroundColor: white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: white,
            title: GradientText(
              "Pouch Planner",
              gradient: LinearGradient(
                colors: [
                  teal,
                  teal,
                  Colors.black,
                ],
              ),
              style: const TextStyle(fontSize: 40),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: height,
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 20.0, top: 20.0),
                    decoration: BoxDecoration(
                      color: teal, // Background color
                      border: Border(
                        bottom: BorderSide(color: teal, width: 3.0),

                        //left: BorderSide(color: Colors.blue, width: 2.0),
                        //right: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                      borderRadius:
                          BorderRadius.circular(20), // Rounded corners
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Total Balance",
                                style: TextStyle(
                                  color: white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "BDT ${snapshot.balanceHome}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: white,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Material(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  20,
                                ),
                              ),
                              elevation: 10.0,
                              child: Container(
                                padding: const EdgeInsets.all(
                                    10.0), // Add consistent padding around content
                                decoration: BoxDecoration(
                                  color: white,
                                  border: Border.all(color: Colors.green),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize
                                            .min, // Wrap content height dynamically
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceEvenly, // Distribute content evenly
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center, // Center the content horizontally
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.monetization_on_rounded,
                                                color: Colors.green,
                                                size: 25, // Adjust icon size
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                "Total Income",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize:
                                                      16, // Adjust font size
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                              height:
                                                  8), // Add spacing between text and value
                                          Text(
                                            'BDT ${snapshot.incomeHome}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  18, // Adjust font size for better fit
                                            ),
                                          ),
                                          //const SizedBox(height: 8), // Add spacing before the icon
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Material(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  20,
                                ),
                              ),
                              elevation: 10.0,
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: white,
                                  border: Border.all(
                                    color: red,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(
                                      20,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.money_off_rounded,
                                                color: Colors.red,
                                                size: 24,
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                "Total Expense",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: black,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            "BDT ${snapshot.expenseHome}",
                                            style: TextStyle(
                                                color: black, fontSize: 18),
                                          ), // Display the amount of income
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //!-----FILTER
                      IconButton(
                        onPressed: () {
                          setState(() {
                            currentDate = currentDate.subtract(
                              const Duration(
                                days: 30,
                              ),
                            );
                            _filterTransactions(); // Update list for the new month
                          });
                        },
                        icon: const Icon(
                          Icons.chevron_left,
                          color: Colors.black,
                          size: 18.0,
                        ),
                      ),

                      Text(
                        DateFormat('MMMM y').format(
                          currentDate,
                        ),
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            currentDate =
                                currentDate.add(const Duration(days: 30));
                            _filterTransactions(); // Update list for the new month
                          });
                        },
                        icon: const Icon(Icons.chevron_right,
                            color: Colors.black, size: 18.0),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  snapshot.isIncomeExpenseDataLoading
                      ? const CircularProgressIndicator()
                      : snapshot.incomeTextFormValues.value.isEmpty
                          ? SingleChildScrollView(
                            child: Column(
                              
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    height: height * 0.26,
                                    child: Image.asset(
                                      "asset/images/homepage.png",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "No Transactions",
                                    style: TextStyle(
                                        color: black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Tap on '+' to add Income/Expense",
                                    style: TextStyle(
                                      color: primary,
                                    ),
                                  ),
                                ],
                              ),
                          )
                          : Expanded(
                              child: Column(
                                children: [
                                  // Align(
                                  //   alignment: Alignment.centerLeft,
                                  //   child: Text(
                                  //     DateFormat('MMMM y').format(
                                  //       DateTime.now(),
                                  //     ),
                                  //     style: const TextStyle(
                                  //       fontWeight: FontWeight.bold,
                                  //     ),
                                  //   ),
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10.0, left: 10.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.arrow_circle_up,
                                                  color: Colors.green,
                                                ),
                                                Text(
                                                  " Monthly Income",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              //"BDT ${monthlyIncome.toStringAsFixed(2)}"
                                              "BDT ${monthlyIncome}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green,
                                              ),
                                            )
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.arrow_circle_down,
                                                  color: red,
                                                ),
                                                Text(
                                                  " Monthly Expense",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "BDT ${monthlyExpense}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  //  const Divider(
                                  //    color: Colors.grey,
                                  //    height: 20.0,
                                  //    thickness: 2.0,
                                  //    indent: 10,
                                  //    endIndent: 10,
                                  //   indent: 0.0,
                                  //   endIndent: 300.0,
                                  // ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  const Divider(
                                    color: Color.fromRGBO(238, 238, 238, 1),
                                    height: 20.0,
                                    thickness: 5.0,
                                    indent: 10,
                                    endIndent: 10,
                                  ),

                                  Expanded(
                                    child: ListView.separated(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return Divider(
                                          color: Colors.grey.shade300,
                                          height: 15.0,
                                          thickness: 1.0,
                                          indent: 10.0,
                                          endIndent: 10.0,
                                        );
                                      },
                                      //!----FILTER---
                                      itemCount:
                                          snapshot.filteredTransactions.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final transaction = snapshot
                                            .filteredTransactions[index];
                                        return GestureDetector(
                                            onTap: () async {
                                              final itemIndex = snapshot
                                                  .incomeTextFormValues
                                                  .value[index];
                                              final result =
                                                  await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddBudget(
                                                    homePageItems: transaction,
                                                  ),
                                                ),
                                              );
                                              if (result == true) {
                                                // Assuming you have a method to refresh transactions
                                                Provider.of<AddListProvider>(
                                                        context,
                                                        listen: false)
                                                    .refreshTransactionsAndFilter(
                                                        currentDate); // Custom method to update filteredTransactions
                                              }
                                            },
                                            child: ListTile(
                                              title: Text(transaction.title),
                                              subtitle: Text(transaction.note),
                                              trailing: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(transaction
                                                      .currentDate), // Use correct field for the date
                                                  const SizedBox(height: 8),
                                                  transaction.selectedIndexHome ==
                                                          1
                                                      ? Text(
                                                          "+ BDT ${transaction.incomeAmount}",
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.green,
                                                          ))
                                                      : Text(
                                                          "- BDT ${transaction.expenseAmount}",
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.red,
                                                          )
                                                          ),
                                                ],
                                                
                                              ),
                                            ),
                                          );
                                      },
                                    ),
                                  ),
                                ],
                                
                              ),
                              
                            ),
                            
                ],
                
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: teal,
            foregroundColor: white,
            elevation: 8,
            onPressed: () {
              Navigator.of(context)
                  .push(AnimationClass().navigateToAddBudgetPage());
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
