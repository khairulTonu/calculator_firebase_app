import 'package:calculator_firebase_app/model/calculation-data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DbController{
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static String email;

  static Future<bool> checkUserExist(String docID) async {
    bool exists = false;
    try {
      await fireStore.doc("users/$docID").get().then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  static Future insertData(CalculationData calculationData) async
  {
    CollectionReference users = fireStore.collection('users');
    QuerySnapshot historyDoc = await users.doc("$email").collection('history').get();
    List<DocumentSnapshot> historyList = historyDoc.docs ?? [];
    calculationData.id = "${historyList.length + 1}";
    DateFormat dateFormat = new DateFormat("yyyy-MM-dd hh:mm:ss a");
    DateTime now = DateTime.now();
    String currentTimeStr = dateFormat.format(now);
    calculationData.time = currentTimeStr;
    users.doc("$email").collection("history").doc().set(calculationData.toJson()).whenComplete(() {
      print("Data added to db");
    });
  }

}