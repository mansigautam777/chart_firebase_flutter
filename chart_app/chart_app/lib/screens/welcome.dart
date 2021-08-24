import 'dart:io';
import 'package:flutter/material.dart';
import 'package:chart_app/repositories/firebase_repository.dart';
import 'package:chart_app/styles/colors.dart';
import 'package:chart_app/screens/register.dart';
import 'package:chart_app/screens/signin.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  static final String routeName = 'welcome';

  final bool isAndroid = Platform.isAndroid;

  final FirebaseRepository firebaseRepository = FirebaseRepository();

  String appleSignInErrorMessage;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            'Reply',
            style: Theme.of(context)
                .textTheme
                .headline3
                .copyWith(color: kPrimaryColor),
          ),
          //Image.asset('images/icons8_comments_48.png'),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                child: Material(
                  color: kPrimaryColorLight,
                  borderRadius: BorderRadius.circular(30.0),
                  elevation: 5.0,
                  child: MaterialButton(
                    minWidth: 400,
                    elevation: 16,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, SignIn.routeName);
                    },
                    child: Text(
                      'Sign in',
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                child: Material(
                  color: kPrimaryColor100,
                  borderRadius: BorderRadius.circular(30.0),
                  child: MaterialButton(
                    minWidth: 400,
                    child: Text(
                      'Register',
                      style: Theme.of(context).textTheme.button,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, Register.routeName);
                    },
                  ),
                ),
              ),
              SizedBox(height: 20.0), // <= NEW
            ],
          ),
        ],
      ),
    );
  }
}
