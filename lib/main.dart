import 'package:calculator_firebase_app/controllers/db_controller.dart';
import 'package:calculator_firebase_app/view/authentication/sign-in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calculator_firebase_app/view/calculator/calculator.dart';

void main() async {
	
	WidgetsFlutterBinding.ensureInitialized();
	await Firebase.initializeApp();
	await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
	runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {

	User getCurrentUser() {
		User user = FirebaseAuth.instance.currentUser;
		if(user != null){
			print(user);
			DbController.user = user;
			return user;
		}
		return null;
	}

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			debugShowCheckedModeBanner: false,
			theme: ThemeData(primarySwatch: Colors.teal),
			home: getCurrentUser() != null? Calculator() : SignIn(),
		);
	}
}