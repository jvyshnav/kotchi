
import 'package:flutter/material.dart';
import 'package:kotchi/screens/signup/login.dart';
import 'package:kotchi/screens/signup/register.dart';

class LoginOrRegister extends StatefulWidget {
  final String role;
  const LoginOrRegister({super.key, required this.role});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  //initially show login page
  bool showLoginPage=true;
  //toggle page
  void togglePages(){

    setState((){
      showLoginPage = !showLoginPage;
    });
  }



  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return LoginScreen(onTap: togglePages, role: widget.role,);
    }else{
      return RegisterPage(onTap: togglePages, role: widget.role,);
    }



  }
}
