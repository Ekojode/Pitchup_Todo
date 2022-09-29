import 'package:flutter/material.dart';
import 'package:pitch_todo/view/screen/auth_screen.dart';
import 'package:pitch_todo/view/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

import '../../view_model/auth.dart';
import '../utilities/color.dart';
import '../utilities/style.dart';
import '../widgets/snack_bar.dart';

class VerifyPassword extends StatelessWidget {
  VerifyPassword({Key? key}) : super(key: key);
  final otpController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height1 = MediaQuery.of(context).size.height;
    double width1 = MediaQuery.of(context).size.width;
    double height = height1 > width1 ? height1 : width1;
    double width = height1 > width1 ? width1 : height1;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        foregroundColor: Colors.black,
        title: Text(
          "Verify Password",
          style: kTextStyle1(height),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.02),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(
                title: "OTP Code",
                controller: otpController,
                height: height,
                hintText: "Enter OTP sent to your mail",
              ),
              SizedBox(
                height: height / 25,
              ),
              CustomTextField(
                title: "New Password",
                controller: passwordController,
                height: height,
                hintText: "Enter new password",
              ),
              SizedBox(
                height: height / 25,
              ),
              ElevatedButton(
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                style: ElevatedButton.styleFrom(backgroundColor: kPinkColor),
                child: Text(
                  "Update Password",
                  style: kTileStyle(height),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updatePassword(context, double height) {
    if (otpController.text.trim().isEmpty &&
        passwordController.text.trim().isEmpty) {
      ShowSnackBar.showSnackBar("All fields are required", height);
    } else {
      final auth = Provider.of<Auth>(context, listen: false);
      auth.verifyPRCode(
          otpController.text.trim(), passwordController.text.trim());
    }
  }

  void showErrorDialog(context, String errorMessage) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Password Reset Successful",
              style: TextStyle(color: kPinkColor),
            ),
            content:
                const Text("Password reset is successful, try logging in!"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AuthScreen(),
                      ),
                    );
                  },
                  child: const Text("Login"))
            ],
          );
        });
  }
}
