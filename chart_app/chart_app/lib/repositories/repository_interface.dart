import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:chart_app/model/cards.dart';

abstract class RepositoryInterface {

  /// CREATE

  void createUserInDatabaseWithEmail(auth.User user);

  /// GET

  Future<List<MessageCard>> getPersonalMessages(auth.User user);

  
  /// ADD
  void addPersonalMessage(auth.User user, MessageCard messageCardToAdd);

  
  /// EDIT
  void editPersonalMessage(auth.User user, MessageCard oldMessageCard, MessageCard newMessageCard);

  

  /// DELETE
  void deletePersonalMessage(auth.User user, MessageCard messageCardToDelete);

  











}