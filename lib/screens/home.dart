
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../global/toast.dart';

List<UserModel> users = [];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    _readData();
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("HomePage"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  _createData(UserModel(
                    username: "Anubiz",
                    age: 40,
                    adress: "India",
                  ));
                },
                child: Container(
                  height: 45,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      "Create Data",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 400,
                child: ListView.separated(
                  itemCount: users.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        height: 50,
                        color: Colors.blue,
                        child: Text("${users[index].username}"));
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                ),
              ),
              // StreamBuilder<List<UserModel>>(
              //     stream: _readData(),
              //     builder: (context, snapshot) {
              //       if (snapshot.connectionState == ConnectionState.waiting) {
              //         return Center(
              //           child: CircularProgressIndicator(),
              //         );
              //       }
              //       if (snapshot.data!.isEmpty) {
              //         return Center(child: Text("No Data Yet"));
              //       }
              //       final users = snapshot.data;
              //       return Padding(
              //         padding: EdgeInsets.all(8),
              //         child: Column(
              //             children: users!.map((user) {
              //           return ListTile(
              //             leading: GestureDetector(
              //               onTap: () {
              //                 _deleteData(user.id!);
              //               },
              //               child: Icon(Icons.delete),
              //             ),
              //             trailing: GestureDetector(
              //               onTap: () {
              //                 _updateData(UserModel(
              //                   id: user.id,
              //                   username: "Sreejith",
              //                   adress: "Chalakudi",
              //                 ));
              //               },
              //               child: Icon(Icons.update),
              //             ),
              //             title: Text(user.username!),
              //             subtitle: Text(user.adress!),
              //           );
              //         }).toList()),
              //       );
              //     }),

              GestureDetector(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamed(context, "/login");
                  showToast(message: "Successfully signed out");
                },
                child: Container(
                  height: 45,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      "Sign out",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  List<UserModel> _readData() {
    // ---------------------------------------------------------------//
    //---------- This script will Read data in to Cach Memory --------//
    // ---------------------------------------------------------------//

    final userCollection = FirebaseFirestore.instance.collection("users");
    return userCollection.snapshots().map((qureySnapshot) => qureySnapshot.docs
        .map(
          (e) => UserModel.fromSnapshot(e),
        )
        .toList());
    //----------------------- End here--------------------------------//

    // ---------------------------------------------------------------//
    //---------- This script will Read data from Database---- --------//
    // ---------------------------------------------------------------//
    DatabaseReference db_Ref = FirebaseDatabase.instance.ref().child('users');
    db_Ref.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot;
      Map mymap = data.value as Map<dynamic, dynamic>;
      print(mymap.toString());
      users = convertFirebaseResponseToList(mymap);
      print('userrs::::${users[0]!.username.toString()}');
    });
    return users;
  }

  List<UserModel> convertFirebaseResponseToList(
      Map<dynamic, dynamic> firebaseResponse) {
    final userCollection = FirebaseFirestore.instance.collection("users");
    List<UserModel> users = [];
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
      users.add(user);
    });

    return users;
  }

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
    userCollection.doc(id).set(newUser);
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
  }

  void _updateData(UserModel userModel) {
    final userCollection = FirebaseFirestore.instance.collection("users");

    final newUser = UserModel(
      username: userModel.username,
      id: userModel.id,
      adress: userModel.adress,
      age: userModel.age,
    ).toJson();

    userCollection.doc(userModel.id).update(newUser);
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
