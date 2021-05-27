import 'package:calculator_firebase_app/controllers/db_controller.dart';
import 'package:calculator_firebase_app/view/generics/routing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../generics/HexColor.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size fullSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(196, 32, 64, 96),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: TextButton(
              onPressed: (){
                signInWithGoogle().then((UserCredential userCredential) {
                  if(userCredential != null) {
                    DbController.user = userCredential.user;
                    Navigator.of(context).pushAndRemoveUntil(
                        Routing.routeToCalculator(), (Route<dynamic> route) => false);
                  }
                }).catchError((e){
                  print(e);
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(fullSize.width * 0.08),
                  color: Colors.blue,
                ),

                width: fullSize.width,
                height: 55,
                child: Row(
                  children: [
                    SizedBox(width: 10,),
                    Container(
                        height: 30,
                        width: 30,
                        alignment: Alignment.center,
                        child: Image.asset("assets/images/google_icon.png")
                    ),
                    Expanded(
                      child: Container(
                        height: 30,
                        alignment: Alignment.center,
                        child: Text(
                          "Sign In with Google",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.white,
                          ),

                        ),
                      ),
                    )
                  ],
                ),
              )
          ),
        ),
      ),
    );
  }
}