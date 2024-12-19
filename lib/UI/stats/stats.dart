import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart' as fl_chart_lib;
import 'package:pie_chart/pie_chart.dart' as pie_chart_lib;
import '../../providers/provider.dart';
import '../../utils/colors.dart';
import 'package:intl/intl.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final provider = Provider.of<AddListProvider>(context, listen: false);

    // Group Transactions by Month
    Map<String, Map<String, int>> groupedData = {};
    for (var transaction in provider.incomeTextFormValues.value) {
      DateTime date =
          DateFormat('EEE, MMM d, yyyy').parse(transaction.currentDate);
      String monthYear = DateFormat('MMM\nyyyy').format(date);

      groupedData[monthYear] ??= {'income': 0, 'expense': 0};
      groupedData[monthYear]!['income'] =
          (groupedData[monthYear]!['income'] ?? 0) + transaction.incomeAmount;
      groupedData[monthYear]!['expense'] =
          (groupedData[monthYear]!['expense'] ?? 0) + transaction.expenseAmount;
    }

    // Sort Months by Date
    List<String> months = groupedData.keys.toList()
      ..sort((a, b) {
        DateTime dateA = DateFormat('MMM\nyyyy').parse(a);
        DateTime dateB = DateFormat('MMM\nyyyy').parse(b);
        return dateA.compareTo(dateB);
      });

    // Create Bar Data
    //List<String> months = groupedData.keys.toList();
    List<fl_chart_lib.BarChartGroupData> barData =
        months.asMap().entries.map((entry) {
      int index = entry.key;
      String month = entry.value;
      return fl_chart_lib.BarChartGroupData(
        x: index,
        barRods: [
          fl_chart_lib.BarChartRodData(
            toY: groupedData[month]!['income']!.toDouble(),
            color: Colors.green,
            width: 12,
          ),
          fl_chart_lib.BarChartRodData(
            toY: groupedData[month]!['expense']!.toDouble(),
            color: Colors.red,
            width: 12,
          ),
        ],
      );
    }).toList();

    // Pie Chart Data
    Map<String, double> pieData = {
      "Income": provider.incomeHome.toDouble(),
      "Expense": provider.expenseHome.toDouble(),
    };

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Statistics",
          style: TextStyle(color: black, fontWeight: FontWeight.bold),
        ),
      ),
      body: provider.incomeHome == 0 && provider.expenseHome == 0
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: height * 0.45,
                  child: Image.asset(
                    "asset/images/stats.png",
                    fit: BoxFit.fill,
                  ),
                ),
                Text(
                  "You Haven't Added Expense/Income To Show The Statistics.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            )
          : SingleChildScrollView(
            padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(top: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[50]
                    ),
                    child: Column(
                      children: [
                        // Pie Chart
                  Text(
                    "Total Income and Expense",
                    style: TextStyle(
                        fontSize: 16,
                        color: black,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 250,
                    child: pie_chart_lib.PieChart(
                      chartRadius: 200.0,
                      dataMap: pieData,
                      colorList: [Colors.green, Colors.red],
                      chartType: pie_chart_lib.ChartType.disc,
                      chartValuesOptions: pie_chart_lib.ChartValuesOptions(
                        showChartValuesInPercentage: true,
                        showChartValuesOutside: false,
                      ),
                    ),
                  ),
                  
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Bar Chart
                  Container(
                    padding: EdgeInsets.only(top: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[50]
                    ),
                    child: Column(
                      children: [
                        Text(
                    "Monthly Income and Expense",
                    style: TextStyle(
                        fontSize: 16,
                        color: black,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 250,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width:
                              months.length * 90.0, // Adjust width dynamically
                          child: fl_chart_lib.BarChart(
                            fl_chart_lib.BarChartData(
                              maxY: groupedData.values
                                      .map((e) => [e['income']!, e['expense']!])
                                      .expand((e) => e)
                                      .reduce((a, b) => a > b ? a : b)
                                      .toDouble() *
                                  1.2, // Add padding to the top
                              barGroups: barData,
                              titlesData: fl_chart_lib.FlTitlesData(
                                leftTitles: fl_chart_lib.AxisTitles(
                                  sideTitles: fl_chart_lib.SideTitles(
                                    showTitles: false,
                                    reservedSize: 50,
                                  ),
                                ),
                                bottomTitles: fl_chart_lib.AxisTitles(
                                  sideTitles: fl_chart_lib.SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    getTitlesWidget: (value, meta) {
                                      int index = value.toInt();
                                      return index >= 0 && index < months.length
                                          ? Text(
                                              months[index],
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          : const SizedBox.shrink();
                                    },
                                  ),
                                ),
                              ),
                              gridData: fl_chart_lib.FlGridData(show: false),
                              borderData:
                                  fl_chart_lib.FlBorderData(show: false),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Legend for Bar Chart
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            "Income",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Row(
                        children: [
                          Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            "Expense",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
