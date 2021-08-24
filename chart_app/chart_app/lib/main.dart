import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:chart_app/services/Authservices.dart';
import 'package:chart_app/screens/add_new_data.dart';
import 'package:chart_app/screens/edit_data.dart';
import 'package:chart_app/screens/signin.dart';
import 'package:chart_app/screens/register.dart';
import 'package:chart_app/screens/home.dart';
import 'package:chart_app/screens/welcome.dart';
import 'package:chart_app/viewmodels/add_data.dart';
import 'package:chart_app/styles/theme.dart';
import 'package:chart_app/styles/colors.dart';
import 'package:flutter/services.dart';


void main() async {
  // This needs to be called before any Firebase services can be used
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app =
  await Firebase.initializeApp().catchError((error) => print(error));

  runApp(
    ChangeNotifierProvider<AuthService>(
      create: (context) => AuthService(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Charts',
        theme: AppTheme.appThemeData,
        home: FutureBuilder(
            future: Provider.of<AuthService>(context, listen: false).getUser(),
            builder: (context, AsyncSnapshot<auth.User> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.error != null) {
                  print("error");
                  return Text(snapshot.error.toString());
                }
                return snapshot.hasData ? Home(firebaseUser: snapshot.data) : Welcome();
              } else {
                return LoadingCircle();
              }
            }),
        routes: {
          Home.routeName: (context) => Home(),
          SignIn.routeName: (context) => SignIn(),
          Register.routeName: (context) => Register(),
          AddNewMessage.routeName: (context) => AddNewMessage(),
          EditMessage.routeName: (context) => EditMessage(),
          'welcome': (context) => Welcome(),
        },
      ),
    );
  }
}
class LoadingCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: CircularProgressIndicator(
          backgroundColor: kPrimaryColorLight,
        ),
        alignment: Alignment(0.0, 0.0),
      ),
    );
  }
}