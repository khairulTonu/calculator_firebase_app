import 'package:calculator_firebase_app/model/calculation-data.dart';
import 'package:flutter/material.dart';

class Display extends StatelessWidget {

	Display({ Key key, this.value, this.height }) : super(key: key);

	final CalculationData value;
	final double height;

	CalculationData get _output => value;
	double get _margin => (height / 10);

	final LinearGradient _gradient = const LinearGradient(colors: [ Colors.black26, Colors.black45 ]);

	@override
	Widget build(BuildContext context) {
		
		TextStyle style = Theme.of(context).textTheme.headline5
			.copyWith(color: Colors.white, fontWeight: FontWeight.w200);

		return Container(
			padding: EdgeInsets.only(top: 0, bottom: 0),
			constraints: BoxConstraints.expand(height: height),
			child: Container(
				padding: EdgeInsets.fromLTRB(32, 32, 32, 32),
				constraints: BoxConstraints.expand(height: height - (_margin)),
				decoration: BoxDecoration(gradient: _gradient),
				child: Text(_output != null && _output.result != null ? "${_output?.equation ?? "0"}\n=${_output?.result ?? "0"}":"${_output?.equation ?? "0"}", style: style, textAlign: TextAlign.right, )
			)
		);
	}
}
