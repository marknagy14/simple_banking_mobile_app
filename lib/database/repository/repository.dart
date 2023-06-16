import '../../models/customer_model.dart';
import '../../models/transfer_model.dart';

/**
 * abstract class that provide main database query functions that should be overriden by child class
 */
abstract class Repository {
  Future init();

  Future<List<Customer>>? getAllCustomers();

  Future<List<Transfer>>? getAllTransfer();

  Future<Customer>? findCustomerById(int id);

  Stream<List<Customer>>? watchAllCustomers();

  Stream<List<Transfer>>? watchAllTransfer();

  Future<int> insertCustomer(Customer customer);

  Future<int> insertTransfer(Transfer transfer);

  Future updateCustomer(Customer customer, double currentBalance);

  void close();
}
