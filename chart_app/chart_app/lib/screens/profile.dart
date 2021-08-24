import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chart_app/services/Authservices.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:chart_app/utils/avatar.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //FirebaseUser user = await FirebaseAuth.instance.currentUser;
  //final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  auth.User _currentUser = auth.FirebaseAuth.instance.currentUser;
  File sampleImage;
  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = tempImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PROFILE'),
        backgroundColor: Color(0xFFFF748C),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFFFFFF), Color(0xFFFFDAE0)])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Center(
              child: sampleImage == null
                  ? Text('Seelect an Image')
                  : enableUpload(),
            ),
            ListTile(
              title: Text(
                na,
                style: TextStyle(
                  fontSize: 40.0,
                  color: Colors.amber,
                ),
              ),
              leading: Icon(
                FontAwesomeIcons.userTag,
                color: Color(0xFFFF748C),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            ListTile(
              title: Text(
                em,
                style: TextStyle(
                  fontSize: 22.0,
                  color: Color(0xFFFF748C),
                ),
              ),
              leading: Icon(
                FontAwesomeIcons.envelope,
                color: Color(0xFFFF748C),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: getImage,
      ),
    );
  }

  Widget enableUpload() {
    return Container(
      child: Column(
        children: <Widget>[
          Image.file(
            sampleImage,
            height: 300,
            width: 300,
          ),
          RaisedButton(
              child: Text('Upload Image'),
              onPressed: () {
                final firebase_storage.Reference ref = firebase_storage
                    .FirebaseStorage.instance
                    .ref('profile/${_currentUser.uid}.jpg');
                final firebase_storage.UploadTask task = firebase_storage
                    .FirebaseStorage.instance
                    .ref('profile/${_currentUser.uid}.jpg')
                    .putFile(sampleImage);
              })
        ],
      ),
    );
  }
}
