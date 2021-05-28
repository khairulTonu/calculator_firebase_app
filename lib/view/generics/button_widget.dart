import 'package:calculator_firebase_app/view/generics/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget{
  final Function onPressed;
  final Widget icon;
  final String title;
  SocialButton({@required this.onPressed, @required this.icon, @required this.title});
  @override
  Widget build(BuildContext context) {
    Size fullSize = MediaQuery.of(context).size;
    return TextButton(
        onPressed: (){
          onPressed();
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(fullSize.width * 0.08),
            color: Utils.numberButtonColor,
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
                  child: icon
              ),
              Expanded(
                child: Container(
                  height: 30,
                  alignment: Alignment.center,
                  child: Text(
                    "$title",
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
    );
  }
}