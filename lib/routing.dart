import 'package:calculator_firebase_app/calculator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Routing {

  static Route routeToCalculator(UserCredential userCredential) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          Calculator(userCredential: userCredential,),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var tween = Tween(begin: begin, end: end);
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}