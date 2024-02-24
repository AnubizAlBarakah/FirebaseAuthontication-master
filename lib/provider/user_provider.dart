import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../model/user/user_model.dart';

class UserProvider with ChangeNotifier {
  List<UserModel> _globelusers = [];
  List<UserModel> get globelusers => _globelusers;

  buildProviderData() {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('users');
    print(' Step 0');
    dbRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot;
      Map mymap = data.value as Map<dynamic, dynamic>;
      // print(mymap.toString());
      _globelusers = convertFirebaseResponseToList(mymap);

      print(' Step 1 userrs::::${_globelusers[0].username.toString()}');
    });
    print(' Step 2 number of record fetched  ${_globelusers.length}');
    notifyListeners();
  }

  List<UserModel> convertFirebaseResponseToList(
      Map<dynamic, dynamic> firebaseResponse) {
    // final userCollection = FirebaseFirestore.instance.collection("users");
    // List<UserModel> users = [];
    firebaseResponse.forEach((key, value) {
      String _id = key;
      String _username = value['username'];
      String _adress = value['adress'];
      int _age = value['age'];

      UserModel user = UserModel(
        username: _username,
        age: _age,
        adress: _adress,
        id: _id,
      );
      _globelusers.add(user);
    });

    return _globelusers;
  }
}
