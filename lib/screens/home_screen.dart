

import 'package:flutter/material.dart';
import '../core/constants.dart';
import 'customers_screen.dart';


class HomeScreen extends StatelessWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Home"), backgroundColor: textColor),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                Container(width: double.infinity, height: 220,
                  child: Image.asset("assets/24176454.jpg", fit: BoxFit.cover,),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "The future of ",
                      style: TextStyle(
                          color: textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Mobile\nBanking",
                      style: TextStyle(
                          color: textColor,
                          fontSize: 50,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "We are a leading financial institution committed to providing exceptional banking services. With a strong focus on customer satisfaction, we offer a wide range of products and solutions tailored to meet your financial needs.",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Align(alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.amber),
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => CustomersScreen()
                            )
                        );
                      },
                      child:
                          Text(
                            "View Customers",
                            style: TextStyle(color: Colors.black),
                          ),

                      ),
                    )
                    ,
                  ),

              ],
            ),
          ),
        ),
    );




  }
}
