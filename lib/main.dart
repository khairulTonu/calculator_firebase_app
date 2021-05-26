import 'package:calculator_firebase_app/sign-in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calculator_firebase_app/calculator.dart';

void main() async {
	
	WidgetsFlutterBinding.ensureInitialized();
	await Firebase.initializeApp();
	await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
	runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {

	@override
	Widget build(BuildContext context) {

		return MaterialApp(
			theme: ThemeData(primarySwatch: Colors.teal),
			//home: Calculator(),
			home: SignIn(),
		);
	}
}