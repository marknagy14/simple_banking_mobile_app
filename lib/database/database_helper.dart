import 'package:sqlbrite/sqlbrite.dart';
import 'package:synchronized/synchronized.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlbrite/sqlbrite.dart';
import 'package:synchronized/synchronized.dart';

import '../models/customer_model.dart';
import '../models/transfer_model.dart';


class DatabaseHelper {

  static const _databaseName = 'bank_db.db';

  static const _databaseVersion = 1;

  static const customerTable = 'customer';
  static const transferTable = 'transfer';
  static const customerId = 'customerId';
  static const transferId = 'transferId';

  static late BriteDatabase _streamDatabase;

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static var lock = Lock();

  static Database? _database;


  //create database tables
  Future _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE $customerTable (
          $customerId INTEGER PRIMARY KEY,
          name TEXT,
          email TEXT,
          currentBalance REAL)
          ''');

    await db.execute('''CREATE TABLE $transferTable (
          $transferId INTEGER PRIMARY KEY,
          receiverId INTEGER,
          senderId INTEGER,
          transferAmount REAL)
          ''');
  }

  /**
  * if database exists open it ,else create it*
   *this function sets up a database by determining the file path,
   * opening or creating the database, and returning a Future that resolves to the initialized database object.
   **/
  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }


  /**
   * this getter method ensures that the database is lazily initialized and returns the initialized database instance.
   * It also ensures thread safety by using a lock to prevent concurrent access to the data while initializing the database.
   **/
  Future<Database> get database async {
    if (_database != null) return _database!;
    await lock.synchronized(
          () async {
        if (_database == null) { //Within the synchronized block, it checks again if _database is null. This additional check is necessary because another thread might have initialized the _database while the current thread was waiting to enter the synchronized block.
          _database = await _initDatabase();
          _streamDatabase = BriteDatabase(_database!);
        }
      },
    );
    return _database!;
  }


  /**
   * this getter method ensures that the database is initialized before returning the _streamDatabase.
   * It waits for the completion of the database getter method to ensure that the database is fully initialized and then returns the _streamDatabase.
   */
  Future<BriteDatabase> get streamDatabase async {
    await database;
    return _streamDatabase;
  }


  /**
   *  takes a list of maps representing customer data,
   *  iterates over each map,
   *  converts them into Customer objects using the fromJson method,
   *  and returns a list of the parsed Customer objects.
   */
  List<Customer> parseCustomer(List<Map<String, dynamic>> customerMaps) {
    final List<Customer> customers = [];

    for (var customerMap in customerMaps) {
      final customer = Customer.fromJson(customerMap);
      customers.add(customer);
    }

    return customers;
  }

  List<Transfer> parseTransfer(List<Map<String, dynamic>> transferMaps) {
    final List<Transfer> transfers = [];

    for (var transferMap in transferMaps) {
      final transfer = Transfer.fromJson(transferMap);
      transfers.add(transfer);
    }

    return transfers;
  }


  /**
   *  retrieves the BriteDatabase instance, queries the customerTable,
   *  parses the resulting maps into a list of Customer objects,
   *  checks if the list is empty,
   *  and optionally inserts dummy data.
   *  It then returns the list of Customer objects as a future.
   */
  Future<List<Customer>> getAllCustomers() async {
    final db = await instance.streamDatabase;
    final customerMaps = await db.query(customerTable);
    final List<Customer> customers = parseCustomer(customerMaps);
    if(customers.isEmpty) insertDummyData();
    return customers;
  }

  Future<List<Transfer>> getAllTransfers() async {
    final db = await instance.streamDatabase;
    final transferMaps = await db.query(transferTable);
    final transfers = parseTransfer(transferMaps);
    return transfers;
  }

  /**
   *  sets up a stream that continuously emits updates to the list of Customer objects based on changes in the customerTable in the database.
   *  It uses the BriteDatabase instance to create and execute a query, and then maps the query result to a list of Customer objects.
   *  The function uses an asynchronous generator to yield the updated list of Customer objects whenever changes occur.
   */
  Stream<List<Customer>> watchAllCustomers() async* {
    final db = await instance.streamDatabase;
    yield* db.createQuery(customerTable).mapToList((row) {
      return Customer.fromJson(row);
    });
  }


  Stream<List<Transfer>> watchAllTransfer() async* {
    final db = await instance.streamDatabase;
    yield* db.createQuery(transferTable).mapToList((row) => Transfer.fromJson(row));
  }

  //read
  Future<Customer> findCustomerById(int id) async {
    final db = await instance.streamDatabase;
    final customerMaps =
    await db.query(customerTable, where: 'customerId = $id');
    final List<Customer> customers = parseCustomer(customerMaps);
    return customers.first;
  }

  /**
   * inserts a row of data into the specified table in the database by calling the insert method on the BriteDatabase instance.
   * It returns a Future<int> representing the result of the insertion operation.
   */
  Future<int> insert(String table, Map<String, dynamic> row) async {
    final db = await instance.streamDatabase;
    return db.insert(table, row);
  }

  Future<int> insertCustomer(Customer customer) {
    return insert(customerTable, customer.toJson());
  }

  Future<int> insertTransfer(Transfer transfer) {
    return insert(transferTable, transfer.toJson());
  }

  //update only the current balance
  Future updateCustomer(Customer customer, double currentBalance) async {
    final db = await instance.streamDatabase;
    return db.rawUpdate('''
     UPDATE $customerTable SET currentBalance = $currentBalance WHERE $customerId = ${customer.id}
     ''');
  }

  Future insertDummyData() async {
    insertCustomer(Customer(
        name: "Mark Nagy Georgy",
        email: "mark.nagy@gmail.com",
        currentBalance: 3000.0));
    insertCustomer(Customer(
        name: "Mahdy soliman",
        email: "mahdy567@gmail.com",
        currentBalance: 5000.0));
    insertCustomer(Customer(
        name: "Mina Wagdy",
        email: "minaw221@gmail.com",
        currentBalance: 4550.0));
    insertCustomer(Customer(
        name: "Rania Hossam",
        email: "ranoshaa29@gmail.com",
        currentBalance: 9500.0));
    insertCustomer(Customer(
        name: "Mazen Walid",
        email: "mazen23@gmail.com",
        currentBalance: 7350.0));
    insertCustomer(Customer(
        name: "Nada Waleed",
        email: "nada65@gmail.com",
        currentBalance: 3950.0));
    insertCustomer(Customer(
        name: "Ahmed Hatem",
        email: "ahmed57@gmail.com",
        currentBalance: 5900.0));
    insertCustomer(Customer(
        name: "Sara Mahdy",
        email: "sarato50@gmail.com",
        currentBalance: 3370.0));
    insertCustomer(Customer(
        name: "Walid Nasser",
        email: "walidf5@gmail.com",
        currentBalance: 7500.0));
    insertCustomer(Customer(
        name: "Roshdy Roshdy",
        email: "roshdyy75@gmail.com",
        currentBalance: 9500.0));
    getAllCustomers();
  }

  void close() {
    _streamDatabase.close();
  }











}
