import 'package:calculator_firebase_app/view/calculator/key-symbol.dart';
import 'package:calculator_firebase_app/view/generics/utils.dart';
import 'package:flutter/material.dart';
import 'package:calculator_firebase_app/view/calculator/key-controller.dart';

abstract class Keys {

	static KeySymbol clear = const KeySymbol('C');
	static KeySymbol delete = const KeySymbol('CE');
	static KeySymbol percent = const KeySymbol('%');
	static KeySymbol divide = const KeySymbol('÷');
	static KeySymbol multiply = const KeySymbol('x');
	static KeySymbol subtract = const KeySymbol('-');
	static KeySymbol add = const KeySymbol('+');
	static KeySymbol equals = const KeySymbol('=');
	static KeySymbol decimal = const KeySymbol('.');

	static KeySymbol zero = const KeySymbol('0');
	static KeySymbol one = const KeySymbol('1');
	static KeySymbol two = const KeySymbol('2');
	static KeySymbol three = const KeySymbol('3');
	static KeySymbol four = const KeySymbol('4');
	static KeySymbol five = const KeySymbol('5');
	static KeySymbol six = const KeySymbol('6');
	static KeySymbol seven = const KeySymbol('7');
	static KeySymbol eight = const KeySymbol('8');
	static KeySymbol nine = const KeySymbol('9');
}

class CalculatorKey extends StatelessWidget {

	CalculatorKey({ this.symbol });

	final KeySymbol symbol;
	
	Color get color {

		switch (symbol.type) {

			case KeyType.FUNCTION:
				return symbol.value == "C" || symbol.value == "CE"? Colors.blueAccent : Utils.operatorButtonColor;

			case KeyType.OPERATOR:
				return symbol.value == "="? Utils.equalButtonColor : Utils.operatorButtonColor;

			case KeyType.NUMBER:
			default:
				return Utils.numberButtonColor;
		}
	}

	static dynamic _fire(CalculatorKey key) => KeyController.fire(KeyEvent(key));

	@override
	Widget build(BuildContext context) {

		double size = MediaQuery.of(context).size.width / 4;
		double screenHeight = MediaQuery.of(context).size.height;
		double displayHeight = MediaQuery.of(context).size.height - (size * 5);
		TextStyle style = Theme.of(context).textTheme.headline4.copyWith(color: Colors.white);

		return Padding(
			padding: EdgeInsets.all(2),
		  child: MaterialButton(
		  	minWidth: symbol == Keys.zero? (size - 2)*2 : size - 4,
		  	height: (screenHeight - displayHeight)/5,
		  	shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
		  	color: color,
		  	elevation: 4,
		  	child: Text(symbol.value, style: style),
		  	onPressed: () => _fire(this),
		  ),
		);
	}
}