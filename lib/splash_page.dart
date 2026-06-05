

import 'dart:async';

import 'package:fire_exp_474/home_page.dart';
import 'package:fire_exp_474/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 4), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String uid = prefs.getString("uid") ?? "";

      Widget nextPage = LoginPage();

      if(uid.isNotEmpty){
        nextPage = HomePage();
      }
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => nextPage,));
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlutterLogo(
                    size: 100,
                  ),
                  SizedBox(
                    height: 11,
                  ),
                  Text("Noted", style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),)
                ],
              ),
            ),
            Positioned(
              bottom: 31,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Text.rich(TextSpan(
                      text: "Powered by ",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      children: [
                        TextSpan(text: "WsCube Tech", style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),)
                      ]
                    ), ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      width: 200,
                      height: 0.5,
                      color: Colors.grey,
                    ),
                    Text("Version 1.0.0", style: TextStyle(
                      letterSpacing: 5,
                      fontSize: 10,
                      color: Colors.grey,
                    ),)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
