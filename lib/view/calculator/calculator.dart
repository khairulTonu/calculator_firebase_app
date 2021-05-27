import 'package:calculator_firebase_app/controllers/db_controller.dart';
import 'package:calculator_firebase_app/model/calculation-data.dart';
import 'package:calculator_firebase_app/view/calculator/history.dart';
import 'package:calculator_firebase_app/view/generics/routing.dart';
import 'package:flutter/material.dart';
import 'package:calculator_firebase_app/view/calculator/display.dart';
import 'package:calculator_firebase_app/view/calculator/key-controller.dart';
import 'package:calculator_firebase_app/view/calculator/key-pad.dart';
import 'package:calculator_firebase_app/view/calculator/controller.dart';


class Calculator extends StatefulWidget {
	Calculator({ Key key,}) : super(key: key);

	@override
	_CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {

	CalculationData _output;
	final LinearGradient _gradient = const LinearGradient(colors: [ Colors.black26, Colors.black45 ]);

	@override
	void initState() {
		KeyController.listen((event) => Controller.process(event));
		Controller.listen((data) => setState(() { _output = data; }));
		Controller.refresh();
		super.initState();
	}

	@override
	void dispose() {

		KeyController.dispose();
		Controller.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {

		Size screen = MediaQuery.of(context).size;

		double buttonSize = screen.width / 4;
		double displayHeight = screen.height - (buttonSize * 5);
	
		return Scaffold(
			appBar: AppBar(
				backgroundColor: Color.fromARGB(196, 32, 64, 96),
				title: Text("Calculator"),
			),
			drawer: Drawer(
				child: Container(
					decoration: BoxDecoration(gradient: _gradient),
				  child: ListView(
				  	padding: EdgeInsets.zero,
				  	children: <Widget>[
				  		UserAccountsDrawerHeader(
								decoration: BoxDecoration(color: Color.fromARGB(196, 32, 64, 96),),
								accountName: Text("${DbController.userCredential.user.displayName ?? "N/A"}",overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 18),),
								accountEmail: Text("${DbController.userCredential.user.email ?? "N/A"}"),
								currentAccountPicture: CircleAvatar(
									backgroundColor:
									Theme.of(context).platform == TargetPlatform.iOS
											? Colors.blue
											: Colors.white,
									child: Text(
										DbController.userCredential.user.displayName != null? "${DbController.userCredential.user.displayName[0]}" : "A",
										style: TextStyle(fontSize: 40.0),
									),
								),
				  		),
				  		ListTile(
				  			title: Text('History', style: TextStyle(color: Colors.white),),
				  			tileColor: Colors.black12,
				  			trailing: Icon(Icons.arrow_right, color: Colors.white),
				  			leading: Icon(Icons.history, color: Colors.white,),
				  			onTap: () {
				  				Navigator.pop(context);
				  				//Navigator.push(context, Routing.routeToHistory());
									navigateToHistory(context);
				  				},
				  		),
				  		SizedBox(height: 5,),
				  		ListTile(
				  			title: Text('Log Out', style: TextStyle(color: Colors.white)),
								tileColor: Colors.black12,
								trailing: Icon(Icons.arrow_right, color: Colors.white),
				  			leading: Icon(Icons.arrow_back, color: Colors.white),
				  			onTap: () {
				  				// Update the state of the app.
				  				// ...
				  				Navigator.pop(context);

				  			},
				  		),
				  	],
				  ),
				),
			),
			backgroundColor: Color.fromARGB(196, 32, 64, 96),
			body: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				children: <Widget>[
					Display(value: _output, height: displayHeight),
					Expanded(child: KeyPad())
				]
			),
		);
	}
	void navigateToHistory(BuildContext context) async {
		CalculationData calculationData = await Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryView()));
		if(calculationData != null)
			{
				Controller.inputEq = calculationData.equation;
				Controller.result = calculationData.result;
				Controller.previousId = calculationData.id;
				Controller.refresh();
			}
	}
}