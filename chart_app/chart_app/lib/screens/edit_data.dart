import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chart_app/model/cards.dart';
import 'package:chart_app/services/Authservices.dart';
import 'package:chart_app/styles/colors.dart';
import 'package:chart_app/utils/MessageCardArgument.dart';
import 'package:chart_app/viewmodels/add_data.dart';

class EditMessage extends StatefulWidget {
  static final String routeName = 'editmessage';

  @override
  _EditMessageState createState() => _EditMessageState();
}

class _EditMessageState extends State<EditMessage> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKeyEditMessage =
      GlobalKey<ScaffoldState>();

  final cardMessageTitleTextController = TextEditingController();
  final cardMessageMessageTextController = TextEditingController();
  final cardMessageStatTextController = TextEditingController();

  String _oldMessageCardTitle;
  int _oldMessageCardYear;
  int _oldMessageCardStat;

  MessageCard _oldMessageCard;

  String _newMessageCardTitle;
  int _newMessageCardYear;
  int _newMessageCardStat;

  MessageCard _newMessageCard;

  @override
  Widget build(BuildContext context) {
    // Get the arguments passed from the selectedMessage
    final MessageCardArguments args = ModalRoute.of(context).settings.arguments;

    // Set the text fields using the selected message data
    cardMessageTitleTextController.text = args.title;
    cardMessageMessageTextController.text = args.year.toString();

    // Set the oldMessageCardData
    _oldMessageCardTitle = args.title;
    _oldMessageCardYear = args.year;
    _oldMessageCardStat = args.stat;

    _oldMessageCard = MessageCard(
        title: _oldMessageCardTitle,
        year: _oldMessageCardYear,
        stat: _oldMessageCardStat);

    // Initialize the newMessageCardData in case one or both of the fields are not changed
    _newMessageCardTitle = args.title;
    _newMessageCardYear = args.year;
    _newMessageCardStat = args.stat;

    // Set the MessageCategory

    _newMessageCard = MessageCard(
        title: _newMessageCardTitle, year: _newMessageCardYear, stat: _newMessageCardStat);

    return Scaffold(
      key: _scaffoldKeyEditMessage,
      appBar: AppBar(
        title: Text('Edit record'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(16, 130, 16, 8),
            child: TextField(
              onChanged: (text) {
                _newMessageCardTitle = text;
              },
              controller: cardMessageTitleTextController,
              style: Theme.of(context).textTheme.bodyText2,
              decoration: InputDecoration(
                labelText: 'Enter a new card title',
                icon: Icon(Icons.collections),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: cardMessageMessageTextController,
              onChanged: (text) {
                _newMessageCardYear = int.parse(text);
              },
              style: Theme.of(context).textTheme.bodyText2,
              decoration: InputDecoration(
                labelText: 'Enter a new card year',
                icon: Icon(Icons.mail),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: cardMessageStatTextController,
              onChanged: (text) {
                _newMessageCardStat = int.parse(text);
              },
              style: Theme.of(context).textTheme.bodyText2,
              decoration: InputDecoration(
                labelText: 'Enter a new card stat',
                icon: Icon(Icons.mail),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColorLight,
        child: Icon(Icons.save),
        onPressed: () {
          editMessage();
        },
      ),
    );
  }

  void editMessage() async {
    if (cardMessageTitleTextController.text.isEmpty ||
        cardMessageMessageTextController.text.isEmpty ||
        cardMessageStatTextController.text.isEmpty) {
      print('User did not enter a title or a message');
      final SnackBar snackBar = SnackBar(
        content: Text('Please enter a title and a message'),
      );
      _scaffoldKeyEditMessage.currentState.showSnackBar(snackBar);
    } else {
      auth.User firebaseUser =
          await Provider.of<AuthService>(context, listen: false).getUser();

      _newMessageCard = MessageCard(
          title: _newMessageCardTitle,  year: _newMessageCardYear, stat: _newMessageCardStat);

      // Get the MessageCategory of the Message to edit

      Provider.of<PersonalMessagesViewModel>(context, listen: false)
          .editPersonalMessage(firebaseUser, _oldMessageCard, _newMessageCard);
    }

    Navigator.pop(context);
  }
}

