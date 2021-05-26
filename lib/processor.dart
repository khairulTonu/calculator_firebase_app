import 'dart:async';
import 'package:calculator_firebase_app/calculator-key.dart';
import 'package:calculator_firebase_app/controllers/db_controller.dart';
import 'package:calculator_firebase_app/key-controller.dart';
import 'package:calculator_firebase_app/key-symbol.dart';
import 'package:calculator_firebase_app/model/calculation-data.dart';

abstract class Processor {

	static KeySymbol _operator;
	static String _valA = '0';
	static String _valB = '0';
	static String inputEq = "0";
	static String _result;
	static bool isDecimal = false;

	static StreamController _controller = StreamController();
	static Stream get _stream => _controller.stream;

	static StreamSubscription listen(Function handler) => _stream.listen(handler);
	static void refresh() => _fire(_calculationData);

	static void _fire(CalculationData data) => _controller.add(_calculationData);

	static CalculationData get _calculationData => CalculationData(equation: _equation, result: _result);

	// static String get _equation => _valA
	// 	+ (_operator != null ? ' ' + _operator.value : '')
	// 	+ (_valB != '0' ? ' ' + _valB : '');

	static String get _equation => inputEq;

	static dispose() => _controller.close();

	static process(dynamic event) {
		
		CalculatorKey key = (event as KeyEvent).key;
		switch(key.symbol.type) {

			case KeyType.FUNCTION:
				return handleFunction(key);

			case KeyType.OPERATOR:
				return handleOperator(key);

			case KeyType.INTEGER:
				return handleInteger(key);
		}
	}

	static void handleFunction(CalculatorKey key) {

		//if (_valA == '0') { return; }
		if (_result != null) { _condense(); }

		Map<KeySymbol, dynamic> table = {
			Keys.clear: () => _clear(),
			Keys.delete: () => delete(),
			Keys.percent: () => _percent(),
			Keys.decimal: () => _decimal(),
		};

		table[key.symbol]();
		refresh();
	}

	static void handleOperator(CalculatorKey key) {
		isDecimal = false;
		//if (_valA == '0') { return; }
		if (key.symbol == Keys.equals) { return evaluateExpression(); }
		if (_result != null) { _condense(); }
		if(inputEq.isNotEmpty && !isDigit(inputEq[inputEq.length-1])){
			delete();
		}
		if(inputEq.isEmpty) {
			inputEq = "0";
		}
		inputEq = "$inputEq${key.symbol}";
		refresh();
	}

	static void handleInteger(CalculatorKey key) {
		String val = key.symbol.value;
		if(inputEq == "0") { delete(); }
		if(inputEq.length > 2 && isOperator(inputEq[inputEq.length - 2]) && inputEq[inputEq.length -1] == "0") {delete();}
		inputEq = "$inputEq$val";
		// if (_operator == null) { _valA = (_valA == '0') ? val : _valA + val; }
		// else { _valB = (_valB == '0') ? val : _valB + val; }
		refresh();
	}

	static void _clear() {
		//_valA = _valB = '0';
		_operator = _result = null;
		inputEq = "0";
		isDecimal = false;
	}

	static void delete() {
		if(inputEq.isNotEmpty) {
			if(inputEq[inputEq.length -1] == "."){
				isDecimal = false;
			}
			inputEq = inputEq.substring(0, inputEq.length - 1);
			refresh();
		}
	}

	static void _sign() {

		if (_valB != '0') { _valB = (_valB.contains('-') ? _valB.substring(1) : '-' + _valB); }
		else if (_valA != '0') { _valA = (_valA.contains('-') ? _valA.substring(1) : '-' + _valA); }
	}

	static String calcPercent(String x) => (double.parse(x) / 100).toString();

	static void _percent() {

		if (_valB != '0' && !_valB.contains('.')) { _valB = calcPercent(_valB); }
		else if (_valA != '0' && !_valA.contains('.')) { _valA = calcPercent(_valA); }
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

	static void _calculate() {

		if (_operator == null || _valB == '0') { return; }

		Map<KeySymbol, dynamic> table = {
			Keys.divide: (a, b) => (a / b),
			Keys.multiply: (a, b) => (a * b),
			Keys.subtract: (a, b) => (a - b),
			Keys.add: (a, b) => (a + b)
		};

		double result = table[_operator](double.parse(_valA), double.parse(_valB));
		String str = result.toString();

		while ((str.contains('.') && str.endsWith('0')) || str.endsWith('.')) { 
			str = str.substring(0, str.length - 1); 
		}

		_result = str;
		refresh();
	}

	static int precedence(String op){
		if(op == '+'||op == '-')
			return 1;
		if(op == 'x'||op == '÷')
			return 2;
		return 0;
	}

// Function to perform arithmetic operations.
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
			_result = values.last.toString();
			refresh();
			CalculationData calculationData = CalculationData(equation: _equation, result: _result);
			DbController.insertData(calculationData);
		}

	}

	static void _condense() {

		_valA = _result;
		_valB = '0';
		_result = _operator = null;
	}
}