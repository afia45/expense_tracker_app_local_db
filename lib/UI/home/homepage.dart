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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Consumer2<AddListProvider, AddBudgetProvider>(
      builder: (context, snapshot, snapshot2, _) {
        return Scaffold(
          backgroundColor: white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: white,
            title: GradientText(
              "Expense Manager",
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            currentDate = currentDate.subtract(
                              const Duration(
                                days: 30,
                              ),
                            );
                          });
                        },
                        icon: const Icon(
                          Icons.chevron_left,
                          color: Colors.black,
                          size: 18.0,
                        ),
                      ),
                      //!--------------CHANGE
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
                            currentDate = currentDate.add(
                              const Duration(
                                days: 30,
                              ),
                            );
                          });
                        },
                        icon: const Icon(
                          Icons.chevron_right,
                          color: Colors.black,
                          size: 18.0,
                        ),
                      ),
                    ],
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize
                                      .min, // Wrap content height dynamically
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceEvenly, // Distribute content evenly
                                  crossAxisAlignment: CrossAxisAlignment
                                      .center, // Center the content horizontally
                                  children: [
                                    Text(
                                      "Income",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 16, // Adjust font size
                                      ),
                                    ),
                                    const SizedBox(
                                        height:
                                            8), // Add spacing between text and value
                                    Text(
                                      'BDT ${snapshot.incomeHome}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            17, // Adjust font size for better fit
                                      ),
                                    ),
                                    //const SizedBox(height: 8), // Add spacing before the icon
                                  ],
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.monetization_on_rounded,
                                  color: Colors.green,
                                  size: 30, // Adjust icon size
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
                          padding: const EdgeInsets.all(
                              10.0),
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    
                                    Text(
                                      "Expense",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: black, fontSize: 16),
                                    ),
                                    const SizedBox(height: 8,),
                                    Text(
                                      "BDT ${snapshot.expenseHome}",
                                      style: TextStyle(color: black, fontSize: 17),
                                    ), // Display the amount of income
                                  ],
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Icon(
                                  Icons.money_off_rounded,
                                  color: Colors.red,
                                  size: 28,
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: height * 0.05,
                    width: width * 0.45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: teal,
                      border: Border.all(
                        color: primary,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          20,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Balance : ",
                            style: TextStyle(
                              color: white,
                            ),
                          ),
                          Text(
                            "BDT ${snapshot.balanceHome}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  snapshot.isIncomeExpenseDataLoading
                      ? const CircularProgressIndicator()
                      : snapshot.incomeTextFormValues.value.isEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: height * 0.3,
                                  child: Image.asset(
                                    "asset/images/HOMEPAGE.png",
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
                            )
                          : Expanded(
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      DateFormat('EEE d MMMM').format(
                                        DateTime.now(),
                                      ),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const Divider(
                                    color: Colors.grey,
                                    height: 3.0,
                                    thickness: 1.0,
                                    indent: 0.0,
                                    endIndent: 300.0,
                                  ),
                                  const SizedBox(
                                    height: 20.0,
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
                                      itemCount: snapshot
                                          .incomeTextFormValues.value.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            final itemIndex = snapshot
                                                .incomeTextFormValues
                                                .value[index];
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => AddBudget(
                                                  homePageItems: itemIndex,
                                                ),
                                              ),
                                            );
                                          },
                                          child: ListTile(
                                            title: Text(
                                              snapshot.incomeTextFormValues
                                                  .value[index].title,
                                              style: const TextStyle(
                        
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18.0,
                                                
                                              ),
                                            ),
                                            subtitle: Text(
                                              snapshot.incomeTextFormValues
                                                  .value[index].note,
                                              style: const TextStyle(
                                                fontSize: 15.0,
                                              ),
                                            ),
                                            
                                            trailing: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  snapshot.incomeTextFormValues
                                                      .value[index].currentTime,
                                                
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 111, 110, 110),
                                                  ),
                                                ),
                                                const SizedBox(height: 8,),
                                                snapshot
                                                            .incomeTextFormValues
                                                            .value[index]
                                                            .selectedIndexHome ==
                                                        1
                                                    ? Text(
                                                        "+ BDT ${snapshot.incomeTextFormValues.value[index].incomeAmount}",
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.green, 
                                                        ),
                                                      )
                                                    : Text(
                                                        " - BDT ${snapshot.incomeTextFormValues.value[index].expenseAmount}",
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.red,
                                                        ),
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
            backgroundColor: white,
            foregroundColor: teal,
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
