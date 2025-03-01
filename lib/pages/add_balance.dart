import 'package:flutter/material.dart';
import 'package:money_app/pages/app_bar.dart';

int globalBalance = 30;

class AddBalance extends StatefulWidget {
  const AddBalance({super.key});

  @override
  State<AddBalance> createState() => _AddBalanceState();
}

class _AddBalanceState extends State<AddBalance> {
  TextEditingController addBalanceController = TextEditingController();

  void saveBalance() {
    setState(() {
      globalBalance = int.tryParse(addBalanceController.text) ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.number,
              controller: addBalanceController,
              decoration: InputDecoration(
              hintText: 'Enter the amount',
              hintStyle: const TextStyle(
                fontWeight: FontWeight.w300
              ),
              prefixIcon: const Icon(Icons.description),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              ),
            ),
            const SizedBox(height: 10,),

            ElevatedButton(
              onPressed: () {
                int? newBalance = int.tryParse(addBalanceController.text);
                if (newBalance != null) {
                  Navigator.pop(context, newBalance); // Return the new balance amount
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                backgroundColor: const Color(0xFF1E5DBF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Add",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Icon(
                    Icons.add,
                    color: Colors.white, // Icon color
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}