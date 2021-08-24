import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chart_app/model/cards.dart';
import 'package:chart_app/viewmodels/add_data.dart';
import 'package:chart_app/services/Authservices.dart';
import 'package:chart_app/styles/colors.dart';

class AddNewMessage extends StatefulWidget {
  static final String routeName = 'addnewmessage';

  @override
  _AddNewMessageState createState() => _AddNewMessageState();
}

class _AddNewMessageState extends State<AddNewMessage> {
  final GlobalKey<ScaffoldState> _scaffoldKeyAddNewMessage =
      GlobalKey<ScaffoldState>();

  final cardMessageTitleTextController = TextEditingController();

  final cardMessageMessageTextController = TextEditingController();

  final cardMessageStatTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeyAddNewMessage,
      appBar: AppBar(
        title: Text('Add new record'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(16, 130, 16, 8),
              child: TextField(
                style: Theme.of(context).textTheme.bodyText2,
                decoration: InputDecoration(
                  icon: Icon(Icons.collections),
                  hintText: 'Enter a title',
                ),
                controller: cardMessageTitleTextController,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: TextField(
                style: Theme.of(context).textTheme.bodyText2,
                decoration: InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: 'Enter year',
                ),
                controller: cardMessageMessageTextController,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: TextField(
                style: Theme.of(context).textTheme.bodyText2,
                decoration: InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: 'Enter the stats',
                ),
                controller: cardMessageStatTextController,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColorLight,
        onPressed: saveNewMessage,
        child: Icon(Icons.save),
      ),
    );
  }

  void saveNewMessage() async {
    auth.User firebaseUser =
        await Provider.of<AuthService>(context, listen: false).getUser();

    if (cardMessageTitleTextController.text.isEmpty ||
        cardMessageMessageTextController.text.isEmpty ||
        cardMessageStatTextController.text.isEmpty) {
      print('User did not enter a title or a message');
      final SnackBar snackBar = SnackBar(
          content: Text(
            'Please enter a title, a year',
            textAlign: TextAlign.center,
          ),
          backgroundColor: kPrimaryColor200,
          elevation: 8,
          duration: Duration(milliseconds: 3000));
      _scaffoldKeyAddNewMessage.currentState.showSnackBar(snackBar);
      return;
    }

    int cardMessage;
    String cardTitle;
    int cardstat;
    MessageCard messageCardToAdd;

    cardTitle = cardMessageTitleTextController.text;
    cardMessage = int.parse(cardMessageMessageTextController.text);
    cardstat = int.parse(cardMessageStatTextController.text);

    messageCardToAdd =
        MessageCard(title: cardTitle, year: cardMessage, stat: cardstat);
    Provider.of<PersonalMessagesViewModel>(context, listen: false)
        .addPersonalMessage(firebaseUser, messageCardToAdd);

    Navigator.pop(context);
  }
}
