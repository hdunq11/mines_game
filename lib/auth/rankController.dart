import 'dart:developer';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minesweeper/auth/rank.dart';
import 'package:minesweeper/auth/users.dart';

class RankController {
  final CollectionReference firebaseModelRef;

  RankController() : firebaseModelRef = FirebaseFirestore.instance.collection('rank');


  Future<RankModel?> getItem(String email) async {
    try {
      var item = await firebaseModelRef
          .where('email', isEqualTo: email)
          .get();

      if (item.docs.isEmpty) {
        return null;
      } else {
        var data = item.docs.first;

        return RankModel(ave: data['ave'], best: data['best'], email: data['email'], games: data['games'], rate: data['rate'], won: data['won']);
      }
    } catch (error) {
      print('Failed to get item: $error');
      return null;
    }
  }

  Future<bool> updateGames(String email) async {
    try {
      var items = await firebaseModelRef
          .where('email', isEqualTo: email)
          .get();

      if (items.docs.isEmpty) {
        return false;
      } else {
        var item = items.docs.first;

        // Update the 'games' field for the user
        await firebaseModelRef.doc(item.id).update({'games': item['games']+1});

        return true;
      }
    } catch (error) {
      print('Failed to update games: $error');
      return false;
    }
  }

  Future<bool> updateWon(String email) async {
    try {
      var items = await firebaseModelRef
          .where('email', isEqualTo: email)
          .get();

      if (items.docs.isEmpty) {
        return false;
      } else {
        var item = items.docs.first;

        // Update the 'games' field for the user
        await firebaseModelRef.doc(item.id).update({'won': item['won'] + 1});

        return true;
      }
    } catch (error) {
      print('Failed to update won: $error');
      return false;
    }
  }

  Future<bool> updateRate(String email) async {
    try {
      var items = await firebaseModelRef
          .where('email', isEqualTo: email)
          .get();

      if (items.docs.isEmpty) {
        return false;
      } else {
        var item = items.docs.first;

        // Update the 'games' field for the user
        await firebaseModelRef.doc(item.id).update({'rate': item['rate']+1});

        return true;
      }
    } catch (error) {
      print('Failed to update rate: $error');
      return false;
    }
  }

  Future<void> save(RankModel rank) async {
    try {
      await firebaseModelRef.add(rank.toMap());

    } catch (error) {
      print('Failed to save data to Firebase: $error');
    }
  }

}