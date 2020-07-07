import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id='welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {

  AnimationController controller;
  Animation animation;

  @override
  void initState() {

    super.initState();
    controller=AnimationController(
          duration: Duration(seconds: 3),
          vsync: this,
          //upperBound: 1,
    );

    //animation=CurvedAnimation(parent: controller,curve: Curves.decelerate);
    //applying curved animation for images height

    animation=ColorTween(begin: Colors.grey,end: Colors.white ).animate(controller);

    controller.forward();

//    animation.addStatusListener((status) {
//      if(status==AnimationStatus.dismissed){
//        controller.forward();
//      }else if(status==AnimationStatus.completed){
//        controller.reverse(from: 1);
//      }
//    });


    controller.addListener(() {
      setState(() {

      });
      //print(controller.value);

    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  speed: Duration(milliseconds: 500),
                  pause: Duration(milliseconds:  1000),
                  totalRepeatCount: 3,
                  text :['Flash Chat'],
                   textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(color: Colors.lightBlueAccent,
              title: 'Log In',
              onPressed: () {
              //Go to login screen.
              Navigator.pushNamed(context, LoginScreen.id);
            },
            ),
            RoundedButton(color: Colors.blueAccent,
              title: 'Register',
              onPressed: () {
                //Go to login screen.
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),

          ],
        ),
      ),
    );
  }
}

