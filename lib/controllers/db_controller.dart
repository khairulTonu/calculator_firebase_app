import 'package:calculator_firebase_app/model/calculation-data.dart';
import 'package:calculator_firebase_app/view/calculator/controller.dart';
import 'package:calculator_firebase_app/view/generics/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class DbController{
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static User user;

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

  static Future<List<CalculationData>> getHistory() async {
    CollectionReference users = fireStore.collection('users');
    QuerySnapshot historyDoc = await users.doc("${user.email}").collection('history').orderBy("id").get();
    List<DocumentSnapshot> historyList = historyDoc.docs ?? [];
    if (historyList.length > 0) {
      try {
        return historyList.map((document) {
          CalculationData data = CalculationData.fromJson(Map<String, dynamic>.from(document.data()));
          return data;
        }).toList();
      } catch (e) {
        print("Exception $e");
        return [];
      }
    }
    return [];
  }

  static Future insertData(CalculationData calculationData) async
  {
    CollectionReference users = fireStore.collection('users');
    List<CalculationData> historyList = await getHistory();
    calculationData.id = historyList.length + 1;
    DateFormat dateFormat = new DateFormat("yyyy-MM-dd hh:mm:ss a");
    DateTime now = DateTime.now();
    String currentTimeStr = dateFormat.format(now);
    calculationData.time = currentTimeStr;
    Utils.checkNetwork().then((bool isNetworkAvailable) {
      if(isNetworkAvailable){
        users.doc("${user.email}").collection("history").doc().set(calculationData.toJson()).whenComplete(() {
          print("Data added to db");
        });
        if(Controller.previousId == null)
        {
          Controller.previousId = calculationData.id;
          Controller.refresh();
        }
      }
    });
  }

}