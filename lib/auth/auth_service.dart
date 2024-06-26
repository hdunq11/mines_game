import 'dart:developer';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minesweeper/auth/rank.dart';
import 'package:minesweeper/auth/rankController.dart';
import 'package:minesweeper/auth/users.dart';

class AuthService {
  final CollectionReference firebaseModelRef;
  final rank = RankController();

  AuthService() : firebaseModelRef = FirebaseFirestore.instance.collection('users');



  Future<void> save(UserModel user) async {
    try {
      print('user: ${user.email}, ${user.password}');
      await firebaseModelRef.add(user.toMap());
      RankModel item = RankModel(ave: 0, best: 0, email: user.email, games: 0, rate: 0, won: 0);
      Future<void> res = rank.save(item);
    } catch (error) {
      print('Failed to save data to Firebase: $error');
    }
  }

  Future<UserModel?> getUser(String email, String password) async {
    try {
      var users = await firebaseModelRef
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .get();

      if (users.docs.isEmpty) {
        return null;
      } else {
        var user = users.docs.first;

        return UserModel(email: user['email'], password: user['password']);
      }
    } catch (error) {
      print('Failed to get user: $error');
      return null;
    }
  }

}