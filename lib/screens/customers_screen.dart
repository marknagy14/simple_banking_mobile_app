import 'package:flutter/material.dart';
import 'package:grip/core/constants.dart';
import 'package:grip/cubit/app_cubit.dart';
import 'package:grip/cubit/app_state.dart';
import 'package:grip/screens/customer_tile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/customer_model.dart';

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state)
    {
      var appCubit = AppCubit.get(context);
      return FutureBuilder(
          future: appCubit.repository.getAllCustomers(),
          builder: (BuildContext context,
              AsyncSnapshot<List<Customer>?> snapshot) {
            if (!snapshot.hasData) {
              return const Center (child: CircularProgressIndicator());
            }
            else {
              final customers = snapshot.data ??
                  []; // provide a default value if snapshot.data is null
              return Scaffold(
                appBar: AppBar(
                  title: Text("View Customers"),
                  backgroundColor: textColor,
                ),
                body: ListView.separated(
                    itemBuilder: (context, index) => CustomerTile( customer: customers[index],
                      customers: customers,),
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: customers.length)
                ,
              );
            }
          }
    );},
    listener: (context,state){});
    }
}
