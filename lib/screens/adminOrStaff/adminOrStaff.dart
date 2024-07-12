import 'package:flutter/material.dart';

import 'package:kotchi/auth/login_or_register.dart';

import '../../components/chooseContainer.dart';

class AdminOrStaff extends StatelessWidget {
  const AdminOrStaff({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChooseContainer(
              text: 'Admin',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return LoginOrRegister(role: 'admin',);
                },));
              },
            ),

            ChooseContainer(
              text: 'operationTeam',
              onTap: () {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
    return LoginOrRegister(role: 'staff',);
    },));
    },
            ),
          ],
        ),
      ),
    );
  }
}


