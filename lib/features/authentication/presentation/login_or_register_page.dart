import 'package:flutter/material.dart';
import 'package:pixsy/features/authentication/presentation/login_page.dart';
import 'package:pixsy/features/authentication/presentation/register_page.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {

   bool isLogin = true;

  void togglePage(){
    setState(() {
      isLogin = !isLogin;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(isLogin){
      return LoginPage(onTap: togglePage);
    }
    else{
      return RegisterPage(onTap: togglePage);
    }
  }
}