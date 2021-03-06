import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chart_app/model/cards.dart';
import 'package:chart_app/repositories/firebase_repository.dart';
import 'package:chart_app/services/Authservices.dart';
import 'package:chart_app/styles/colors.dart';
import 'package:chart_app/screens/home.dart';
import 'package:chart_app/screens/welcome.dart';

class Register extends StatefulWidget {
  static final String routeName = 'register';

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final _registerFormKey = GlobalKey<FormState>();
  final FirebaseRepository firebaseRepository = FirebaseRepository();

  String _firstName;
  String _lastName;
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _registerFormKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                Text(
                  'Registration Information',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  style: Theme.of(context).textTheme.bodyText1,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter a first name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: "First Name"),
                  onSaved: (value) => _firstName = value,
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  style: Theme.of(context).textTheme.bodyText1,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter a last name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: "Last Name"),
                  onSaved: (value) => _lastName = value,
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  style: Theme.of(context).textTheme.bodyText1,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: "Email Address"),
                  onSaved: (value) => _email = value,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter an email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  style: Theme.of(context).textTheme.bodyText1,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if(value.length < 6) {
                      return 'Password should be at least 6 characters';
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Password"),
                  onSaved: (value) => _password = value,
                ),
                SizedBox(height: 40.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(30.0),
                    color: kPrimaryColor200,
                    child: MaterialButton(
                      minWidth: 400,
                      child: Text("SIGN UP"),
                      onPressed: validateAndRegisterUser,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  var savedString = '';
  validateAndRegisterUser() async {
    final form = _registerFormKey.currentState;
    form.save();
    // Validate information was correctly entered
    if (form.validate()) {
      print('Form was successfully validated');
      print('Registering user: First Name: $_firstName | Last Name: $_lastName Email: | $_email Password: $_password');
      // Call the login method with the enter information
      registerUserWithEmailAndPassword();
      //storing register details in local database                   
    }
  }

  void registerUserWithEmailAndPassword() async {
    try {
      auth.User newUser =
          await Provider.of<AuthService>(context, listen: false)
              .registerUserWithEmailAndPassword(
                  firstName: _firstName,
                  lastName: _lastName,
                  email: _email,
                  password: _password);
      if(newUser != null) {
        print('Registered user: ${newUser.uid} | Name: ${newUser.displayName} | Email: ${newUser.email} | Password: $_password}');
        // Create a new user in the database
        firebaseRepository.createUserInDatabaseWithEmail(newUser);
        /// Make sure user was also signed in after registration
        auth.User currentUser = await Provider.of<AuthService>(context, listen: false).getUser();
        if(currentUser != null) {
          print('Registered user was signed in: ${currentUser.uid}');
          List<MessageCard> personalMessages = await firebaseRepository.getPersonalMessages(currentUser);
          for(MessageCard messageCard in personalMessages) {
            print(messageCard);
          }
        }
        else {
          print('User was registered but not signed in!');
        }
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => Home(firebaseUser: newUser,)),
                (Route<dynamic> route) => false);
      }
    } on auth.FirebaseAuthException catch (error) {
      print('AuthException: ' + error.message.toString());
      return _buildErrorDialog(context, error.toString());
    }
  }

  Future _buildErrorDialog(BuildContext context, _message) {

    String errorMessage = 'error';
    bool returnToWelcomeScreen = false;

    return showDialog(
      builder: (context) {
        switch(_message) {
          case 'PlatformException(ERROR_EMAIL_ALREADY_IN_USE, The email address is already in use by another account., null)':
            errorMessage = 'This account is already registered. Please return to sign in';
            returnToWelcomeScreen = true;
            break;
          case 'PlatformException(ERROR_NETWORK_REQUEST_FAILED, A network error (such as timeout, interrupted connection or unreachable host) has occurred., null)':
            errorMessage = 'A network error has occurred. Please try again when the connection is stable';
            returnToWelcomeScreen = true;
            break;
          case 'PlatformException(ERROR_INVALID_EMAIL, The email address is badly formatted., null)':
            errorMessage = 'Invalid email. Please enter a valid email';
            returnToWelcomeScreen = false;
            break;
          default:
            errorMessage = 'Unknown error occurred';
            returnToWelcomeScreen = true;
            break;
        }
        return AlertDialog(
          title: Text('Error Message', style: Theme.of(context).textTheme.headline6),
          content: Text(errorMessage, style: Theme.of(context).textTheme.bodyText1),
          actions: [
            FlatButton(
                child: Text('OK'),
                onPressed: () {
                  returnToWelcomeScreen ? Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (BuildContext context) => Welcome()),
                          (Route<dynamic> route) => false) : Navigator.of(context).pop();
                })

          ],
        );
      },
      context: context,
    );
  }
}
