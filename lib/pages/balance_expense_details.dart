import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_app/models/expense_income_model.dart';
import 'package:money_app/pages/add_balance.dart';
import 'package:money_app/pages/home_page.dart';

class BalanceExpenseDetails extends StatefulWidget {
  const BalanceExpenseDetails({super.key});

  @override
  State<BalanceExpenseDetails> createState() => _BalanceExpenseDetailsState();
}

class _BalanceExpenseDetailsState extends State<BalanceExpenseDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top blue section
            Container(
              width: double.infinity,
              height: 200,
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "assets/logos/logo_white.png",
                    width: 100,
                    height: 100,
                  ),
                  Text(
                    "Your balance is \$$globalBalance",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // Spacer between blue section and expense details
            const SizedBox(height: 20),
            // "Your Total expense is" text with a highlighted style
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueGrey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blueGrey, width: 2),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Total Expense:",
                      style: TextStyle(
                        color: Colors.blueAccent.shade100,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "\$$expenseSum",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Spacer between expense details and bottom section
            const Spacer(),
            // Custom fancy buttons section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final newBalance = await Get.to<int>(const AddBalance());
                      if (newBalance != null) {
                        setState(() {
                          globalBalance += newBalance; // Add the new balance
                          Get.back(result: globalBalance); // Pass the updated globalBalance back
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Add Balance",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),



                  ElevatedButton(
                    onPressed: () {
                      // Navigate to homepage
                      Get.offAll(HomePage(expenseIncomeModel: expenseIncomeList,));
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 24),
                      backgroundColor: Colors.orangeAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "View Details",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            // Spacer between buttons and bottom text
            const Spacer(),
            // Bottom text with a fancy design
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Don't see your currency?\nRequest for it here.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}