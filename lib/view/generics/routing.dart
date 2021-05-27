import 'package:calculator_firebase_app/model/calculation-data.dart';
import 'package:calculator_firebase_app/view/authentication/sign-in.dart';
import 'package:calculator_firebase_app/view/calculator/calculator.dart';
import 'package:calculator_firebase_app/view/calculator/history.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Routing {

  static Route routeToSignIn() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          SignIn(),
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

  static Route routeToCalculator() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          Calculator(),
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

  static Route routeToHistory() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          HistoryView(),
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