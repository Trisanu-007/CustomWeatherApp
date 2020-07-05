import 'package:flutter/material.dart';
import 'package:weather_app/find_location.dart';
import 'package:weather_app/home_page.dart';
import 'package:weather_app/login_register/login.dart';
import 'package:weather_app/login_register/register.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/shared_resouces/authentication.dart';

import 'login_register/switcher.dart';
void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Weather App",
      home: ChangeRoute(),
    ),
  );
}

class ChangeRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<CurrentUser>.value(
      value: Authenticate().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}


class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CurrentUser>(context);
    if(user == null){
      return SwitchScreens();
    }
    else{
      return HomePage();
    }
  }
}
