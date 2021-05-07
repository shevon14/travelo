import 'package:flutter/material.dart';
import 'package:travel_network/auth_service.dart';
import 'package:travel_network/home.dart';
import 'package:travel_network/provider_widget.dart';
import 'package:travel_network/sign_up_view.dart';

void main() async {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: AuthService(),
      child: MaterialApp(
        theme: new ThemeData(primaryColor: Colors.black),
        home: HomeController(),
        routes: <String, WidgetBuilder>{
          '/signup': (BuildContext context) => SignUpView(
            authFormType: AuthFormType.signUp,
          ),
          '/signin': (BuildContext context) => SignUpView(
            authFormType: AuthFormType.signIn,
          ),
          '/home': (BuildContext context) => HomeController()
        },
      ),
    );
  }
}


class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;
    return StreamBuilder(
        stream: auth.onAuthStateChanged,
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final bool signedIn = snapshot.hasData;
            return signedIn ? Home() : SignUpView( key: key ,authFormType: AuthFormType.signIn);
          }
          return CircularProgressIndicator();
        });
  }
}
