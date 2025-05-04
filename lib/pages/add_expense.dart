import 'package:expen/core/theme.dart';
import 'package:expen/provider/amount_provider.dart';
import 'package:expen/provider/currency_provider.dart';
import 'package:expen/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  //Controllers
  TextEditingController numController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController subTitleController = TextEditingController();

  //Border design
  OutlineInputBorder _buildBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    );
  }

  // Date handling
  DateTime todaysDate = DateTime.now();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    // Default to today's date
    selectedDate = DateTime.now();
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      // Allow selection from 1 year ago up to today
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
      builder: (context, child) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.secondaryYellow,
              onPrimary: AppColors.black,
              onSurface: isDarkMode ? Colors.white : Colors.black,
              surface: isDarkMode ? Color.fromRGBO(30, 30, 30, 1) : AppColors.cardBg,
            ),
            dialogBackgroundColor: isDarkMode ? Color.fromRGBO(30, 30, 30, 1) : AppColors.cardBg,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.blue,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //Provider
    var amountProvider = Provider.of<AmountProvider>(context);
    var currencyProvider = Provider.of<CurrencyProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      currentIndex: -1,
      title: "Add New Expense",
      showBackButton: true,
      showAppBar: true,
      floatingActionButton: null,
      actions: [
        //Saving expense data
        GestureDetector(
          onTap: () {
            _saveExpense(context, amountProvider, currencyProvider, isDarkMode);
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(
              "Save",
              style: TextStyle(
                fontSize: 16,
                color: AppColors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card for amount input
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Enter Amount",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? AppColors.white : AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Amount field
                      TextField(
                        controller: numController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        autofocus: true,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? AppColors.white : AppColors.black,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: isDarkMode ? Colors.black12 : AppColors.primary.withOpacity(0.3),
                          hintText: "0.00",
                          prefixIcon: SizedBox(
                            width: 40,
                            child: Center(
                              child: Text(
                                //This will show selected currency symbol
                                currencyProvider.selectedCurrencySymbol,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode ? AppColors.primaryDark : AppColors.darkGrey,
                                ),
                              ),
                            ),
                          ),
                          prefixStyle: TextStyle(color: AppColors.grey),
                          border: _buildBorder(),
                          enabledBorder: _buildBorder(),
                          focusedBorder: _buildBorder(),
                          hoverColor: AppColors.transparent,
                          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Expense details card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Expense Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? AppColors.white : AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
              
                      //Getting title from the user
                      Text(
                        "Title",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode ? AppColors.grey : AppColors.darkGrey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: isDarkMode ? Colors.black12 : AppColors.lightTransparent,
                          hintText: "e.g. Groceries",
                          border: _buildBorder(),
                          enabledBorder: _buildBorder(),
                          focusedBorder: _buildBorder(),
                          hoverColor: AppColors.transparent,
                          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        ),
                      ),
                      const SizedBox(height: 20),
              
                      //Getting description from the user
                      Text(
                        "Description (optional)",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode ? AppColors.grey : AppColors.darkGrey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: subTitleController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: isDarkMode ? Colors.black12 : AppColors.lightTransparent,
                          hintText: "e.g. Weekly shopping",
                          border: _buildBorder(),
                          enabledBorder: _buildBorder(),
                          focusedBorder: _buildBorder(),
                          hoverColor: AppColors.transparent,
                          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      //Date selection
                      Text(
                        "Date",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode ? AppColors.grey : AppColors.darkGrey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: _selectDate,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: isDarkMode ? Colors.black12 : AppColors.lightTransparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectedDate != null
                                    ? DateFormat('dd MMMM yyyy').format(selectedDate!)
                                    : DateFormat('dd MMMM yyyy').format(todaysDate),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isDarkMode ? AppColors.white : AppColors.black,
                                ),
                              ),
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 20,
                                color: isDarkMode ? AppColors.grey : AppColors.darkGrey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Add Save button at bottom
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _saveExpense(context, amountProvider, currencyProvider, isDarkMode),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColors.black, 
                    backgroundColor: AppColors.secondaryYellow,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Save Expense",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // Extract save expense functionality to a separate method
  void _saveExpense(BuildContext context, AmountProvider amountProvider, 
      CurrencyProvider currencyProvider, bool isDarkMode) {
    //Check if the textfield is empty or not
    if (numController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please enter an amount"),
          backgroundColor: AppColors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
      return;
    }

    // Try to parse the amount
    double? amount = double.tryParse(numController.text.replaceAll(',', '.'));
    if (amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please enter a valid amount"),
          backgroundColor: AppColors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
      return;
    }

    // Get title and subtitle
    String title = titleController.text;
    String subtitle = subTitleController.text;
    
    // Ensure we have a date selected
    if (selectedDate == null) {
      selectedDate = DateTime.now();
    }
    
    // Save the expense
    amountProvider.addAmount(title, subtitle, amount, selectedDate!);
    
    // Clear text fields
    numController.clear();
    titleController.clear();
    subTitleController.clear();
    
    // Navigate back
    context.pop();
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Expense added successfully!"),
        backgroundColor: AppColors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
