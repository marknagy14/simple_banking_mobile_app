import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/constants.dart';
import '../cubit/app_cubit.dart';
import '../cubit/app_state.dart';
import '../models/customer_model.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../models/transfer_model.dart';


class CustomerDetailsScreen extends StatelessWidget {
  final Customer customer;
  final List<Customer> customers;

  CustomerDetailsScreen({
    required this.customer,
    required this.customers,
    Key? key
  }) : super(key: key);


  var transferAmountController = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(builder:(context,state){
      var appCubit = AppCubit.get(context);
      return Scaffold(
        appBar: AppBar(title: Text("Info"),backgroundColor: textColor,),

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Align(alignment: Alignment.centerLeft,
                  child: Row(
                    children: [Icon(Icons.person),
                      Text(
                        customer.name,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(alignment: Alignment.centerLeft,
                  child: Row(
                    children: [Icon(Icons.email),
                      Text(
                        customer.email,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Container(
                    height: 100,
                    width: 400,
                    decoration: BoxDecoration(
                      color: Colors.white38,
                      borderRadius: BorderRadius.circular(10), // Adjust the value to change the roundness
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes the shadow position
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Balance",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "${formatAmount(customer.currentBalance)}",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),

                ),SizedBox(height: 80,),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.amber),
                  ),
                  onPressed: () {
                      enterTransferDetails(appCubit, context, customers, customer);
                  },
                  child:
                  Text(
                    "New Transfer",
                    style: TextStyle(color: Colors.black),
                  ),

                )

              ],
            ),
          ),
        ),
      );
    }   ,listener:(context,state){} );
  }

  String formatAmount(double amount) {
    final formatter = NumberFormat("#,##0.00", "en_US");
    return formatter.format(amount) + " \$";
  }

  enterTransferDetails(AppCubit appCubit, context, List<Customer> customers, Customer sender,) {
    return showMaterialModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(15.0),
              height: MediaQuery.of(context).viewInsets.bottom +
                  295,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonHideUnderline(
                        child: DropdownButtonFormField2(
                          items: customers
                              .map((Customer item) => DropdownMenuItem(
                            value: item,
                            child: Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )).toList(),
                          value: appCubit.dropDawnValue,
                          onSaved: (Customer? value) {
                            appCubit.changeDropDownValue(value);
                          },
                          onChanged: (Customer? value) {
                            appCubit.changeDropDownValue(value);
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please Select valid customer';
                            } else if (value == customer) {
                              return 'please transfer to anyone other than yourself' ;
                            }
                            return null;
                          },
                          isExpanded: true,
                          hint: Row(
                            children: const [
                              Icon(
                                Icons.person_outline,
                                size: 16,
                                color: Colors.yellow,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                child: Text(
                                  'Select Reciever',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellow,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          icon: const Icon(
                            Icons.arrow_forward_ios_outlined,
                          ),
                          iconSize: 14,
                          iconEnabledColor: Colors.white,
                          iconDisabledColor: Colors.grey,
                          buttonHeight: 50,
                          buttonWidth: 160,
                          buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                          buttonDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.black26,
                            ),
                            color: textColor,
                          ),
                          buttonElevation: 2,
                          itemHeight: 40,
                          itemPadding: const EdgeInsets.only(left: 14, right: 14),
                          dropdownMaxHeight: 200,
                          dropdownWidth: 200,
                          dropdownPadding: null,
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: textColor,
                          ),
                          dropdownElevation: 8,
                          scrollbarRadius: const Radius.circular(40),
                          scrollbarThickness: 6,
                          scrollbarAlwaysShow: true,
                          offset: const Offset(-20, 0),
                        )
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                        controller: transferAmountController,
                        decoration: const InputDecoration(
                          labelText: 'amount',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Amount can\'t be empty';
                          } else {
                            double? amount = double.tryParse(value);
                            if (amount == null) {
                              return 'Invalid amount';
                            } else if (amount <= 0) {
                              return 'Enter a value greater than 0';
                            } else if (amount >= customer.currentBalance) {
                              return 'Insufficient balance';
                            }
                          }
                          return null;
                        }
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    MaterialButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()){
                          if(appCubit.dropDawnValue != null && appCubit.dropDawnValue != customer) {
                            appCubit.makeTransfer(
                                Transfer(
                                    receiverId: appCubit.dropDawnValue!.id!,
                                    senderId: sender.id!,
                                    transferAmount:
                                    double.parse(transferAmountController.text)),
                                sender,
                                appCubit.dropDawnValue!);
                            sender.currentBalance -= double.parse(transferAmountController.text);
                            appCubit.changeDropDownValue(null);
                            transferAmountController.clear();
                            Navigator.pop(context);
                            showSnackBar(context);
                          } else {appCubit.changeDropDownValue(null);}
                        }
                      },
                      child: const Text('Transfer Money'),
                      elevation: 5,
                      color: Colors.amber,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        expand: false,
        isDismissible: false
    );
  }

  void showSnackBar(context) {
    final snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text("Transfer was made successfully!"),
          Icon(Icons.done_outline_rounded, color: Colors.greenAccent,)
        ],
      ),

    );
    ScaffoldMessenger.of(context)
        .showSnackBar(snackBar);

  }
}


