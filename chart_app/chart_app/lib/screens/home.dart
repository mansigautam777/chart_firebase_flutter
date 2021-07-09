import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:chart_app/model/cards.dart';
import 'package:chart_app/viewmodels/add_data.dart';
import 'package:chart_app/services/Authservices.dart';
import 'package:chart_app/styles/colors.dart';
import 'package:chart_app/utils/MessageCardArgument.dart';
import 'package:chart_app/screens/add_new_data.dart';
import 'package:chart_app/viewmodels/graph.dart';
import 'package:chart_app/screens/edit_data.dart';
import 'package:chart_app/screens/profile.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'welcome.dart';

class Home extends StatefulWidget {
  static final String routeName = 'home';

  final auth.User firebaseUser;

  Home({this.firebaseUser});

  @override
  _HomeState createState() => _HomeState();
}



class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKeyHome = GlobalKey<ScaffoldState>();

  PersonalMessagesViewModel personalMessagesViewModel =
      PersonalMessagesViewModel();

  List<String> appBarTitles = [
    'Personal Messages',
    'Social Messages',
  ];

  Color cardBackgroundColor = kBackgroundColor;

  int selectedItemIndex = -1;

  String initialAppBarTitle = 'Personal Messages';

  TabController _tabController;

  int _currentTabIndex = 0;

  final List<Tab> _tabs = <Tab>[
    Tab(
      icon: Icon(Icons.person),
    ),
    Tab(
      icon: Icon(Icons.group),
    ),
  ];

  MessageCard selectedMessage;

  final bool isAndroid = Platform.isAndroid;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: _tabs.length, vsync: this);
    print(_tabs.length);
    _tabController.addListener(_onTabChanged);

    _currentTabIndex = 0;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget generatePersonalMessagesGridView() {
    /// Had to add load method here as well to reload the data so an added message shows up immediately
    ///
    Provider.of<PersonalMessagesViewModel>(context, listen: false)
        .loadPersonalMessagesList(widget.firebaseUser);

    return Consumer<PersonalMessagesViewModel>(
      builder: (context, personalMessagesViewModel, child) => ListView.builder(
          itemCount: personalMessagesViewModel.personalMessagesList.length,
          padding: EdgeInsets.all(24),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => selectPersonalMessagesGridViewItem(
                  index, personalMessagesViewModel),
              child: Card(
                color: index != selectedItemIndex
                    ? kSurfaceColor
                    : kPrimaryColor200,
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      '${personalMessagesViewModel.personalMessagesList[index].title}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  /// This works for single selection (Unable to deselect the currently selected one by clicking on it, but that's ok because the previous one is deselected when a new one is selected
  void selectPersonalMessagesGridViewItem(
      int index, PersonalMessagesViewModel personalMessagesViewModel) {
    print('Tapped item: $index');
    setState(() {
      selectedItemIndex = index;
      // Set the selected message
      selectedMessage = personalMessagesViewModel.personalMessagesList[index];
      print('Selected message: $selectedMessage');
      // Show a snackbar of the selected message
      _scaffoldKeyHome.currentState.showSnackBar(SnackBar(
        content: Text(
          selectedMessage.year.toString(),
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(color: Colors.white),
        ),
        backgroundColor: kPrimaryColor700,
        elevation: 8,
        duration: Duration(milliseconds: 2000),
      ));
    });
    print('Selected Item: $index');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeyHome,
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
          title: Text(initialAppBarTitle),
          centerTitle: true,
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: handleMenuItemClick,
              itemBuilder: (BuildContext context) {
                return isAndroid
                    ? {'Sign Out'}.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(
                            choice,
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList()
                    : {'Sign Out'}.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(
                            choice,
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList();
              },
            ),
          ],
          bottom: TabBar(
            tabs: _tabs,
            controller: _tabController,
            indicatorColor: kSurfaceColor,
          )),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0.0),
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFFF748C),
              ),
              /* accountName: Text(
                "${_currentUser.uid}",
                style: TextStyle(
                  fontSize: 22.0,
                ),
              ),
              accountEmail: Text(
                'em',
                style: TextStyle(
                  fontSize: 22.0,
                ),
              ), */
              currentAccountPicture: CircleAvatar(
                radius: 50.0,
                backgroundColor: const Color(0xFF778899),
                backgroundImage: new NetworkImage(
                    'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png'),
              ),
            ),
            ListTile(
              title: Text("Home"),
              leading: Icon(
                FontAwesomeIcons.home,
                color: Color(0xFFFF748C),
              ),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
            ),
            ListTile(
              title: Text("Profile"),
              leading: Icon(
                FontAwesomeIcons.home,
                color: Color(0xFFFF748C),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          generatePersonalMessagesGridView(),
          buildgraph(context),
        ],
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: kPrimaryColorLight,
        animatedIcon: AnimatedIcons.menu_arrow,
        children: [
          SpeedDialChild(
            backgroundColor: kPrimaryColorLight,
            onTap: () {
              print('Tapped Send');
              if (selectedMessage == null) {
                _scaffoldKeyHome.currentState.showSnackBar(SnackBar(
                  content: Text(
                    'No message selected',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Colors.white),
                  ),
                  backgroundColor: kPrimaryColor700,
                  elevation: 8,
                  duration: Duration(milliseconds: 5000),
                ));
                return;
              }
              Share.share(selectedMessage.year.toString());
            },
            child: Icon(Icons.email),
          ),
          SpeedDialChild(
            backgroundColor: kPrimaryColorLight,
            onTap: () {
              print('Tapped Preview');
              if (selectedMessage == null) {
                _scaffoldKeyHome.currentState.showSnackBar(SnackBar(
                  content: Text(
                    'No message selected',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Colors.white),
                  ),
                  backgroundColor: kPrimaryColor700,
                  elevation: 8,
                  duration: Duration(milliseconds: 5000),
                ));
                return;
              }
              _previewMessageDialog(selectedMessage.year.toString());
            },
            child: Icon(Icons.visibility),
          ),
          SpeedDialChild(
            backgroundColor: kPrimaryColorLight,
            onTap: () {
              print('Tapped Add');
              Navigator.pushNamed(context, AddNewMessage.routeName)
                  .whenComplete(() {
                reloadData();
                clearSelection();
              });
            },
            child: Icon(Icons.add),
          ),
          SpeedDialChild(
            backgroundColor: kPrimaryColorLight,
            onTap: () async {
              print('Tapped Edit');
              if (selectedMessage == null) {
                _scaffoldKeyHome.currentState.showSnackBar(SnackBar(
                  content: Text(
                    'No message selected',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Colors.white),
                  ),
                  backgroundColor: kPrimaryColor700,
                  elevation: 8,
                  duration: Duration(milliseconds: 5000),
                ));
                return;
              }

              Navigator.pushNamed(context, EditMessage.routeName,
                      arguments: MessageCardArguments(
                          title: selectedMessage.title,
                          year: selectedMessage.year,
                          stat: selectedMessage.stat))
                  .whenComplete(() {
                reloadData();
                clearSelection();
              });
            },
            child: Icon(Icons.edit),
          ),
          SpeedDialChild(
            backgroundColor: kPrimaryColorLight,
            onTap: () {
              print('Tapped Delete');
              if (selectedMessage == null) {
                _scaffoldKeyHome.currentState.showSnackBar(SnackBar(
                  content: Text(
                    'No message selected',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Colors.white),
                  ),
                  backgroundColor: kPrimaryColor700,
                  elevation: 8,
                  duration: Duration(milliseconds: 5000),
                ));
                return;
              }
              switch (_currentTabIndex) {
                case 0:
                  deletePersonalMessage(widget.firebaseUser, selectedMessage);
                  break;
              }
              _scaffoldKeyHome.currentState.showSnackBar(SnackBar(
                content: Text(
                  'Message Deleted!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: Colors.white),
                ),
                backgroundColor: kPrimaryColor700,
                elevation: 8,
                duration: Duration(milliseconds: 2000),
              ));
            },
            child: Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  void handleMenuItemClick(String value) {
    switch (value) {
      case 'Sign Out':
        print('Tapped Sign Out');
        _signOut();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => Welcome()),
            (Route<dynamic> route) => false);
        break;
    }
  }

  void _onTabChanged() {
    /// Only manually set the index if it is changing from a swipe, not a tab selection (indexIsChanging is only true when selecting a tab, and tab index is automatically changed) to avoid setting the index twice when a tab is selected
    if (!_tabController.indexIsChanging)
      setState(() {
        print('Changing to Tab: ${_tabController.index}');
        _currentTabIndex = _tabController.index;
        initialAppBarTitle = appBarTitles[_tabController.index];
      });
  }

  Future<void> _previewMessageDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Message:',
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Divider(
                  thickness: 5,
                  color: kPrimaryColorDark,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  selectedMessage.year.toString(),
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Got it',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: kPrimaryColorDark),
              ),
              onPressed: () {
                setState(() {
                  // Set selectedItemIndex back to -1 to signify a card isn't selected (change the color back to unselected)
                  selectedItemIndex = -1;
                  // Set selectedMessage back to null after dialog is done showing
                  selectedMessage = null;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void deletePersonalMessage(
      auth.User firebaseUser, MessageCard messageCardToDelete) async {
    Provider.of<PersonalMessagesViewModel>(context, listen: false)
        .deletePersonalMessage(firebaseUser, messageCardToDelete);

    // Had to add it here to have the message removed from UI immediately upon deletion
    Provider.of<PersonalMessagesViewModel>(context, listen: false)
        .loadPersonalMessagesList(widget.firebaseUser);

    clearSelection();
  }

  void reloadData() {
    // Had to add it here to have edited message show up in UI immediately upon editing
    Provider.of<PersonalMessagesViewModel>(context, listen: false)
        .loadPersonalMessagesList(widget.firebaseUser);
  }

  void clearSelection() {
    setState(() {
      // Set selectedItemIndex back to -1 to signify a card isn't selected (change the color back to unselected)
      selectedItemIndex = -1;
      // Set selectedMessage back to null after dialog is done showing
      selectedMessage = null;
    });
  }

  void _signOut() async {
    await Provider.of<AuthService>(context, listen: false).signout();
    if (await Provider.of<AuthService>(context, listen: false).getUser() ==
        null) {
      print('Successfully signed out user');
    } else {
      print('Failed to sign out user!');
    }
  }
}
