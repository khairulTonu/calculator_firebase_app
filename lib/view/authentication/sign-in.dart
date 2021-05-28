import 'package:calculator_firebase_app/controllers/db_controller.dart';
import 'package:calculator_firebase_app/view/generics/button_widget.dart';
import 'package:calculator_firebase_app/view/generics/loading_widget.dart';
import 'package:calculator_firebase_app/view/generics/routing.dart';
import 'package:calculator_firebase_app/view/generics/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignIn extends StatefulWidget {
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  Future<UserCredential> signInWithGoogle() async {
    try {
      await GoogleSignIn().signOut();
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
    catch (e){
      return null;
    }
  }

  final LinearGradient _gradient = LinearGradient(colors: [ Utils.primaryColor, Utils.secondaryColor]);

  bool isLoading = false;

  @override
  void initState() {
    isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: _gradient),
        child: Center(
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: isLoading? LoadingWidget()
            : SocialButton(onPressed: (){
              Utils.checkNetwork().then((bool isNetworkAvailable) {
                if(isNetworkAvailable){
                  setState(() {
                    isLoading = true;
                  });
                  signInWithGoogle().then((UserCredential userCredential) {
                    setState(() {
                      isLoading = false;
                    });
                    if(userCredential != null) {
                      DbController.user = userCredential.user;
                      Navigator.of(context).pushAndRemoveUntil(
                          Routing.routeToCalculator(), (Route<dynamic> route) => false);
                    }
                  }).catchError((e){
                    print(e);
                    setState(() {
                      isLoading = false;
                    });
                  });
                }
                else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No internet!", style: TextStyle(color: Colors.white),), backgroundColor: Colors.red,));
                }
              });
            }, icon: Image.asset("assets/images/google_icon.png"), title: "Sign In with Google"),
          ),
        ),
      ),
    );
  }
}