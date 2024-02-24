import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import '../../provider/user_provider.dart';

// import '../webservice/productprovider.dart';

class UserViewModel extends BaseViewModel {
  var users = [];

  UserProvider provider = UserProvider();

  Future<void> init(BuildContext context) async {
    print("-----------------------init provider----------------");

    await provider.buildProviderData();
  }

  // Future<void> setdata() async {
  //   var s = provider.globelrecords;
  //   // print("p length${s.length}");
  //   _users = await provider.globelrecords;
  //   notifyListeners();
  //   // print("_p length${_users.length}");
  // }
//----------------------------------------------------------------------------
//-----------------Functions to Handle FireBase Files-------------------------
//----------------------------------------------------------------------------

  void _createData(UserModel userModel) {
    // ---------------------------------------------------------------//
    //----This script will save the data in to Cach Memory-----
    // ---------------------------------------------------------------//

    final userCollection = FirebaseFirestore.instance.collection("users");
    String id = userCollection.doc().id;
    final newUser = UserModel(
      username: userModel.username,
      age: userModel.age,
      adress: userModel.adress,
      id: id,
    ).toJson();
    // userCollection.doc(id).set(newUser);
    //-------------- Cach Memory Saving end here----------------------//

    // ---------------------------------------------------------------//
    // -------- Firebase Database Saving Start Here ------------------//
    // ---------------------------------------------------------------//
    DatabaseReference db_Ref = FirebaseDatabase.instance.ref().child('users');
    try {
      // Map<String, String> users = {
      //   'name': name,
      //   'email': email,
      //   "password":password,
      //   'phone': phone,
      //   'selectedcategory': selectedcategory.toString(),
      //   "dropdownValue":dropdownValue,
      //   "amt":amt,
      //   'url': url,
      //   'adharno':Adharno
      // };

      db_Ref.push().set(newUser).whenComplete(() {
        // print("inserted");
      });
    } on Exception catch (e) {
      // print(e);
    }
    notifyListeners();
  }

  void _updateData(UserModel userModel) {
    final userCollection = FirebaseFirestore.instance.collection("users");

    final newUser = UserModel(
      username: userModel.username,
      id: userModel.id,
      adress: userModel.adress,
      age: userModel.age,
    ).toJson();

    userCollection.doc(userModel.id).update(newUser); //cach memory
    notifyListeners();
  }

  void _deleteData(String id) {
    final userCollection = FirebaseFirestore.instance.collection("users");

    userCollection.doc(id).delete();
  }
}

class UserModel {
  final String? username;
  final String? adress;
  final int? age;
  final String? id;

  UserModel({this.id, this.username, this.adress, this.age});

  static UserModel fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return UserModel(
      username: snapshot['username'],
      adress: snapshot['adress'],
      age: snapshot['age'],
      id: snapshot['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "age": age,
      "id": id,
      "adress": adress,
    };
  }
}
