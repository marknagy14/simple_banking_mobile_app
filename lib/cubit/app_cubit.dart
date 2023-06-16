import 'package:bloc/bloc.dart';


import '../database/repository/repository.dart';
import '../models/customer_model.dart';
import '../models/transfer_model.dart';
import 'app_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppCubit extends Cubit<AppStates> {
  final Repository repository;
  AppCubit({required this.repository}) : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  // List<Widget> screens = [
  //   const AllCustomersScreen(),
  //   const AllTransfersScreen(),
  // ];

  List<String> titles = ['New Tasks', 'Done Tasks', 'Archived Tasks'];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeNaveBottomBarState());
  }


  List<Transfer> transfers = [];
  getAllTransfers () {
    repository.getAllTransfer()?.then((value) {
      transfers = value;
    });
  }

  makeTransfer(Transfer transfer, Customer sender, Customer receiver) {

    //sender.currentBalance -= transfer.transferAmount;
    repository.updateCustomer(
        sender, sender.currentBalance - transfer.transferAmount).then((
        value) {
      getAllTransfers();
      emit(BankDbTransferAddedState());
    });

    repository.updateCustomer(
        receiver, receiver.currentBalance + transfer.transferAmount).then((
        value) {
      //repository.getAllCustomers();
      emit(BankDbTransferAddedState());
    });

    repository.insertTransfer(transfer);
  }

  Customer? dropDawnValue;
  changeDropDownValue(Customer? newValue) {
    dropDawnValue = newValue;
    emit(ChangeDropDownValue());
  }

  Future<List<Customer?>> getSenderReceiverById(int senderId, int receiverId) async {
    return [ await repository.findCustomerById(senderId),  await repository.findCustomerById(receiverId)];
  }

}
