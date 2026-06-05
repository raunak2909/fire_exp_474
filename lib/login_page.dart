import 'package:fire_exp_474/home_page.dart';
import 'package:fire_exp_474/sign_up_page.dart';
import 'package:fire_exp_474/ui_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_rounded_btn.dart';

class LoginPage extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  bool isPassVisible = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool isLogin = true;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(11.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Hi, Welcome back!",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 11),
                TextFormField(
                  validator: (value) {
                    RegExp emailRegex = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                    );

                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    } else if (!emailRegex.hasMatch(value)) {
                      return "Please enter a valid email";
                    } else {
                      return null;
                    }
                  },
                  controller: emailController,
                  decoration: mInputFieldDecoration(
                    hintText: "Enter your email here..",
                    labelText: "Email",
                  ),
                ),
                SizedBox(height: 11),
                StatefulBuilder(
                  builder: (context, ss) {
                    return TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password";
                        } else {
                          return null;
                        }
                      },
                      obscureText: !isPassVisible,
                      controller: passController,
                      decoration: mInputFieldDecoration(
                        hintText: "Enter your password here..",
                        labelText: "Password",
                        isPassField: true,
                        isPassVisible: isPassVisible,
                        onTap: () {
                          isPassVisible = !isPassVisible;
                          ss(() {});
                        },
                      ),
                    );
                  },
                ),
                SizedBox(height: 11),
                AppRoundedBtn(
                  isLoading: isLoading,
                  title: isLoading ? "Authenticating user.." : "Login",
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      try {
                        UserCredential userCred = await firebaseAuth
                            .signInWithEmailAndPassword(
                              email: emailController.text,
                              password: passController.text,
                            );

                        if (userCred.user != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Authenticated Successfully!!"),
                              backgroundColor: Colors.green,
                            ),
                          );
                          /// session maintain
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setString("uid", userCred.user!.uid);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        }
                      } on FirebaseAuthException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.code.toString()),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                ),
                SizedBox(height: 5),
                Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                    child: Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(fontSize: 12, color: Colors.black38),
                        children: [
                          TextSpan(
                            text: "Create now..",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink.shade200,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
