import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserProfileInfo extends StatelessWidget {
  String? urlName;
  String? userName;
  String? emailID;

  UserProfileInfo({
    Key? key,
    this.urlName,
    this.userName,
    this.emailID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    return Scaffold(
      body: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ignore: avoid_print
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                  arguments['urlName'],
                ),
              ),

              Text(arguments['userName']),
              // Text(arguments['urlName']),
              Text(arguments['emailID']),

              SizedBox(
                height: 25,
              ),

              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/home");
                  },
                  child: Text('Continue')),
            ]),
      ),
    );
  }
}
