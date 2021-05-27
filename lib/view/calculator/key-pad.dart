import 'package:flutter/widgets.dart';
import 'package:calculator_firebase_app/view/calculator/calculator-key.dart';

class KeyPad extends StatelessWidget {

	@override
	Widget build(BuildContext context) {
	
		return Column(

			children: [
				Expanded(
				  child: Row(
				  	children: <Widget>[
				  		CalculatorKey(symbol: Keys.clear),
				  		CalculatorKey(symbol: Keys.delete),
				  		CalculatorKey(symbol: Keys.percent),
				  		CalculatorKey(symbol: Keys.divide),
				  	]
				  ),
				),
				Expanded(
				  child: Row(
				  	children: <Widget>[
				  		CalculatorKey(symbol: Keys.seven),
				  		CalculatorKey(symbol: Keys.eight),
				  		CalculatorKey(symbol: Keys.nine),
				  		CalculatorKey(symbol: Keys.multiply),
				  	]
				  ),
				),
				Expanded(
				  child: Row(
				  	children: <Widget>[
				  		CalculatorKey(symbol: Keys.four),
				  		CalculatorKey(symbol: Keys.five),
				  		CalculatorKey(symbol: Keys.six),
				  		CalculatorKey(symbol: Keys.subtract),
				  	]
				  ),
				),
				Expanded(
				  child: Row(
				  	children: <Widget>[
				  		CalculatorKey(symbol: Keys.one),
				  		CalculatorKey(symbol: Keys.two),
				  		CalculatorKey(symbol: Keys.three),
				  		CalculatorKey(symbol: Keys.add),
				  	]
				  ),
				),
				Expanded(
				  child: Row(
				  	children: <Widget>[
				  		CalculatorKey(symbol: Keys.zero),
				  		CalculatorKey(symbol: Keys.decimal),
				  		CalculatorKey(symbol: Keys.equals),
				  	]
				  ),
				)
			]
		);
	}
}