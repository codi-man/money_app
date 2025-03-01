import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:money_app/models/added_task_model.dart';
import 'package:money_app/models/expense_income_model.dart';
import 'package:money_app/pages/add_balance.dart';
import 'package:money_app/pages/app_bar.dart';
import 'package:money_app/pages/balance_expense_details.dart';

int expenseSum = 0;
int amount = 0;

class HomePage extends StatefulWidget {
  final List<ExpenseIncomeModel> expenseIncomeModel;
  const HomePage({super.key, required this.expenseIncomeModel});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  List<bool> isSelected = [true, false];


  void updateBalance(int newBalance) {
    setState(() {
      globalBalance = newBalance;
    });
  }

  // Its a list to hold expense/income
  List<AddedTaskModel> addedTaskModel = [];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(isHomePage: true),
      body: Column(
        children: [
          balanceInfo(),
          const SizedBox(height: 10,),
          addedTaskModel.isEmpty 
            ? empty_list() 
            : buildExpensesList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showPopup(context);
        },
        backgroundColor: const Color.fromARGB(255, 37, 113, 226),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  BottomNavigationBar bottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: const Color.fromARGB(255, 37, 113, 226),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      onTap: (int index) async {
        switch (index) {
          case 0:
            final newBalance = await Get.to<int>(const AddBalance());
            if (newBalance != null) {
              setState(() {
                globalBalance += newBalance; // Add the new balance to the existing one
              });
            }
            break;
          case 1:
            final updatedBalance = await Get.to<int>(const BalanceExpenseDetails());
            if (updatedBalance != null) {
              setState(() {
                globalBalance = updatedBalance; // Update to the passed balance
              });
            }
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Add balance',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          label: 'See details',
        ),
      ],
    );
  }

  Padding balanceInfo() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 180,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 37, 113, 226),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Your balance",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      "\$$globalBalance",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Tap here to set a monthly budget and manage your expenses efficiently.",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              SvgPicture.asset(
                "assets/icons/cubes.svg",
                color: Colors.white,
                width: 60,
                height: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Column empty_list() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          "assets/images/money_man.png",
          height: 250,
          width: 250,
        ),
        const Text(
          "This list looks a bit empty",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "Tap on the + button below to add a\nnew income/expense",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w200
          ),
        ),
      ],
    );
  }

  Widget buildExpensesList() {
  return Expanded(
    child: ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: addedTaskModel.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            tileColor: const Color(0xFFF5F5F5),  // Light background color for contrast
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            leading: const Icon(
              Icons.account_balance_wallet,
              color: Color.fromARGB(255, 37, 113, 226),  // Icon for expense, can change based on type
              size: 30,
            ),
            title: Text(
              addedTaskModel[index].description,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            subtitle: Text(
              addedTaskModel[index].date,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "\$${addedTaskModel[index].amount.toString()}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      addedTaskModel.removeAt(index);

                      //This line subtracts the amount of the selected expense from the expense sum
                      expenseSum -= amount;
                      
                    });
                  },
                ),
                Image.asset(
                  addedTaskModel[index].image,
                  width: 40,
                  height: 40,
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

  void _showPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ToggleButtons(
                          isSelected: const [true, false],
                          borderRadius: BorderRadius.circular(8),
                          fillColor: isSelected[0] ? const Color.fromARGB(255, 37, 113, 226) : Colors.white,
                          selectedColor: Colors.white,
                          color: Colors.black,
                          borderWidth: 2,
                          borderColor: const Color.fromARGB(255, 37, 113, 226),
                          selectedBorderColor: const Color.fromARGB(255, 37, 113, 226),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: SizedBox(
                                width: 120,
                                child: Text(
                                  "EXPENSE",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected[0] ? Colors.white : const Color.fromARGB(255, 37, 113, 226),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: SizedBox(
                                width: 120,
                                child: Text(
                                  "INCOME",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected[1] ? Colors.white : const Color.fromARGB(255, 37, 113, 226),
                                  ),
                                ),
                              ),
                            ),
                          ],
                          onPressed: (int index) {
                            setState(() {
                              for (int i = 0; i < isSelected.length; i++) {
                                isSelected[i] == 1;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Listview builder to render images and its texts from ExpenseIncomeModel
                    SizedBox(
                      height: 80,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setModalState(() {
                                expenseIncomeList[index].isSelected = !expenseIncomeList[index].isSelected;
                              });
                            },
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Image.asset(
                                      expenseIncomeList[index].imageName,
                                      height: 40,
                                    ),
                                    if (expenseIncomeList[index].isSelected)
                                      const Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Icon(
                                          Icons.check_box,
                                          color: Colors.blue,
                                        ),
                                      ),
                                  ],
                                ),
                                Text(
                                  expenseIncomeList[index].name,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(width: 15),
                        itemCount: expenseIncomeList.length,
                      ),
                    ),

                    // Create three text forms for description, amount, and date
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        hintText: 'Description (Optional)',
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w300
                        ),
                        prefixIcon: const Icon(Icons.description),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    TextFormField(
                      controller: amountController,
                      decoration: InputDecoration(
                        hintText: 'Amount',
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w300
                        ),
                        prefixIcon: const Icon(Icons.money),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),

                    TextFormField(
                      controller: dateController,
                      decoration: InputDecoration(
                        hintText: 'Date',
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w300
                        ),
                        prefixIcon: const Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101)
                        );
                        if (pickedDate != null) {
                          String formattedDate = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                          setModalState(() {
                            dateController.text = formattedDate;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 10),

                    // Add button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              amount = int.parse(amountController.text);
                              String selectedImage = '';
                              for (var item in widget.expenseIncomeModel) {
                                if (item.isSelected) {
                                  selectedImage = item.imageName;
                                  break;
                                }
                              }

                              // Check if the amount is greater than the available balance
                              if (globalBalance < amount) {
                                // Show snackbar warning if the balance is insufficient
                                Get.snackbar(
                                  "Balance Warning",
                                  "Insufficient balance, please add more balance.",
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: Colors.red.withOpacity(0.5),
                                  colorText: Colors.white,
                                  duration: const Duration(seconds: 2),
                                );
                              } else {
                                // Only subtract and update balance if sufficient balance is available
                                globalBalance -= amount;
                                expenseSum += amount;

                                // Add the task to the model
                                addedTaskModel.add(
                                  AddedTaskModel(
                                    description: descriptionController.text,
                                    amount: amount,
                                    date: dateController.text,
                                    image: selectedImage,
                                  ),
                                );
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            backgroundColor: const Color(0xFF1E5DBF), // Set the background color to match the blue in your image
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0), // Set rounded corners
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(
                              left: 8,
                              right: 8,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Add",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: Colors.white, // Icon color
                                ),
                              ],
                            ),
                          ),
                        ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}