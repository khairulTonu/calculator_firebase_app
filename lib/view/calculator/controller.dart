import 'dart:async';
import 'package:calculator_firebase_app/view/calculator/calculator-key.dart';
import 'package:calculator_firebase_app/controllers/db_controller.dart';
import 'package:calculator_firebase_app/view/calculator/key-controller.dart';
import 'package:calculator_firebase_app/model/calculation-data.dart';
import 'package:calculator_firebase_app/view/calculator/key-symbol.dart';

abstract class Controller {
	
	static String inputEq = "0";
	static int previousId;
	static String result;
	static bool isDecimal = false;

	static StreamController streamController = StreamController.broadcast();
	static Stream get _stream => streamController.stream;

	static StreamSubscription listen(Function handler) => _stream.listen(handler);
	static void refresh() => _fire(_calculationData);

	static void _fire(CalculationData data) => streamController.add(_calculationData);

	static CalculationData get _calculationData => CalculationData(equation: _equation, result: result, previousId: previousId);

	static String get _equation => inputEq;

	static dispose() {
		inputEq = "0";
		result = null;
		previousId = null;
		isDecimal = false;
		refresh();
		streamController.close();
	}

	static process(dynamic event) {

		CalculatorKey key = (event as KeyEvent).key;
		switch(key.symbol.type) {

			case KeyType.FUNCTION:
				return handleFunction(key);

			case KeyType.OPERATOR:
				return handleOperator(key);

			case KeyType.NUMBER:
				return handleNumber(key);
		}
	}

	static void handleFunction(CalculatorKey key) {
		if (result != null) { _condense(); }

		Map<KeySymbol, dynamic> table = {
			Keys.clear: () => _clear(),
			Keys.delete: () => _delete(),
			Keys.percent: () => _percent(),
			Keys.decimal: () => _decimal(),
		};

		table[key.symbol]();
		refresh();
	}

	static void handleOperator(CalculatorKey key) {
		isDecimal = false;
		if (result != null) { _condense(); }
		if (key.symbol == Keys.equals) { return evaluateExpression(); }
		if(inputEq.isNotEmpty && !isDigit(inputEq[inputEq.length-1])){
			_delete();
		}
		if(inputEq.isEmpty) {
			inputEq = "0";
		}
		inputEq = "$inputEq${key.symbol}";
		refresh();
	}

	static void handleNumber(CalculatorKey key) {
		String val = key.symbol.value;
		if (result != null) { _condense(); }
		if(inputEq == "0") { _delete(); }
		if(inputEq.length > 2 && isOperator(inputEq[inputEq.length - 2]) && inputEq[inputEq.length -1] == "0") {_delete();}
		inputEq = "$inputEq$val";
		refresh();
	}

	static void _clear() {
		result = previousId = null;
		inputEq = "0";
		isDecimal = false;
	}

	static void _delete() {
		if(inputEq.isNotEmpty) {
			if(inputEq[inputEq.length -1] == "."){
				isDecimal = false;
			}
			inputEq = inputEq.substring(0, inputEq.length - 1);
			refresh();
		}
		if(inputEq.isEmpty){
			result = previousId = null;
			isDecimal = false;
			refresh();
		}
	}

	static void _percent() {
		int index = inputEq.length - 1;
		String extractNumber = "";
		while(inputEq.isNotEmpty && (isDigit(inputEq[index]) || inputEq[index] == ".")) {
			extractNumber = "$extractNumber${inputEq[index]}";
			_delete();
			index = inputEq.length - 1;
		}
		if(extractNumber.isNotEmpty){
			extractNumber = extractNumber.split('').reversed.join();
			inputEq = "$inputEq${(double.parse(extractNumber) / 100)}";
			refresh();
		}
	}

	static void _decimal() {
		if(!isDecimal)
			{
				if(inputEq.isNotEmpty && isDigit(inputEq[inputEq.length -1]))
				{
					inputEq = "$inputEq.";
					isDecimal = true;
				}
				else {
					inputEq = "${inputEq}0.";
					isDecimal = true;
				}
			}
	}

	static int precedence(String op){
		if(op == '+'||op == '-')
			return 1;
		if(op == 'x'||op == '÷')
			return 2;
		return 0;
	}

	static double applyOp(double a, double b, String op){
		switch(op){
			case '+': return a + b;
			case '-': return a - b;
			case 'x': return a * b;
			case '÷': return a / b;
		}
		return 0;
	}

	static bool isDigit(String char){
		if("0".compareTo(char) <= 0 && "9".compareTo(char) >=0) {
			return true;
		}
		return false;
	}

	static bool isOperator(String char){
		switch(char){
			case '+': return true;
			case '-': return true;
			case 'x': return true;
			case '÷': return true;
		}
		return false;
	}

	static void evaluateExpression()
	{
		String userInput = _equation;
		List<double> values = [];
		List<String> ops = [];
		if(userInput.isNotEmpty && isDigit(userInput[userInput.length-1])){
			for (int i = 0; i < userInput.length; i++)
			{
				String numberStr = "";
				if(isDigit(userInput[i]) || userInput[i] == "."){
					while(i<userInput.length && (("0".compareTo(userInput[i]) <= 0 && "9".compareTo(userInput[i]) >=0) || userInput[i] == ".")){
						numberStr = "$numberStr${userInput[i]}";
						i++;
					}
					if(numberStr.isNotEmpty){
						values.add(double.parse(numberStr));
					}
					i--;
				}
				else {
					while(ops.isNotEmpty && precedence(ops.last) >= precedence(userInput[i])) {
						print(ops);
						double val2 = values.last;
						values.removeLast();
						double val1 = values.last;
						values.removeLast();
						String op = ops.last;
						ops.removeLast();
						values.add(applyOp(val1, val2, op));
						print(values);
					}
					ops.add(userInput[i]);
				}
			}
			while(ops.isNotEmpty) {
				print(ops);
				double val2 = values.last;
				values.removeLast();
				double val1 = values.last;
				values.removeLast();
				String op = ops.last;
				ops.removeLast();
				values.add(applyOp(val1, val2, op));
				print(values);
			}
			num ans = values.last;
			if(ans == ans.truncate()){
				ans = ans.toInt();
			}
			result = ans.toString();
			refresh();
			saveToDb();
		}

	}

	static void saveToDb() async{
		CalculationData calculationData = CalculationData(equation: _equation, result: result, previousId: previousId);
		await DbController.insertData(calculationData);
	}

	static void _condense() {
		if(result != null) inputEq = "$result";
		result = null;
	}
}