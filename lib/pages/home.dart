import 'package:expen/core/theme.dart';
import 'package:expen/core/currency_symbol.dart';
import 'package:expen/provider/amount_provider.dart';
import 'package:expen/provider/currency_provider.dart';
import 'package:expen/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    //Provider
    var amountProvider = Provider.of<AmountProvider>(context);
    double totalAmount = amountProvider.totalAmount;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    //For getting size of screen
    Size mediaQuery = MediaQuery.of(context).size;

    return AppScaffold(
      currentIndex: -1,
      showBackButton: false,
      title: "Expendus",
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert_rounded),
          tooltip: "",
          itemBuilder:
              (context) => [
                //For deleting all the expense
                PopupMenuItem(
                  onTap: () {
                    showDialog<String>(
                      context: context,
                      builder:
                          (BuildContext context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            title: const Text(
                              'Are you sure you want to delete all your expenses?',
                            ),
                            content: const Text(
                              "You won't be able to restore it later.",
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  context.pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  amountProvider.deleteAllExpenses();
                                  context.pop();
                                },
                                child: Text(
                                  'Delete',
                                  style: TextStyle(color: AppColors.red),
                                ),
                              ),
                            ],
                          ),
                    );
                  },
                  child: Text(
                    "Delete All Expenses",
                    style: TextStyle(color: AppColors.red),
                  ),
                ),
              ],
        ),
        const SizedBox(width: 20),
      ],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome header with large text
              Text(
                "Don't be afraid\nto look at your bills!",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? AppColors.white : AppColors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "We can help you manage your expenses easily.",
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? AppColors.grey : AppColors.darkGrey,
                ),
              ),
              const SizedBox(height: 24),
              
              // Main expense card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Expenses", 
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: isDarkMode ? AppColors.grey : AppColors.darkGrey,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: amountProvider.range < amountProvider.totalAmount
                                  ? AppColors.red.withOpacity(0.1)
                                  : AppColors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              amountProvider.range < amountProvider.totalAmount
                                  ? "Over budget"
                                  : "On track",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: amountProvider.range < amountProvider.totalAmount
                                    ? AppColors.red
                                    : AppColors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Consumer<CurrencyProvider>(
                        builder: (context, currencyProvider, child) {
                          return Text(
                            "${currencySymbol[currencyProvider.selectedCurrencyIndex]["symbol"]}${totalAmount.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: amountProvider.range < amountProvider.totalAmount
                                  ? AppColors.red
                                  : isDarkMode ? AppColors.white : AppColors.black,
                            ),
                          );
                        },
                      ),
                      Text(
                        "Monthly target: ${amountProvider.range.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? AppColors.grey : AppColors.darkGrey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.push('/chart'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          "View Monthly Chart",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              Text(
                "Recent Expenses",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? AppColors.white : AppColors.black,
                ),
              ),
              const SizedBox(height: 16),
              
              // Recent expenses list
              amountProvider.amounts.isEmpty
                  ? Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 48,
                              color: AppColors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No expenses yet",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.darkGrey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Add your first expense using the + button",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Column(
                      children: List.generate(
                        amountProvider.amounts.length > 5 ? 5 : amountProvider.amounts.length,
                        (index) {
                          var amount = amountProvider.amounts[index];
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              onLongPress: () {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    title: const Text(
                                      'Delete this expense?',
                                    ),
                                    content: const Text(
                                      "This action cannot be undone.",
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          context.pop();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          amountProvider.deleteAmount(amount);
                                          context.pop();
                                        },
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(color: AppColors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              leading: CircleAvatar(
                                backgroundColor: isDarkMode
                                    ? AppColors.navBarDarkActiveBg
                                    : AppColors.cardYellow,
                                child: Icon(
                                  Icons.receipt_outlined,
                                  color: isDarkMode
                                      ? AppColors.primaryDark
                                      : AppColors.black,
                                ),
                              ),
                              title: Text(
                                amount.title.isEmpty ? "Other" : amount.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: amount.subtitle.isEmpty
                                  ? (amountProvider.showDateTime
                                      ? Text(amount.dateTime)
                                      : null)
                                  : Text(amount.subtitle),
                              trailing: Consumer<CurrencyProvider>(
                                builder: (context, currencyProvider, child) {
                                  return Text(
                                    "${currencySymbol[currencyProvider.selectedCurrencyIndex]["symbol"]}${amount.amount.toStringAsFixed(1)}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode
                                          ? AppColors.white
                                          : AppColors.black,
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              
              if (amountProvider.amounts.length > 5) ...[
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Add view all functionality if needed
                    },
                    child: Text(
                      "View All Expenses",
                      style: TextStyle(
                        color: AppColors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
              
              // Add padding at the bottom for better UI with the floating action button
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
