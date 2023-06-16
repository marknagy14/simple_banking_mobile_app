
import 'package:flutter/material.dart';
import 'package:grip/core/constants.dart';

import '../models/customer_model.dart';
import 'customer_detail.dart';

class CustomerTile extends StatelessWidget {



  final Customer customer;
  final List<Customer> customers;

  const CustomerTile({ required this.customer, required this.customers});


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(
                builder: (context) => CustomerDetailsScreen(customer:customer ,customers:customers,)
            )
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer.name,
                  style: const TextStyle(color: textColor,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                 customer.email,
                  style: const TextStyle(color: textColor),
                ),
              ],
            ),
            const Icon(Icons.arrow_forward_ios_rounded)
          ],
        ),
      ),
    );
  }



  
}