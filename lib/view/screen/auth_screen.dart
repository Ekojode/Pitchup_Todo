import 'package:flutter/material.dart';
import 'package:pitch_todo/model/exceptions.dart';
import 'package:pitch_todo/view/utilities/color.dart';
import 'package:pitch_todo/view/widgets/custom_text_field.dart';
import 'package:pitch_todo/view/widgets/snack_bar.dart';
import 'package:pitch_todo/view_model/auth.dart';
import 'package:provider/provider.dart';

import '../utilities/style.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthStaus _authStaus = AuthStaus.signIn;
  bool _isLoading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _showErrorDialog(String errorMessage) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Error Occurred",
              style: TextStyle(color: Colors.red),
            ),
            content: Text(errorMessage),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Close"))
            ],
          );
        });
  }

  void submit(context, double height) async {
    if (emailController.text.trim().isEmpty &&
        passwordController.text.trim().isEmpty) {
      ShowSnackBar.showSnackBar("Fill in all fields", height);
    } else {
      setState(() {
        _isLoading = true;
      });

      try {
        if (_authStaus == AuthStaus.signIn) {
          await Provider.of<Auth>(context, listen: false).signIn(
            emailController.text.trim(),
            passwordController.text.trim(),
          );
        } else {
          await Provider.of<Auth>(context, listen: false).signUp(
            emailController.text.trim(),
            passwordController.text.trim(),
          );
        }
      } on HttpExceptions catch (e) {
        String errorMessage = "Authentification failed";
        e.toString().isEmpty
            ? _showErrorDialog(errorMessage)
            : _showErrorDialog(e.toString());
      } catch (e) {
        const errorMessage = "Could not authenticate, Pleasse try again later";
        _showErrorDialog(errorMessage);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height1 = MediaQuery.of(context).size.height;
    double width1 = MediaQuery.of(context).size.width;
    double height = height1 > width1 ? height1 : width1;
    double width = height1 > width1 ? width1 : height1;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        title: Text(
          _authStaus == AuthStaus.signIn ? "Sign In" : "Sign Up",
          style: kTextStyle1(height),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(4),
            padding:
                EdgeInsets.symmetric(horizontal: width * 0.02, vertical: 4),
            child: Column(
              children: [
                SizedBox(
                  height: height / 25,
                ),
                CustomTextField(
                  title: "Email",
                  controller: emailController,
                  height: height,
                  hintText: "Enter your email",
                ),
                SizedBox(
                  height: height / 25,
                ),
                CustomTextField(
                  title: "Password",
                  controller: passwordController,
                  height: height,
                  hintText: "Enter your password",
                ),
                SizedBox(
                  height: height / 25,
                ),
                _isLoading
                    ? const CircularProgressIndicator(
                        color: kPinkColor,
                      )
                    : ElevatedButton(
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          submit(context, height);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: kPinkColor),
                        child: Text(
                          _authStaus == AuthStaus.signIn
                              ? 'Sign In'
                              : 'Sign Up',
                          style: kTileStyle(height),
                        ),
                      ),
                SizedBox(
                  height: height / 25,
                ),
                TextButton(
                    onPressed: () {
                      if (_authStaus == AuthStaus.signIn) {
                        setState(() {
                          _authStaus = AuthStaus.signUp;
                        });
                      } else {
                        _authStaus = AuthStaus.signIn;
                      }
                    },
                    child: Text(
                      _authStaus == AuthStaus.signUp
                          ? "Joined us before?, Signin"
                          : "New to Pitch Hub: SignUp",
                      style: kTextStyle8(height),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum AuthStaus {
  signUp,
  signIn,
}
