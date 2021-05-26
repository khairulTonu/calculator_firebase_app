import 'package:calculator_firebase_app/model/calculation-data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:calculator_firebase_app/display.dart';
import 'package:calculator_firebase_app/key-controller.dart';
import 'package:calculator_firebase_app/key-pad.dart';
import 'package:calculator_firebase_app/processor.dart';


class Calculator extends StatefulWidget {
	final UserCredential userCredential;
	Calculator({ Key key,  this.userCredential }) : super(key: key);

	@override
	_CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {

	CalculationData _output;
	final LinearGradient _gradient = const LinearGradient(colors: [ Colors.black26, Colors.black45 ]);

	@override
	void initState() {
		
		KeyController.listen((event) => Processor.process(event));
		Processor.listen((data) => setState(() { _output = data; }));
		Processor.refresh();
		super.initState();
	}

	@override
	void dispose() {

		KeyController.dispose();
		Processor.dispose();
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
				// Add a ListView to the drawer. This ensures the user can scroll
				// through the options in the drawer if there isn't enough vertical
				// space to fit everything.
				child: Container(
					decoration: BoxDecoration(gradient: _gradient),
				  child: ListView(
				  	// Important: Remove any padding from the ListView.
				  	padding: EdgeInsets.zero,
				  	children: <Widget>[
				  		UserAccountsDrawerHeader(
								decoration: BoxDecoration(color: Color.fromARGB(196, 32, 64, 96),),
								accountName: Text("${widget.userCredential.user.displayName ?? "N/A"}",overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 18),),
								accountEmail: Text("${widget.userCredential.user.email ?? "N/A"}"),
								currentAccountPicture: CircleAvatar(
									backgroundColor:
									Theme.of(context).platform == TargetPlatform.iOS
											? Colors.blue
											: Colors.white,
									child: Text(
										widget.userCredential.user.displayName != null? "${widget.userCredential.user.displayName[0]}" : "A",
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
				  				// Update the state of the app.
				  				// ...
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
}