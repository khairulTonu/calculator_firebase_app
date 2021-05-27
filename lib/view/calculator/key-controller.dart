import 'dart:async';
import 'package:calculator_firebase_app/view/calculator/calculator-key.dart';

class KeyEvent {

	KeyEvent(this.key);
	final CalculatorKey key;
}

abstract class KeyController {

	static StreamController streamController = StreamController.broadcast();
	static Stream get _stream => streamController.stream;

	static StreamSubscription listen(Function handler) => _stream.listen(handler as dynamic);
	static void fire(KeyEvent event) => streamController.add(event);

	static dispose() => streamController.close();
}