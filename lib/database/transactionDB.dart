import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import '../model/transactionItem.dart'; // แก้ไข path ให้ถูกต้อง

class TransactionDB {
  String dbName;

  TransactionDB({required this.dbName});

  Future<Database> openDatabase() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbLocation = join(appDir.path, dbName);

    DatabaseFactory dbFactory = databaseFactoryIo;
    Database db = await dbFactory.openDatabase(dbLocation);
    return db;
  }

  Future<int> insertDatabase(TransactionItem item) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('expense');

    int keyID = await store.add(db, {
      'title': item.title,
      'amount': item.amount,
      'date': item.date?.toIso8601String(),
    });

    await db.close();
    return keyID;
  }

  Future<List<TransactionItem>> loadAllData() async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('expense');

    var snapshot = await store.find(db,
        finder: Finder(sortOrders: [SortOrder('date', false)]));

    List<TransactionItem> transactions = [];

    for (var record in snapshot) {
      TransactionItem item = TransactionItem(
          keyID: record.key,
          title: record['title'].toString(),
          amount: double.parse(record['amount'].toString()),
          date: record['date'] != null ? DateTime.parse(record['date'].toString()) : null);
      transactions.add(item);
    }
    await db.close();
    return transactions;
  }

  Future<void> deleteData(TransactionItem item) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('expense');
    await store.delete(db,
        finder: Finder(filter: Filter.equals(Field.key, item.keyID)));
    await db.close();
  }

  Future<void> updateData(TransactionItem item) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('expense');

    await store.update(db, {
      'title': item.title,
      'amount': item.amount,
      'date': item.date?.toIso8601String()
    }, finder: Finder(filter: Filter.equals(Field.key, item.keyID)));

    await db.close();
  }
}