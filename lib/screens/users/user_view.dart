import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'user_viewmodel.dart';

class UserView extends StatelessWidget {
  UserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserViewModel>.reactive(
      viewModelBuilder: () => UserViewModel(),
      onViewModelReady: (model) async {
        await Future.wait([model.init(context)]);

        print(
            ' Step 3 After intialization count ------ ${model.provider.globelusers.length}');
      },
      onDispose: (model) {
        Navigator.pushNamed(context, "/home");
      },
      builder: (context, viewModel, child) {
        return Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Color(0xff6175ED), Color(0xffffffff)])),
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                itemCount: viewModel.provider.globelusers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        '${viewModel.provider.globelusers[index].username}'),
                    subtitle:
                        Text("${viewModel.provider.globelusers[index].adress}"),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
