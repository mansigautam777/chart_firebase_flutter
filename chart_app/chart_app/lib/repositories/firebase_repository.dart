import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:chart_app/model/cards.dart';
import 'package:chart_app/repositories/repository_interface.dart';

class FirebaseRepository with ChangeNotifier implements RepositoryInterface {

  FirebaseRepository();


  final firestoreInstance = FirebaseFirestore.instance;

  static const String USERS_COLLECTION = 'users';

  static const String NAME_FIELD = 'name';
  static const String EMAIL_FIELD = 'email';
  static const String PERSONAL_MESSAGES_FIELD = 'personalMessages';
  static const String CARD_MESSAGE_TITLE_FIELD = 'title';
  static const int CARD_MESSAGE_YEAR_FIELD = 2000;
  static const int CARD_MESSAGE_STAT_FIELD = 2000;








  void createUserInDatabaseWithEmail(auth.User firebaseUser) async {

    await firestoreInstance.collection(USERS_COLLECTION).doc(firebaseUser.uid).set({
      NAME_FIELD : firebaseUser.displayName,
      EMAIL_FIELD: firebaseUser.email,
      PERSONAL_MESSAGES_FIELD : [MessageCard(title: 'Enter - ', year: 2000,stat: 2000).toJson()],

    }).whenComplete(() => print('Created user in database with email. Name: ${firebaseUser.displayName} | Email: ${firebaseUser.email}'));

  }

 

  

  Future<List<MessageCard>> getPersonalMessages(auth.User firebaseUser) async {

    List<MessageCard> personalMessages = List();

    await firestoreInstance.collection(USERS_COLLECTION).doc(firebaseUser.uid).get().then((document) {

      if(document.exists) {

        // Get the List of Maps
        List values = document.get(PERSONAL_MESSAGES_FIELD);
        print('List received: $values');


        // For each map (each message card) in the list, add a MessageCard to the MessageCard list (using the fromJson method)
        for(Map<String, dynamic> map in values ) {
          print('Map received in List: $map');

          /// Create the MessageCard from the map
          MessageCard messageCard = MessageCard.fromJson(map);
          print('Retrieved Message Card: ${messageCard.title} | ${messageCard.year} | ${messageCard.stat}');

          /// Add the MessageCard to the list
          personalMessages.add(messageCard);
          print('Added MessageCard to list: ${personalMessages.last}');

        }
      }
    });


    return personalMessages;

  }

 

  
 
 

 

  void addPersonalMessage(auth.User firebaseUser, MessageCard messageCardToAdd) async {

    Map messageCardData = messageCardToAdd.toJson();

    List messageCardList = [messageCardData];

    await firestoreInstance.collection(USERS_COLLECTION).doc(firebaseUser.uid).update({

      PERSONAL_MESSAGES_FIELD : FieldValue.arrayUnion(messageCardList)

    });
  }

  @override
  void deletePersonalMessage(auth.User firebaseUser, MessageCard messageCardToDelete) async {

    Map messageCardData = messageCardToDelete.toJson();

    List messageCardList = [messageCardData];

    await firestoreInstance.collection(USERS_COLLECTION).doc(firebaseUser.uid).update({

      PERSONAL_MESSAGES_FIELD : FieldValue.arrayRemove(messageCardList)

    });
  }

 
 

 
  @override
  void editPersonalMessage(auth.User firebaseUser, MessageCard oldMessageCard, MessageCard newMessageCard) async {

    /// Delete the oldMessageCard first
    Map oldMessageCardData = oldMessageCard.toJson();

    List oldMessageCardList = [oldMessageCardData];

    await firestoreInstance.collection(USERS_COLLECTION).doc(firebaseUser.uid).update({

      PERSONAL_MESSAGES_FIELD : FieldValue.arrayRemove(oldMessageCardList)

    });

    /// Then add the newMessageCard
    Map newMessageCardData = newMessageCard.toJson();

    List newMessageCardList = [newMessageCardData];

    await firestoreInstance.collection(USERS_COLLECTION).doc(firebaseUser.uid).update({

      PERSONAL_MESSAGES_FIELD : FieldValue.arrayUnion(newMessageCardList)

    });

  }

}