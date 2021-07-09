import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:chart_app/services/Authservices.dart';
import 'package:chart_app/styles/colors.dart';
import 'package:chart_app/styles/theme.dart';
import 'add_new_data.dart';
import 'edit_data.dart';
import 'signin.dart';
import 'register.dart';
import 'package:chart_app/viewmodels/add_data.dart';
import 'package:chart_app/screens/home.dart';
import 'welcome.dart';

class MyApp1 extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PersonalMessagesViewModel>(
          create: (context) => PersonalMessagesViewModel(),
        ),
      ],
    );
  }
}

