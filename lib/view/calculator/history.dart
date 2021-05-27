import 'package:calculator_firebase_app/controllers/db_controller.dart';
import 'package:calculator_firebase_app/model/calculation-data.dart';
import 'package:calculator_firebase_app/view/generics/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HistoryView extends StatefulWidget {
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {

  Widget listItem(BuildContext context, CalculationData calculationData)
  {
    return GestureDetector(
      onTap: (){
        Navigator.pop(context, calculationData);
      },
      child: Card(
        color: Color.fromARGB(255, 128, 128, 128),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text("ID: ${calculationData.id ?? "N/A"}", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),),
                      Text("Previous-ID: ${calculationData.previousId ?? "N/A"}", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),),
                    ],),
                    SizedBox(height: 5,),
                    Row(children: [
                      Icon(Icons.access_time, color: Colors.amber, size: 16,),
                      SizedBox(width: 5,),
                      Text("${calculationData.time}", style: TextStyle(color: Colors.white, fontSize: 12),),
                    ],),
                    SizedBox(height: 5,),
                    Text("${calculationData.equation}=${calculationData.result}", style: TextStyle(color: Colors.white, fontSize: 18),),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 24, color: Colors.white,),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(196, 32, 64, 96),
        title: Text("History"),
      ),
      backgroundColor: Color.fromARGB(32, 32, 32, 32),
      body: Container(
        padding: EdgeInsets.only(top: 5, bottom: 5),
        child: FutureBuilder<List<CalculationData>>(
          future: DbController.getHistory(),
          builder: (ctx, snapshot) {
            List<CalculationData> historyList = snapshot.data;
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                if(snapshot.hasError) {
                  return Center(
                    child: Text("Some error occurred!", style: TextStyle(color: Colors.white, fontSize: 18),),
                  );
                }
                return historyList != null && historyList.length > 0?  ListView.builder(
                  itemCount: historyList.length,
                    itemBuilder: (ctx, index){
                      return listItem(context, historyList[index]);
                    }
                ) : Center(
                      child: Text("No history available!", style: TextStyle(color: Colors.white, fontSize: 18),),
                    );
              default:
                return Center(child: LoadingWidget());
            }
          },
        ),
      ),
    );
  }

}