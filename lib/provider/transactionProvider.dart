import 'package:flutter/foundation.dart';
import '../model/transactionItem.dart';
import '../database/transactionDB.dart';

class TransactionProvider with ChangeNotifier {
  List<TransactionItem> transactions = [];
  TransactionDB? db;

  Future<void> initData() async {
    db = TransactionDB(dbName: 'transactions.db');
    transactions = await db!.loadAllData();
    notifyListeners();
  }

  List<TransactionItem> getTransaction() {
    return transactions;
  }

  void addTransaction(TransactionItem item) async {
    int keyID = await db!.insertDatabase(item);
    item.keyID = keyID;
    transactions.insert(0, item);
    notifyListeners();
  }

  void deleteTransaction(TransactionItem item) async {
    await db!.deleteData(item);
    transactions.remove(item);
    notifyListeners();
  }

  void updateTransaction(TransactionItem item) async {
    await db!.updateData(item);
    int index = transactions.indexWhere((element) => element.keyID == item.keyID);
    if (index != -1) {
      transactions[index] = item;
      notifyListeners();
    }
  }
}